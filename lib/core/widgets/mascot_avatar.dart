import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../app_colors.dart';

enum MascotPose { saludando, celebrando, ejercitando }

/// Mini avatar/mascota de RehabIA, con forma de "almohada-animalito".
/// Versión 2: agrega sombra de apoyo, degradados suaves para dar
/// volumen (en vez de colores completamente planos), y ojos más
/// grandes y expresivos.
class MascotAvatar extends StatelessWidget {
  final double size;
  final MascotPose pose;

  const MascotAvatar({
    super.key,
    this.size = 100,
    this.pose = MascotPose.saludando,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      // Un poco más de alto que ancho, para dejarle espacio a la
      // sombra de apoyo debajo del cuerpo.
      height: size * 1.08,
      child: CustomPaint(
        painter: _MascotPainter(pose: pose),
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotPose pose;

  _MascotPainter({required this.pose});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - size.height * 0.02);
    final r = size.width / 2;

    _drawGroundShadow(canvas, size, r);
    _drawEars(canvas, center, r);
    _drawBody(canvas, center, r);
    _drawStitches(canvas, center, r);
    _drawFace(canvas, center, r);
    _drawPaws(canvas, center, r);
  }

  /// Una sombra achatada debajo del cuerpo — le da la sensación de que
  /// la mascota está apoyada sobre una superficie, no flotando.
  void _drawGroundShadow(Canvas canvas, Size size, double r) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.94),
        width: r * 1.3,
        height: r * 0.28,
      ),
      shadowPaint,
    );
  }

  void _drawEars(Canvas canvas, Offset center, double r) {
    final earRadius = r * 0.25;
    final leftEarCenter = Offset(center.dx - r * 0.5, center.dy - r * 0.74);
    final rightEarCenter = Offset(center.dx + r * 0.5, center.dy - r * 0.74);

    for (final earCenter in [leftEarCenter, rightEarCenter]) {
      canvas.drawCircle(
        earCenter,
        earRadius,
        Paint()
          ..shader = ui.Gradient.radial(
            earCenter - Offset(earRadius * 0.3, earRadius * 0.3),
            earRadius * 1.4,
            [AppColors.assistant.withValues(alpha: 0.95), AppColors.assistant],
          ),
      );
      canvas.drawCircle(
        earCenter,
        earRadius * 0.5,
        Paint()..color = AppColors.cardBackground,
      );
    }
  }

  void _drawBody(Canvas canvas, Offset center, double r) {
    final bodyRect = Rect.fromCenter(center: center, width: r * 1.7, height: r * 1.6);
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(r * 0.65));

    // Degradado radial: más claro arriba-izquierda (simula una fuente
    // de luz suave) y el tono normal hacia los bordes — le da volumen
    // sin necesitar sombras complejas.
    final bodyPaint = Paint()
      ..shader = ui.Gradient.radial(
        center - Offset(r * 0.35, r * 0.4),
        r * 1.6,
        [
          Color.lerp(AppColors.assistant, Colors.white, 0.18)!,
          AppColors.assistant,
        ],
      );

    canvas.drawRRect(bodyRRect, bodyPaint);
  }

  void _drawStitches(Canvas canvas, Offset center, double r) {
    final bodyRect = Rect.fromCenter(center: center, width: r * 1.7, height: r * 1.6);
    final stitchPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.02;
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect.deflate(r * 0.13), Radius.circular(r * 0.5)),
      stitchPaint,
    );
  }

  void _drawFace(Canvas canvas, Offset center, double r) {
    // Mejillas.
    final cheekPaint = Paint()..color = AppColors.alert.withValues(alpha: 0.32);
    canvas.drawCircle(Offset(center.dx - r * 0.42, center.dy + r * 0.2), r * 0.12, cheekPaint);
    canvas.drawCircle(Offset(center.dx + r * 0.42, center.dy + r * 0.2), r * 0.12, cheekPaint);

    // Ojos: más grandes, con doble brillo para un look más tierno.
    final eyeCenters = [
      Offset(center.dx - r * 0.27, center.dy - r * 0.03),
      Offset(center.dx + r * 0.27, center.dy - r * 0.03),
    ];
    for (final eyeCenter in eyeCenters) {
      canvas.drawCircle(eyeCenter, r * 0.115, Paint()..color = AppColors.textPrimary);
      canvas.drawCircle(
        eyeCenter + Offset(-r * 0.03, -r * 0.035),
        r * 0.04,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        eyeCenter + Offset(r * 0.035, r * 0.025),
        r * 0.018,
        Paint()..color = Colors.white.withValues(alpha: 0.8),
      );
    }

    // Sonrisa: una curva suave con las puntas ligeramente hacia arriba.
    final smilePath = Path()
      ..moveTo(center.dx - r * 0.24, center.dy + r * 0.12)
      ..quadraticBezierTo(
        center.dx,
        center.dy + r * 0.30,
        center.dx + r * 0.24,
        center.dy + r * 0.12,
      );
    canvas.drawPath(
      smilePath,
      Paint()
        ..color = AppColors.textPrimary
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.055
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawPaws(Canvas canvas, Offset center, double r) {
    void drawPaw(Offset pawCenter, double pawRadius) {
      final pawPaint = Paint()
        ..shader = ui.Gradient.radial(
          pawCenter - Offset(pawRadius * 0.3, pawRadius * 0.3),
          pawRadius * 1.4,
          [
            Color.lerp(AppColors.assistant, Colors.white, 0.15)!,
            AppColors.assistant,
          ],
        );
      canvas.drawCircle(pawCenter, pawRadius, pawPaint);

      // Dos "dedos" en vez de tres — look más limpio y menos recargado
      // que la versión anterior.
      final nailPaint = Paint()..color = AppColors.cardBackground.withValues(alpha: 0.9);
      canvas.drawCircle(pawCenter + Offset(-pawRadius * 0.28, -pawRadius * 0.5), pawRadius * 0.15, nailPaint);
      canvas.drawCircle(pawCenter + Offset(pawRadius * 0.28, -pawRadius * 0.5), pawRadius * 0.15, nailPaint);
    }

    switch (pose) {
      case MascotPose.saludando:
        drawPaw(Offset(center.dx + r * 0.8, center.dy - r * 0.3), r * 0.25);
        break;
      case MascotPose.celebrando:
        drawPaw(Offset(center.dx - r * 0.74, center.dy - r * 0.58), r * 0.23);
        drawPaw(Offset(center.dx + r * 0.74, center.dy - r * 0.58), r * 0.23);
        break;
      case MascotPose.ejercitando:
        drawPaw(Offset(center.dx + r * 0.58, center.dy - r * 0.52), r * 0.23);
        drawPaw(Offset(center.dx - r * 0.78, center.dy + r * 0.1), r * 0.23);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) => oldDelegate.pose != pose;
}