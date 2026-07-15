import 'package:flutter/material.dart';

/// Paleta de colores centralizada de RehabIA.
///
/// Regla del proyecto: NINGÚN color se escribe "hardcodeado" (Color(0xFF...))
/// fuera de este archivo. Siempre se importa AppColors y se usa la constante
/// correspondiente. Así, si el día de mañana cambiamos un tono, lo hacemos
/// en un solo lugar y toda la app se actualiza.
class AppColors {
  AppColors._(); // Evita que alguien intente instanciar esta clase.

  static const Color background = Color(0xFFF7FAFC);
  static const Color cardBackground = Color(0xFFEAF4FB);
  static const Color primary = Color(0xFF2BB0C4);
  static const Color success = Color(0xFF6DBF99);
  static const Color alert = Color(0xFFC47A8A);
  static const Color assistant = Color(0xFF9B84CC);
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color border = Color(0xFFE2E8F0);
}