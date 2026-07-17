import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/widgets/mascot_avatar.dart';
import 'pose_painter.dart';
import 'pose_matching.dart';

/// Un "paso" individual dentro de la sesión: una serie específica de un
/// ejercicio específico. Por ejemplo: (Isométrico de cuádriceps, serie 1),
/// (Deslizamiento de talón, serie 1), (Isométrico de cuádriceps, serie 2)...
class _SessionStep {
  final Exercise exercise;
  final int setNumber; // 1, 2, 3...
  final int totalSets; // cuántas series tiene ESE ejercicio en total

  _SessionStep({required this.exercise, required this.setNumber, required this.totalSets});
}

/// Construye el orden completo de la sesión en "rondas": primero la
/// serie 1 de todos los ejercicios (en el orden del catálogo), luego la
/// serie 2 de los que tengan 2+ series, etc. Así el usuario alterna
/// entre ejercicios en vez de agotar uno antes de pasar al siguiente.
List<_SessionStep> _buildSessionSteps(List<Exercise> exercises) {
  final steps = <_SessionStep>[];
  final maxRounds = exercises
      .map((e) => e.sets ?? 1)
      .fold<int>(1, (a, b) => a > b ? a : b);

  for (int round = 1; round <= maxRounds; round++) {
    for (final exercise in exercises) {
      final totalSets = exercise.sets ?? 1;
      if (round <= totalSets) {
        steps.add(_SessionStep(exercise: exercise, setNumber: round, totalSets: totalSets));
      }
    }
  }
  return steps;
}

/// Pantalla de ejercicio guiado (Módulo 3, Parte A).
///
/// Recorre TODOS los ejercicios de la rutina del día, uno detrás de
/// otro, sin salir de la pantalla — alternando por serie en vez de
/// completar un ejercicio entero antes de pasar al siguiente.
class ExerciseSessionScreen extends ConsumerStatefulWidget {
  final List<Exercise> exercises;

  const ExerciseSessionScreen({super.key, required this.exercises});

  @override
  ConsumerState<ExerciseSessionScreen> createState() => _ExerciseSessionScreenState();
}

class _ExerciseSessionScreenState extends ConsumerState<ExerciseSessionScreen> {
  // Interruptor manual del efecto espejo. Si en tu celular la imagen
  // se ve "al derecho" (como te ve otra persona) en vez de como espejo,
  // cambia esto a `true`. Si se ve invertida (como ahora), déjalo en
  // `false` — significa que CameraX ya la espeja por su cuenta.
  static const bool _mirrorCamera = false;

  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  String? _cameraError;

  // --- Detección de postura (ML Kit) ---
  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  bool _isDetecting = false; // evita procesar un frame nuevo mientras el anterior sigue en curso
  List<Pose> _detectedPoses = [];
  Size? _lastImageSize;
  InputImageRotation _lastRotation = InputImageRotation.rotation0deg;
  bool _postureVisible = false;

  // --- Detección automática por ángulo (prueba de concepto) ---
  double? _currentKneeAngle;
  bool _autoTargetIsA = true; // en repCycle: ¿estamos esperando la postura A o la B?
  int _consecutiveMatchFrames = 0; // debounce: evita falsos positivos por un frame ruidoso
  static const int _framesNeededToConfirm = 3;

  late final List<_SessionStep> _steps;
  int _currentIndex = 0;
  final DateTime _sessionStartedAt = DateTime.now();

  int _completedReps = 0; // solo para dosageType == 'repeticiones'
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _timerRunning = false;

  _SessionStep get _currentStep => _steps[_currentIndex];
  Exercise get _currentExercise => _currentStep.exercise;

  bool get _isTimerBased =>
      _currentExercise.dosageType == 'isometrico' ||
      _currentExercise.dosageType == 'estiramiento';

  @override
  void initState() {
    super.initState();
    _steps = _buildSessionSteps(widget.exercises);
    _resetStepState();
    _initializeCamera();
  }

  /// Reinicia el contador/temporizador para el paso actual (se llama al
  /// entrar a la pantalla y cada vez que avanzamos a un paso nuevo).
  void _resetStepState() {
    _completedReps = 0;
    _secondsRemaining = _currentExercise.holdSeconds ?? 20;
    _timer?.cancel();
    _timerRunning = false;
    _autoTargetIsA = true;
    _consecutiveMatchFrames = 0;
  }

