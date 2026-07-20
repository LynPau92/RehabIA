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
import '../../core/voice/voice_assistant.dart';
import 'pose_painter.dart';
import 'pose_matching.dart';

/// Un "paso" individual dentro de la sesión: una serie específica de un
/// ejercicio específico.
class _SessionStep {
  final Exercise exercise;
  final int setNumber;
  final int totalSets;

  _SessionStep({required this.exercise, required this.setNumber, required this.totalSets});
}

/// Construye el orden completo de la sesión en "rondas": primero la
/// serie 1 de todos los ejercicios (en el orden del catálogo), luego la
/// serie 2 de los que tengan 2+ series, etc.
List<_SessionStep> _buildSessionSteps(List<Exercise> exercises) {
  final steps = <_SessionStep>[];
  final maxRounds =
      exercises.map((e) => e.sets ?? 1).fold<int>(1, (a, b) => a > b ? a : b);

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

/// Pantalla de ejercicio guiado: cámara + detección de postura +
/// contador/temporizador automático + asistente de voz.
class ExerciseSessionScreen extends ConsumerStatefulWidget {
  final List<Exercise> exercises;

  const ExerciseSessionScreen({super.key, required this.exercises});

  @override
  ConsumerState<ExerciseSessionScreen> createState() => _ExerciseSessionScreenState();
}

class _ExerciseSessionScreenState extends ConsumerState<ExerciseSessionScreen> {
  static const bool _mirrorCamera = false;

  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  String? _cameraError;

  final PoseDetector _poseDetector = PoseDetector(
    options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
  );
  bool _isDetecting = false;
  List<Pose> _detectedPoses = [];
  Size? _lastImageSize;
  InputImageRotation _lastRotation = InputImageRotation.rotation0deg;
  bool _postureVisible = false;
  DateTime? _stepAnnouncedAt;
  DateTime? _lastPostureWarningAt;
  bool _sessionCompleted = false;

  double? _currentKneeAngle;
  bool _autoTargetIsA = true;
  int _consecutiveMatchFrames = 0;
  static const int _framesNeededToConfirm = 3;
  bool _hasAnnouncedHoldStart = false;

  late final List<_SessionStep> _steps;
  int _currentIndex = 0;
  final DateTime _sessionStartedAt = DateTime.now();

  int _completedReps = 0;
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _timerRunning = false;

  bool _voiceEnabled = true;

  _SessionStep get _currentStep => _steps[_currentIndex];
  Exercise get _currentExercise => _currentStep.exercise;

  bool get _isTimerBased =>
      _currentExercise.dosageType == 'isometrico' ||
      _currentExercise.dosageType == 'estiramiento';

  AutoDetectConfig? get _autoConfig =>
      autoDetectConfigsByExerciseName[_currentExercise.name];

  @override
  void initState() {
    super.initState();
    _steps = _buildSessionSteps(widget.exercises);
    _resetStepState();
    _initializeCamera();
    _announceCurrentStep();
  }

  void _resetStepState() {
    _completedReps = 0;
    _secondsRemaining = _currentExercise.holdSeconds ?? 20;
    _timer?.cancel();
    _timerRunning = false;
    _autoTargetIsA = true;
    _consecutiveMatchFrames = 0;
    _hasAnnouncedHoldStart = false;
  }

  void _announceCurrentStep() {
    _stepAnnouncedAt = DateTime.now();
    final manualNote = _autoConfig == null
        ? ' Este ejercicio lo registras tú mismo con el botón, la cámara no lo cuenta sola.'
        : '';
    VoiceAssistant.speak('${_currentExercise.name}. ${_currentExercise.instructions}$manualNote');
  }

  void _toggleVoice() {
    setState(() {
      VoiceAssistant.toggle();
      _voiceEnabled = VoiceAssistant.enabled;
    });
  }

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
        imageFormatGroup:
            Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );
      _initializeControllerFuture = _cameraController!.initialize().then((_) {
        _cameraController!.startImageStream(_processCameraImage);
      });
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      setState(() => _cameraError = 'No se pudo acceder a la cámara: ${e.description}');
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
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

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting || _sessionCompleted) return;
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
        _evaluateAutoDetection();
        _checkPostureAnnouncement();
      }
    } catch (_) {
      // Ignoramos errores puntuales de un solo fotograma.
    } finally {
      _isDetecting = false;
    }
  }

  /// Avisa por voz cuando el usuario se sale del encuadre, pero con
  /// dos protecciones para que no se vuelva molesto ni interrumpa
  /// otros mensajes:
  ///   1. Período de gracia: no avisa en los primeros 4 segundos
  ///      después de anunciar un ejercicio nuevo (le da tiempo a
  ///      terminar de escuchar las instrucciones).
  ///   2. Enfriamiento: no repite el aviso más de una vez cada 6
  ///      segundos, aunque sigas fuera de cuadro todo ese tiempo.
  void _checkPostureAnnouncement() {
    if (_sessionCompleted || _postureVisible) return;

    final now = DateTime.now();
    if (_stepAnnouncedAt != null &&
        now.difference(_stepAnnouncedAt!) < const Duration(seconds: 4)) {
      return;
    }
    if (_lastPostureWarningAt != null &&
        now.difference(_lastPostureWarningAt!) < const Duration(seconds: 8)) {
      return;
    }

    _lastPostureWarningAt = now;
    // interrupt: false — si el asistente todavía está diciendo las
    // instrucciones del ejercicio (pueden tardar varios segundos),
    // este aviso se OMITE en vez de cortarlas a la mitad. Se vuelve a
    // intentar solo unos milisegundos después, en el siguiente fotograma.
    VoiceAssistant.speak('Ubícate de cuerpo entero frente a la cámara.', interrupt: false);
  }

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

  void _evaluateAutoDetection() {
    final config = _autoConfig;
    if (config == null || _currentKneeAngle == null) return;
    final angle = _currentKneeAngle!;

    if (config.type == AutoDetectType.isometricHold) {
      _evaluateIsometricHold(config, angle);
    } else {
      _evaluateRepCycle(config, angle);
    }
  }

  void _evaluateIsometricHold(AutoDetectConfig config, double angle) {
    var isInPosition = config.matchesA(angle);

    // Si el ejercicio requiere estar sentado/acostado, rechazamos la
    // coincidencia cuando el paciente está claramente de pie — un
    // ángulo de rodilla extendida se ve casi igual de pie que sentado,
    // así que el ángulo solo no bastaba para diferenciarlos.
    if (isInPosition &&
        config.rejectIfStanding &&
        _detectedPoses.isNotEmpty &&
        isLikelyStanding(_detectedPoses.first)) {
      isInPosition = false;
    }

    if (isInPosition && !_timerRunning) {
      if (!_hasAnnouncedHoldStart) {
        _hasAnnouncedHoldStart = true;
        VoiceAssistant.speak('Bien, mantén la posición.', interrupt: false);
      }
      _startTimer();
    } else if (!isInPosition && _timerRunning) {
      _pauseTimer();
    }
  }

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
      setState(() => _autoTargetIsA = false);
    } else {
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
    VoiceAssistant.stop();
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

  void _goToNextStep() {
    if (_currentIndex < _steps.length - 1) {
      setState(() {
        _currentIndex++;
        _resetStepState();
      });
      _announceCurrentStep();
    } else {
      // Detenemos la cámara ANTES de hablar — si la dejáramos corriendo,
      // un aviso de "ubícate frente a la cámara" disparado por un
      // fotograma que llega una fracción de segundo después podría
      // cortar el mensaje de felicitación (justo lo que pasaba antes).
      _sessionCompleted = true;
      _cameraController?.stopImageStream();
      VoiceAssistant.speak('¡Excelente trabajo! Completaste tu sesión de hoy.');
      _showCompletionDialog();
    }
  }

  Future<void> _confirmExit() async {
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
      _startTimer();
    }
  }

  void _showCompletionDialog() {
    int painLevel = 3;

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
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 32,
              child: _InstructionCard(
                exercise: _currentExercise,
                currentSet: _currentStep.setNumber,
                totalSets: _currentStep.totalSets,
                stepIndex: _currentIndex,
                totalSteps: _steps.length,
                onClose: _confirmExit,
                voiceEnabled: _voiceEnabled,
                onToggleVoice: _toggleVoice,
              ),
            ),
            Expanded(
              flex: 48,
              child: Stack(
                children: [
                  Positioned.fill(child: _buildCameraPreview()),
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

        final overlay = Stack(
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
                Center(
                  child: AspectRatio(
                    aspectRatio: 1 / _cameraController!.value.aspectRatio,
                    child: _mirrorCamera
                        ? Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(3.1416),
                            child: overlay,
                          )
                        : overlay,
                  ),
                ),
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
          const Text(
            '📝 Este ejercicio se registra con el botón, no con la cámara',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
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

/// --- Tarjeta superior: nombre, instrucciones, y el botón de voz ---
class _InstructionCard extends StatelessWidget {
  final Exercise exercise;
  final int currentSet;
  final int totalSets;
  final int stepIndex;
  final int totalSteps;
  final VoidCallback onClose;
  final bool voiceEnabled;
  final VoidCallback onToggleVoice;

  const _InstructionCard({
    required this.exercise,
    required this.currentSet,
    required this.totalSets,
    required this.stepIndex,
    required this.totalSteps,
    required this.onClose,
    required this.voiceEnabled,
    required this.onToggleVoice,
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
              IconButton(
                icon: Icon(
                  voiceEnabled ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white,
                ),
                onPressed: onToggleVoice,
              ),
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