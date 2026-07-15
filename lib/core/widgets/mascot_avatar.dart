import 'package:flutter/material.dart';
import '../app_colors.dart';

/// Poses disponibles de la mascota. Vamos a ir agregando más
/// (ej. "ejercitando", "corrigiendo postura") cuando construyamos
/// la pantalla de ejercicio guiado.
enum MascotPose { saludando, celebrando }

/// Mini avatar/mascota de RehabIA, con forma de "almohada-animalito"
/// (cuerpo redondeado tipo squircle + orejitas + patitas), dibujado
/// 100% con código (CustomPainter) para no depender de imágenes
/// externas y mantener siempre los colores de AppColors.
///
/// Uso:
///   MascotAvatar(size: 120, pose: MascotPose.saludando)
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
      height: size,
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
    final center = Offset(size.width / 2, size.height / 2 + size.height * 0.03);
    final r = size.width / 2;

    final bodyPaint = Paint()..color = AppColors.assistant;
    final innerEarPaint = Paint()..color = AppColors.cardBackground;
    final cheekPaint = Paint()..color = AppColors.alert.withValues(alpha: 0.35);
    final eyePaint = Paint()..color = AppColors.textPrimary;
    final shinePaint = Paint()..color = Colors.white;

    // --- Orejitas (le dan el aire de "animalito"), dibujadas primero
    // para que el cuerpo las tape parcialmente y queden bien unidas ---
    final earRadius = r * 0.24;
    final leftEarCenter = Offset(center.dx - r * 0.5, center.dy - r * 0.72);
    final rightEarCenter = Offset(center.dx + r * 0.5, center.dy - r * 0.72);
    canvas.drawCircle(leftEarCenter, earRadius, bodyPaint);
    canvas.drawCircle(rightEarCenter, earRadius, bodyPaint);
    canvas.drawCircle(leftEarCenter, earRadius * 0.55, innerEarPaint);
    canvas.drawCircle(rightEarCenter, earRadius * 0.55, innerEarPaint);

    // --- Cuerpo tipo "almohada" (squircle: cuadrado muy redondeado) ---
    final bodyRect = Rect.fromCenter(
      center: center,
      width: r * 1.7,
      height: r * 1.6,
    );
    final bodyRRect = RRect.fromRectAndRadius(bodyRect, Radius.circular(r * 0.65));
    canvas.drawRRect(bodyRRect, bodyPaint);

    // --- Costuras de almohada (detalle sutil en cada esquina) ---
    final stitchPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.025;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bodyRect.deflate(r * 0.12),
        Radius.circular(r * 0.55),
      ),
      stitchPaint,
    );

    // --- Mejillas ---
    canvas.drawCircle(
      Offset(center.dx - r * 0.4, center.dy + r * 0.18),
      r * 0.13,
      cheekPaint,
    );
    canvas.drawCircle(
      Offset(center.dx + r * 0.4, center.dy + r * 0.18),
      r * 0.13,
      cheekPaint,
    );

    // --- Ojos (grandes y dulces, estilo peluche) ---
    canvas.drawCircle(Offset(center.dx - r * 0.26, center.dy - r * 0.02), r * 0.1, eyePaint);
    canvas.drawCircle(Offset(center.dx + r * 0.26, center.dy - r * 0.02), r * 0.1, eyePaint);
    canvas.drawCircle(Offset(center.dx - r * 0.23, center.dy - r * 0.05), r * 0.032, shinePaint);
    canvas.drawCircle(Offset(center.dx + r * 0.29, center.dy - r * 0.05), r * 0.032, shinePaint);

    // --- Sonrisa ---
    final smilePaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.06
      ..strokeCap = StrokeCap.round;
    final smileRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + r * 0.08),
      width: r * 0.55,
      height: r * 0.45,
    );
    canvas.drawArc(smileRect, 0.3, 2.5, false, smilePaint);

    // --- Patitas redondeadas pegadas al cuerpo (no brazos delgados) ---
    final pawPaint = Paint()..color = AppColors.assistant;
    final nailPaint = Paint()..color = AppColors.cardBackground;

    void drawPaw(Offset pawCenter, double pawRadius) {
      canvas.drawCircle(pawCenter, pawRadius, pawPaint);
      // Tres puntitos como "dedos" para el look tierno de peluche.
      for (final dx in [-0.4, 0.0, 0.4]) {
        canvas.drawCircle(
          pawCenter + Offset(pawRadius * dx, -pawRadius * 0.55),
          pawRadius * 0.18,
          nailPaint,
        );
      }
    }

    if (pose == MascotPose.saludando) {
      // Una sola patita levantada saludando, pegada al cuerpo (sin brazo
      // delgado en diagonal que pueda confundirse con otra cosa).
      drawPaw(
        Offset(center.dx + r * 0.78, center.dy - r * 0.28),
        r * 0.26,
      );
    } else {
      // Pose "celebrando": ambas patitas arriba, pegadas al cuerpo.
      drawPaw(Offset(center.dx - r * 0.72, center.dy - r * 0.55), r * 0.24);
      drawPaw(Offset(center.dx + r * 0.72, center.dy - r * 0.55), r * 0.24);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.pose != pose;
}