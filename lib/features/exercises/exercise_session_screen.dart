import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/widgets/mascot_avatar.dart';

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
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  String? _cameraError;

  late final List<_SessionStep> _steps;
  int _currentIndex = 0;

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
      );
      _initializeControllerFuture = _cameraController!.initialize();
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      setState(() => _cameraError = 'No se pudo acceder a la cámara: ${e.description}');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
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

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MascotAvatar(size: 90, pose: MascotPose.celebrando),
            const SizedBox(height: 16),
            const Text(
              '¡Sesión completada! 🎉',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Completaste los ${widget.exercises.length} ejercicios de hoy.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // cierra el diálogo
                Navigator.of(context).pop(); // regresa al catálogo/Home
              },
              child: const Text('Volver'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              exerciseName: _currentExercise.name,
              currentSet: _currentStep.setNumber,
              totalSets: _currentStep.totalSets,
              stepIndex: _currentIndex,
              totalSteps: _steps.length,
            ),
            _BilateralReminderBanner(injuryId: _currentExercise.injuryId),
            Expanded(child: _buildCameraPreview()),
            _buildControls(),
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
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(3.1416),
          child: CameraPreview(_cameraController!),
        );
      },
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: _isTimerBased ? _buildTimerControls() : _buildRepControls(),
    );
  }

  Widget _buildTimerControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$_secondsRemaining s',
          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        const Text('Mantén la posición', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _timerRunning ? _pauseTimer : _startTimer,
            icon: Icon(_timerRunning ? Icons.pause : Icons.play_arrow),
            label: Text(_timerRunning ? 'Pausar' : 'Iniciar'),
          ),
        ),
      ],
    );
  }

  Widget _buildRepControls() {
    final targetReps = _currentExercise.reps ?? 12;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$_completedReps / $targetReps',
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        const Text('Repeticiones', style: TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addRep,
            icon: const Icon(Icons.add),
            label: const Text('Registrar repetición'),
          ),
        ),
      ],
    );
  }
}

/// --- Barra superior: ejercicio actual, serie actual, progreso total ---
class _TopBar extends StatelessWidget {
  final String exerciseName;
  final int currentSet;
  final int totalSets;
  final int stepIndex; // 0-based
  final int totalSteps;

  const _TopBar({
    required this.exerciseName,
    required this.currentSet,
    required this.totalSets,
    required this.stepIndex,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      exerciseName,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Serie $currentSet de $totalSets',
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        // Barra de progreso de TODA la sesión (todos los ejercicios,
        // todas las series) — no solo del ejercicio actual.
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
        const SizedBox(height: 4),
        Text(
          'Paso ${stepIndex + 1} de $totalSteps',
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
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