  /// Si el ejercicio actual tiene configuración de detección automática
  /// (por ahora, solo los 3 de la prueba de concepto), la devuelve.
  AutoDetectConfig? get _autoConfig =>
      autoDetectConfigsByExerciseName[_currentExercise.name];

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _cameraError = 'No se encontró ninguna cámara en este dispositivo.');
        return;
      }
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        // ML Kit espera un formato específico según la plataforma:
        // NV21 en Android, BGRA8888 en iOS. Sin esto, la conversión
        // de más abajo (_inputImageFromCameraImage) fallaría.
        imageFormatGroup:
            Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );
      _initializeControllerFuture = _cameraController!.initialize().then((_) {
        // Una vez lista la cámara, empezamos a recibir un flujo
        // continuo de fotogramas (varias veces por segundo) — cada
        // uno pasa por _processCameraImage.
        _cameraController!.startImageStream(_processCameraImage);
      });
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      setState(() => _cameraError = 'No se pudo acceder a la cámara: ${e.description}');
    }
  }

  /// Convierte un fotograma crudo de la cámara (CameraImage) al formato
  /// que ML Kit necesita (InputImage), incluyendo la rotación correcta.
  ///
  /// Simplificación: asumimos que el teléfono siempre se sostiene en
  /// vertical (portrait) — es como está pensada esta app, ya que el
  /// usuario necesita verse de cuerpo entero mientras hace el ejercicio.
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    if (Platform.isAndroid && format != InputImageFormat.nv21) return null;
    if (Platform.isIOS && format != InputImageFormat.bgra8888) return null;
    if (image.planes.isEmpty) return null;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  /// Se llama automáticamente por cada fotograma que entrega la cámara
  /// (varias veces por segundo). Si ya estamos procesando uno, nos
  /// saltamos los siguientes — evita acumular retraso ("frame skipping",
  /// una técnica común para que la app no se sienta lenta).
  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isDetecting = false;
      return;
    }

    try {
      final poses = await _poseDetector.processImage(inputImage);
      if (mounted) {
        setState(() {
          _detectedPoses = poses;
          _lastImageSize = Size(image.width.toDouble(), image.height.toDouble());
          _lastRotation = inputImage.metadata!.rotation;
          _postureVisible = poses.isNotEmpty && _hasGoodVisibility(poses.first);
          _currentKneeAngle = poses.isNotEmpty ? kneeAngleFromPose(poses.first) : null;
        });
        // Fuera del setState porque puede disparar cambios de paso
        // (avanzar de serie, mostrar el diálogo final, etc.) — mejor
        // no anidar esa lógica dentro del propio setState.
        _evaluateAutoDetection();
      }
    } catch (_) {
      // Si un fotograma puntual falla al procesarse, lo ignoramos y
      // seguimos con el siguiente — no vale la pena interrumpir toda
      // la sesión por un error de un solo frame.
    } finally {
      _isDetecting = false;
    }
  }

  /// Revisa si los puntos clave del cuerpo (hombros y caderas) se
  /// detectaron con suficiente confianza. Lo usamos como un indicador
  /// simple de "el usuario está bien ubicado frente a la cámara".
  bool _hasGoodVisibility(Pose pose) {
    const keyPoints = [
      PoseLandmarkType.leftShoulder,
      PoseLandmarkType.rightShoulder,
      PoseLandmarkType.leftHip,
      PoseLandmarkType.rightHip,
    ];
    for (final type in keyPoints) {
      final landmark = pose.landmarks[type];
      if (landmark == null || landmark.likelihood < 0.5) return false;
    }
    return true;
  }

  /// El corazón de la detección automática: revisa si el ángulo de
  /// rodilla detectado coincide con la postura objetivo del ejercicio
  /// actual, y decide qué hacer según el tipo de ejercicio.
  void _evaluateAutoDetection() {
    final config = _autoConfig;
    if (config == null || _currentKneeAngle == null) {
      // Si el ejercicio no tiene detección automática configurada, o
      // no se detecta la rodilla en este fotograma, no hacemos nada
      // (el usuario sigue con el botón manual como respaldo).
      return;
    }
    final angle = _currentKneeAngle!;

    if (config.type == AutoDetectType.isometricHold) {
      _evaluateIsometricHold(config, angle);
    } else {
      _evaluateRepCycle(config, angle);
    }
  }

  /// Ejercicios por TIEMPO: mientras el ángulo coincida con el objetivo,
  /// el cronómetro corre. En cuanto se sale de la postura, se PAUSA
  /// automáticamente (sin perder los segundos ya transcurridos) hasta
  /// que el paciente vuelva a la posición correcta.
  void _evaluateIsometricHold(AutoDetectConfig config, double angle) {
    final isInPosition = config.matchesA(angle);

    if (isInPosition && !_timerRunning) {
      _startTimer();
    } else if (!isInPosition && _timerRunning) {
      _pauseTimer(); // _secondsRemaining se queda tal cual estaba
    }
  }

  /// Ejercicios por REPETICIÓN: alterna entre esperar la postura A y
  /// la postura B. Usamos un pequeño "debounce" (_framesNeededToConfirm)
  /// para exigir que la postura se sostenga varios fotogramas seguidos
  /// antes de aceptarla — así un solo fotograma ruidoso no cuenta una
  /// repetición falsa.
  void _evaluateRepCycle(AutoDetectConfig config, double angle) {
    final matchesExpected =
        _autoTargetIsA ? config.matchesA(angle) : config.matchesB(angle);

    if (!matchesExpected) {
      _consecutiveMatchFrames = 0;
      return;
    }

    _consecutiveMatchFrames++;
    if (_consecutiveMatchFrames < _framesNeededToConfirm) return;
    _consecutiveMatchFrames = 0;

    if (_autoTargetIsA) {
      // Llegó a la postura A: ahora le pedimos la B.
      setState(() => _autoTargetIsA = false);
    } else {
      // Llegó a la postura B, completando el ciclo A→B: cuenta como
      // una repetición y volvemos a pedir la A.
      setState(() => _autoTargetIsA = true);
      _addRep();
    }
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseDetector.close();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          timer.cancel();
          _timerRunning = false;
          _goToNextStep();
        }
      });
    });
    setState(() {});
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _timerRunning = false);
  }

  void _addRep() {
    setState(() => _completedReps++);
    final targetReps = _currentExercise.reps ?? 12;
    if (_completedReps >= targetReps) {
      _goToNextStep();
    }
  }

  /// Avanza al siguiente paso de la sesión (siguiente ejercicio o
  /// siguiente ronda de series), o muestra el diálogo final si ya
  /// no quedan pasos.
  void _goToNextStep() {
    if (_currentIndex < _steps.length - 1) {
      setState(() {
        _currentIndex++;
        _resetStepState();
      });
    } else {
      _showCompletionDialog();
    }
  }

  /// Prevención de errores: salir a medio ejercicio pierde el progreso
  /// de TODA la sesión (no solo del paso actual), así que confirmamos
  /// antes de cerrar — en vez de que un toque accidental en la "X"
  /// borre el avance sin aviso.
  Future<void> _confirmExit() async {
    // Si había un temporizador corriendo, lo pausamos mientras se
    // muestra el diálogo (si el usuario cancela, lo retomamos).
    final wasRunning = _timerRunning;
    if (wasRunning) _pauseTimer();

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Salir del ejercicio?'),
        content: Text(
          'Vas en el paso ${_currentIndex + 1} de ${_steps.length}. '
          'Si sales ahora, perderás el progreso de esta sesión.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.alert),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (shouldExit == true) {
      if (mounted) Navigator.of(context).pop();
    } else if (wasRunning) {
      _startTimer(); // el usuario canceló, retomamos el conteo
    }
  }

  void _showCompletionDialog() {
    int painLevel = 3; // valor inicial del chequeo rápido de dolor

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MascotAvatar(size: 80, pose: MascotPose.celebrando),
                  const SizedBox(height: 12),
                  const Text(
                    '¡Sesión completada! 🎉',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Completaste los ${widget.exercises.length} ejercicios de hoy.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¿Cómo sientes el dolor ahora?',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$painLevel / 10',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  Slider(
                    value: painLevel.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: AppColors.primary,
                    label: '$painLevel',
                    onChanged: (v) => setDialogState(() => painLevel = v.round()),
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _saveSessionAndExit(painLevel),
                  child: const Text('Guardar y volver'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Guarda el resultado de la sesión en la base de datos: el registro
  /// general (Sessions), el detalle por ejercicio (SessionExerciseLogs),
  /// y el chequeo de dolor (PainLogs) — y luego regresa al catálogo/Home.
  Future<void> _saveSessionAndExit(int painLevel) async {
    final db = ref.read(databaseProvider);
    final profile = await (db.select(db.patientProfiles)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();

    if (profile != null) {
      final durationMinutes =
          DateTime.now().difference(_sessionStartedAt).inSeconds / 60.0;

      final session = await db.into(db.sessions).insertReturning(
            SessionsCompanion.insert(
              profileId: profile.id,
              durationMinutes: durationMinutes.round(),
              exercisesCompleted: widget.exercises.length,
              exercisesTotal: widget.exercises.length,
            ),
          );

      // Un registro por cada ejercicio único de la sesión (no por cada
      // "paso"/serie individual, para no duplicar de más).
      for (final exercise in widget.exercises) {
        await db.into(db.sessionExerciseLogs).insert(
              SessionExerciseLogsCompanion.insert(
                sessionId: session.id,
                exerciseId: exercise.id,
                completedSets: Value(exercise.sets ?? 1),
                completedReps: Value(exercise.reps ?? 0),
              ),
            );
      }

      await db.into(db.painLogs).insert(
            PainLogsCompanion.insert(
              profileId: profile.id,
              painLevel: painLevel,
            ),
          );
    }

    if (mounted) {
      Navigator.of(context).pop(); // cierra el diálogo
      Navigator.of(context).pop(); // regresa al catálogo/Home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Proporciones de la pantalla — ajusta estos 3 números si
            // quieres mover el balance (deben sumar 100 para que sea
            // fácil de leer, aunque Flutter solo usa la proporción
            // relativa entre ellos, no el total exacto).
            Expanded(
              flex: 32,
              child: _InstructionCard(
                exercise: _currentExercise,
                currentSet: _currentStep.setNumber,
                totalSets: _currentStep.totalSets,
                stepIndex: _currentIndex,
                totalSteps: _steps.length,
                onClose: _confirmExit,
              ),
            ),
            Expanded(
              flex: 48,
              child: Stack(
                children: [
                  Positioned.fill(child: _buildCameraPreview()),
                  // El banner de bilateralidad ahora "flota" encima de
                  // la cámara en vez de robarle espacio a su flex.
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: _BilateralReminderBanner(injuryId: _currentExercise.injuryId),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 20,
              child: _buildControls(),
            ),
          ],
        ),
      ),
    );
  }

  /// La cámara y el esqueleto dibujado encima, apilados juntos — se
  /// reutiliza tanto si aplicamos el volteo de espejo como si no.
  Widget _buildCameraAndOverlayStack() {
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        if (_lastImageSize != null)
          CustomPaint(
            painter: PosePainter(
              poses: _detectedPoses,
              absoluteImageSize: _lastImageSize!,
              rotation: _lastRotation,
            ),
          ),
      ],
    );
  }

  Widget _buildCameraPreview() {
    if (_cameraError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _cameraError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    if (_initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return FutureBuilder(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _postureVisible ? AppColors.success : AppColors.alert,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // AspectRatio evita que la imagen se vea "estirada":
                // obliga al contenido a respetar la proporción real de
                // la cámara, dejando franjas negras arriba/abajo si no
                // encaja exacto, en vez de deformar la imagen para
                // rellenar todo el espacio disponible.
                //
                // Nota: en modo vertical (portrait) hay que usar el
                // INVERSO de value.aspectRatio — la cámara internamente
                // reporta su proporción en modo horizontal.
                Center(
                  child: AspectRatio(
                    aspectRatio: 1 / _cameraController!.value.aspectRatio,
                    child: _mirrorCamera
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.1416),
                            child: _buildCameraAndOverlayStack(),
                          )
                        : _buildCameraAndOverlayStack(),
                  ),
                ),
                // Mensaje de ayuda cuando no detecta bien la postura.
                if (!_postureVisible)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.alert.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Ubícate de cuerpo entero frente a la cámara',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControls() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      // SingleChildScrollView como red de seguridad: si en algún celular
      // el contenido no cabe en el espacio disponible, se puede
      // desplazar un poquito en vez de desbordarse (el error de
      // "BOTTOM OVERFLOWED" que viste en las capturas).
      child: SingleChildScrollView(
        child: _isTimerBased ? _buildTimerControls() : _buildRepControls(),
      ),
    );
  }

  Widget _buildTimerControls() {
    final auto = _autoConfig;
    final showingAutoStatus = auto != null && auto.type == AutoDetectType.isometricHold;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$_secondsRemaining s',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        if (showingAutoStatus)
          Text(
            _timerRunning
                ? '✅ Postura correcta — cronómetro corriendo'
                : '🔶 Colócate en la posición del ejercicio para iniciar',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _timerRunning ? AppColors.success : AppColors.alert,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          )
        else
          const Text('Mantén la posición', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _timerRunning ? _pauseTimer : _startTimer,
            icon: Icon(_timerRunning ? Icons.pause : Icons.play_arrow),
            label: Text(
              showingAutoStatus
                  ? (_timerRunning ? 'Pausar (manual)' : 'Iniciar (manual)')
                  : (_timerRunning ? 'Pausar' : 'Iniciar'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRepControls() {
    final targetReps = _currentExercise.reps ?? 12;
    final auto = _autoConfig;
    final showingAutoStatus = auto != null && auto.type == AutoDetectType.repCycle;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$_completedReps / $targetReps',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        if (showingAutoStatus)
          Text(
            _autoTargetIsA
                ? '🔶 Ve a la posición inicial descrita arriba'
                : '🔶 Ahora muévete a la posición final',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.assistant, fontWeight: FontWeight.w600, fontSize: 12),
          )
        else
          const Text('Repeticiones', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addRep,
            icon: const Icon(Icons.add),
            label: Text(showingAutoStatus ? 'Registrar manualmente' : 'Registrar repetición'),
          ),
        ),
      ],
    );
  }
}

/// --- Tarjeta superior: nombre, mascota demostrando, instrucciones ---
/// Inspirada en el patrón de Luvu que compartiste: una tarjeta de color
/// con el personaje "haciendo" el ejercicio, antes de la vista de cámara.
class _InstructionCard extends StatelessWidget {
  final Exercise exercise;
  final int currentSet;
  final int totalSets;
  final int stepIndex; // 0-based
  final int totalSteps;
  final VoidCallback onClose;

  const _InstructionCard({
    required this.exercise,
    required this.currentSet,
    required this.totalSets,
    required this.stepIndex,
    required this.totalSteps,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: onClose,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      exercise.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Text(
                      'Serie $currentSet de $totalSets',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48), // balancea el IconButton de la izquierda
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (stepIndex + 1) / totalSteps,
                minHeight: 6,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(AppColors.success),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Paso ${stepIndex + 1} de $totalSteps',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 12),
          // Sin avatar: las instrucciones ahora tienen el protagonismo,
          // con letra grande y buen contraste — la prioridad es que se
          // puedan leer de un vistazo, sin acercarse a la pantalla.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  exercise.instructions,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// --- Recordatorio de trabajar ambos lados del cuerpo ---
/// Aparece solo para lesiones de miembro inferior o superior, ya que
/// para tronco/columna u otras lesiones no aplica de la misma forma.
class _BilateralReminderBanner extends ConsumerWidget {
  final int injuryId;

  const _BilateralReminderBanner({required this.injuryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return FutureBuilder<Injury>(
      future: (db.select(db.injuries)..where((i) => i.id.equals(injuryId))).getSingle(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final region = snapshot.data!.bodyRegion;

        String? message;
        if (region == 'miembro_inferior') {
          message = 'Recuerda ejercitar ambas piernas, aunque la lesión sea de un solo lado.';
        } else if (region == 'miembro_superior') {
          message = 'Recuerda ejercitar ambos brazos, aunque la lesión sea de un solo lado.';
        }
        if (message == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.assistant.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 12.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}