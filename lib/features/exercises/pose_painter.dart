import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../core/app_colors.dart';

/// Dibuja los puntos del cuerpo (landmarks) y las líneas que los
/// conectan (el "esqueleto"), sobre la vista de cámara.
///
/// La parte más delicada aquí es la ESCALA: ML Kit nos da las
/// coordenadas de cada punto en el sistema de la imagen cruda de la
/// cámara (por ejemplo, 480x640), pero tenemos que dibujarlas sobre un
/// widget que puede medir otra cosa distinta (por ejemplo 350x600 en
/// pantalla). translateX/translateY hacen esa conversión, tomando en
/// cuenta además que, al rotar el teléfono en vertical, el ancho y el
/// alto de la imagen "cruda" quedan invertidos respecto a lo que ves
/// en pantalla.
class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  PosePainter({
    required this.poses,
    required this.absoluteImageSize,
    required this.rotation,
  });

  // Pares de puntos que se conectan con una línea para formar el
  // "esqueleto" (torso, brazos, piernas).
  static const _connections = [
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow],
    [PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist],
    [PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee],
    [PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle],
    [PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee],
    [PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle],
  ];

  double _translateX(double x, Size size) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
        return x * size.width / absoluteImageSize.height;
      case InputImageRotation.rotation270deg:
        return size.width - x * size.width / absoluteImageSize.height;
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        return x * size.width / absoluteImageSize.width;
    }
  }

  double _translateY(double y, Size size) {
    switch (rotation) {
      case InputImageRotation.rotation90deg:
      case InputImageRotation.rotation270deg:
        return y * size.height / absoluteImageSize.width;
      case InputImageRotation.rotation0deg:
      case InputImageRotation.rotation180deg:
        return y * size.height / absoluteImageSize.height;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = AppColors.success
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final linePaint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.8)
      ..strokeWidth = 3;

    for (final pose in poses) {
      // Líneas del esqueleto.
      for (final pair in _connections) {
        final a = pose.landmarks[pair[0]];
        final b = pose.landmarks[pair[1]];
        if (a == null || b == null) continue;
        if (a.likelihood < 0.4 || b.likelihood < 0.4) continue;

        canvas.drawLine(
          Offset(_translateX(a.x, size), _translateY(a.y, size)),
          Offset(_translateX(b.x, size), _translateY(b.y, size)),
          linePaint,
        );
      }

      // Puntos (uno por articulación detectada con suficiente confianza).
      for (final landmark in pose.landmarks.values) {
        if (landmark.likelihood < 0.4) continue;
        canvas.drawCircle(
          Offset(_translateX(landmark.x, size), _translateY(landmark.y, size)),
          4,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) => true;
}