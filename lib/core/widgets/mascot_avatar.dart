import 'package:flutter/material.dart';

/// Poses disponibles de la mascota. Por ahora solo tenemos UNA
/// ilustración real (creada con IA), así que las 3 poses muestran la
/// misma imagen — el parámetro se queda listo para cuando existan
/// ilustraciones adicionales por pose (solo habría que agregar el
/// archivo nuevo y mapearlo aquí abajo).
enum MascotPose { saludando, celebrando, ejercitando }

class MascotAvatar extends StatelessWidget {
  final double size;
  final MascotPose pose;

  const MascotAvatar({
    super.key,
    this.size = 100,
    this.pose = MascotPose.saludando,
  });

  /// Ruta de la imagen según la pose. Hoy todas apuntan al mismo
  /// archivo; el día que tengas una ilustración distinta para
  /// "celebrando" o "ejercitando", solo cambias la ruta aquí.
  String get _assetPath {
    switch (pose) {
      case MascotPose.saludando:
      case MascotPose.celebrando:
      case MascotPose.ejercitando:
        return 'assets/branding/avatar.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}