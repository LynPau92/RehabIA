import 'dart:math' as math;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Calcula el ángulo (en grados) que forma la articulación del medio
/// entre otros dos puntos — por ejemplo, el ángulo de la rodilla usando
/// cadera-rodilla-tobillo. 180° = pierna completamente estirada,
/// valores menores = más flexionada.
double _angleAt(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
  final ab = math.atan2(a.y - b.y, a.x - b.x);
  final cb = math.atan2(c.y - b.y, c.x - b.x);
  var angle = (ab - cb) * 180 / math.pi;
  angle = angle.abs();
  if (angle > 180) angle = 360 - angle;
  return angle;
}

/// Devuelve el ángulo de rodilla (cadera-rodilla-tobillo) usando el
/// lado (izquierdo o derecho) que la cámara esté viendo con más
/// confianza en este fotograma — así no importa cuál pierna esté más
/// de frente a la cámara.
double? kneeAngleFromPose(Pose pose) {
  double? leftConfidence = _minLikelihood(pose, [
    PoseLandmarkType.leftHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.leftAnkle,
  ]);
  double? rightConfidence = _minLikelihood(pose, [
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.rightAnkle,
  ]);

  final useLeft = (leftConfidence ?? 0) >= (rightConfidence ?? 0);
  final confidence = useLeft ? leftConfidence : rightConfidence;
  if (confidence == null || confidence < 0.5) return null;

  final hip = pose.landmarks[useLeft ? PoseLandmarkType.leftHip : PoseLandmarkType.rightHip]!;
  final knee = pose.landmarks[useLeft ? PoseLandmarkType.leftKnee : PoseLandmarkType.rightKnee]!;
  final ankle = pose.landmarks[useLeft ? PoseLandmarkType.leftAnkle : PoseLandmarkType.rightAnkle]!;

  return _angleAt(hip, knee, ankle);
}

double? _minLikelihood(Pose pose, List<PoseLandmarkType> types) {
  double? min;
  for (final type in types) {
    final landmark = pose.landmarks[type];
    if (landmark == null) return null;
    if (min == null || landmark.likelihood < min) min = landmark.likelihood;
  }
  return min;
}

/// Tipo de verificación automática para un ejercicio específico.
enum AutoDetectType {
  /// Ejercicios por tiempo: hay que MANTENER un ángulo objetivo.
  /// Si el paciente se sale de la postura, el cronómetro se pausa.
  isometricHold,

  /// Ejercicios por repetición: alternar entre dos ángulos objetivo
  /// (A y B). Completar el ciclo A→B→A cuenta como 1 repetición.
  repCycle,
}

/// Configuración de detección automática para un ejercicio puntual.
/// Por ahora solo la usamos con los 4 ejercicios de Fractura de Fémur
/// - Fase 1, como prueba de concepto.
class AutoDetectConfig {
  final AutoDetectType type;
  final double targetAngleA; // ángulo objetivo (o único, si es isométrico)
  final double? targetAngleB; // solo para repCycle
  final double tolerance; // margen de error aceptado, en grados

  const AutoDetectConfig({
    required this.type,
    required this.targetAngleA,
    this.targetAngleB,
    this.tolerance = 15,
  });

  bool matchesA(double angle) => (angle - targetAngleA).abs() <= tolerance;
  bool matchesB(double angle) =>
      targetAngleB != null && (angle - targetAngleB!).abs() <= tolerance;
}

/// Prueba de concepto: solo estos 3 ejercicios (identificados por
/// nombre exacto) tienen detección automática por ahora. El cuarto
/// ejercicio de esa fase (Movilización pasiva de rótula) se queda en
/// modo manual a propósito — no es un movimiento de postura corporal
/// que la cámara pueda verificar.
const Map<String, AutoDetectConfig> autoDetectConfigsByExerciseName = {
  'Isométrico de cuádriceps con rodillo': AutoDetectConfig(
    type: AutoDetectType.isometricHold,
    targetAngleA: 175, // pierna extendida
    tolerance: 18,
  ),
  'Deslizamiento de talón asistido': AutoDetectConfig(
    type: AutoDetectType.repCycle,
    targetAngleA: 170, // pierna extendida
    targetAngleB: 100, // rodilla flexionada, talón cerca del glúteo
    tolerance: 18,
  ),
  'Extensión terminal de rodilla (TKE)': AutoDetectConfig(
    type: AutoDetectType.repCycle,
    targetAngleA: 150, // rodilla en reposo, ligeramente flexionada
    targetAngleB: 175, // talón levantado, rodilla casi extendida
    tolerance: 12, // más estricto porque el movimiento es más sutil
  ),
};