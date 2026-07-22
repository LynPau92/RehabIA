import 'dart:math' as math;
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

double _angleAt(PoseLandmark a, PoseLandmark b, PoseLandmark c) {
  final ab = math.atan2(a.y - b.y, a.x - b.x);
  final cb = math.atan2(c.y - b.y, c.x - b.x);
  var angle = (ab - cb) * 180 / math.pi;
  angle = angle.abs();
  if (angle > 180) angle = 360 - angle;
  return angle;
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

/// Devuelve el lado (izquierdo o derecho) que la cámara ve con más
/// confianza para cadera-rodilla-tobillo, junto con los 3 landmarks.
({PoseLandmark hip, PoseLandmark knee, PoseLandmark ankle, PoseLandmark shoulder})?
    _bestLegSide(Pose pose) {
  final leftConfidence = _minLikelihood(pose, [
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.leftHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.leftAnkle,
  ]);
  final rightConfidence = _minLikelihood(pose, [
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.rightHip,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.rightAnkle,
  ]);

  final useLeft = (leftConfidence ?? 0) >= (rightConfidence ?? 0);
  final confidence = useLeft ? leftConfidence : rightConfidence;
  if (confidence == null || confidence < 0.5) return null;

  return (
    shoulder: pose.landmarks[useLeft ? PoseLandmarkType.leftShoulder : PoseLandmarkType.rightShoulder]!,
    hip: pose.landmarks[useLeft ? PoseLandmarkType.leftHip : PoseLandmarkType.rightHip]!,
    knee: pose.landmarks[useLeft ? PoseLandmarkType.leftKnee : PoseLandmarkType.rightKnee]!,
    ankle: pose.landmarks[useLeft ? PoseLandmarkType.leftAnkle : PoseLandmarkType.rightAnkle]!,
  );
}

/// Ángulo de rodilla (cadera-rodilla-tobillo). 180° = pierna estirada.
double? kneeAngleFromPose(Pose pose) {
  final side = _bestLegSide(pose);
  if (side == null) return null;
  return _angleAt(side.hip, side.knee, side.ankle);
}

/// Heurística simple para saber si el paciente está DE PIE, comparando
/// qué tan "vertical" es el cuerpo (hombro a tobillo) contra qué tan
/// "horizontal" es (ancho entre esos mismos puntos), y revisando que
/// la cadera esté casi tan estirada como la rodilla (torso y muslo en
/// línea recta — así es como se ve estar de pie con la pierna
/// extendida; sentado o acostado se ve distinto).
///
/// No es perfecto, pero es suficiente para evitar el caso más común
/// de falso positivo: contar un ejercicio de "sentado/acostado" mientras
/// el paciente está parado.
bool isLikelyStanding(Pose pose) {
  final side = _bestLegSide(pose);
  if (side == null) return false;

  final verticalSpread = (side.ankle.y - side.shoulder.y).abs();
  final horizontalSpread = [side.shoulder.x, side.hip.x, side.knee.x, side.ankle.x]
          .reduce((a, b) => a > b ? a : b) -
      [side.shoulder.x, side.hip.x, side.knee.x, side.ankle.x].reduce((a, b) => a < b ? a : b);

  final isVerticalBody = verticalSpread > horizontalSpread * 1.3;
  final hipAngle = _angleAt(side.shoulder, side.hip, side.knee);

  // De pie = cuerpo vertical Y cadera casi estirada (torso y muslo en
  // línea recta). Sentado tendría la cadera doblada (~90°); acostado
  // no tendría el cuerpo vertical en absoluto.
  return isVerticalBody && hipAngle > 150;
}

/// Para "Sostén unipodal": en vez de medir un ángulo, comparamos la
/// altura de ambos tobillos. Si uno está considerablemente más arriba
/// que el otro (relativo a tu propia altura corporal en la imagen),
/// significa que levantaste un pie del suelo.
bool isSingleLegStance(Pose pose) {
  final leftAnkle = pose.landmarks[PoseLandmarkType.leftAnkle];
  final rightAnkle = pose.landmarks[PoseLandmarkType.rightAnkle];
  final leftShoulder = pose.landmarks[PoseLandmarkType.leftShoulder];
  final rightShoulder = pose.landmarks[PoseLandmarkType.rightShoulder];

  if (leftAnkle == null || rightAnkle == null || leftShoulder == null || rightShoulder == null) {
    return false;
  }
  if ([leftAnkle, rightAnkle, leftShoulder, rightShoulder].any((l) => l.likelihood < 0.5)) {
    return false;
  }

  final bodyHeight =
      ((leftShoulder.y + rightShoulder.y) / 2 - (leftAnkle.y + rightAnkle.y) / 2).abs();
  if (bodyHeight < 1) return false;

  final ankleDifference = (leftAnkle.y - rightAnkle.y).abs();
  // Umbral: si la diferencia de altura entre tobillos supera el 8% de
  // tu altura corporal en la imagen, consideramos que un pie está
  // levantado del suelo.
  return ankleDifference > bodyHeight * 0.08;
}

enum AutoDetectType { isometricHold, repCycle, singleLegHold }

class AutoDetectConfig {
  final AutoDetectType type;
  final double targetAngleA;
  final double? targetAngleB;
  final double tolerance;

  /// Si es true, rechazamos la coincidencia cuando detectamos que el
  /// paciente está de pie — para ejercicios que requieren estar
  /// sentado o acostado.
  final bool rejectIfStanding;

  const AutoDetectConfig({
    required this.type,
    required this.targetAngleA,
    this.targetAngleB,
    this.tolerance = 15,
    this.rejectIfStanding = false,
  });

  bool matchesA(double angle) => (angle - targetAngleA).abs() <= tolerance;
  bool matchesB(double angle) =>
      targetAngleB != null && (angle - targetAngleB!).abs() <= tolerance;
}

const Map<String, AutoDetectConfig> autoDetectConfigsByExerciseName = {
  // --- Fase 1 ---
  'Isométrico de cuádriceps con rodillo': AutoDetectConfig(
    type: AutoDetectType.isometricHold,
    targetAngleA: 175,
    tolerance: 18,
    rejectIfStanding: true, // este va sentado o acostado, no de pie
  ),
  'Deslizamiento de talón asistido': AutoDetectConfig(
    type: AutoDetectType.repCycle,
    targetAngleA: 170,
    targetAngleB: 100,
    tolerance: 18,
  ),
  'Extensión terminal de rodilla (TKE)': AutoDetectConfig(
    type: AutoDetectType.repCycle,
    targetAngleA: 150,
    targetAngleB: 175,
    tolerance: 12,
  ),

  // --- Fase 2 ---
  'Prensa de piernas con banda': AutoDetectConfig(
    type: AutoDetectType.repCycle,
    targetAngleA: 95, // rodilla flexionada (posición inicial, sentado)
    targetAngleB: 170, // pierna extendida empujando la banda
    tolerance: 20,
    rejectIfStanding: true, // este va sentado
  ),

  // --- Fase 3 ---
  'Sentadilla parcial asistida': AutoDetectConfig(
    type: AutoDetectType.repCycle,
    targetAngleA: 170, // de pie, pierna extendida
    targetAngleB: 135, // sentadilla parcial (cadera baja máximo 45°)
    tolerance: 18,
  ),
  'Sostén unipodal': AutoDetectConfig(
    type: AutoDetectType.singleLegHold,
    targetAngleA: 0, // sin uso en este tipo — se evalúa con isSingleLegStance()
    tolerance: 0,
  ),
};