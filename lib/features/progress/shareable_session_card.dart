import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../core/app_colors.dart';
import '../../core/database/app_database.dart';

/// Un renglón de datos ya combinados (ejercicio + su registro de esa
/// sesión), para no tener que andar cruzando dos listas dentro del
/// widget.
class ShareableExerciseEntry {
  final Exercise exercise;
  final SessionExerciseLog log;
  ShareableExerciseEntry({required this.exercise, required this.log});
}

/// Colores que van rotando en las tarjetitas de ejercicio, para que
/// se vea variado como en la referencia (Luvu), en vez de todas del
/// mismo tono.
const _cardPalette = [
  AppColors.primary,
  AppColors.alert,
  AppColors.assistant,
  AppColors.success,
];

/// La tarjeta visual que se convierte en imagen para compartir.
/// OJO: este widget nunca se muestra en la navegación normal de la
/// app — se dibuja "fuera de pantalla" solo para capturarlo como PNG
/// (ver `captureSessionCardAsPng` más abajo).
class ShareableSessionCard extends StatelessWidget {
  final String patientName;
  final Session session;
  final List<ShareableExerciseEntry> entries;

  const ShareableSessionCard({
    super.key,
    required this.patientName,
    required this.session,
    required this.entries,
  });

  static const double cardWidth = 720;

  String _dosageText(Exercise exercise, SessionExerciseLog log) {
    switch (exercise.dosageType) {
      case 'isometrico':
      case 'estiramiento':
        return '${exercise.holdSeconds ?? 0} seg';
      default:
        return '${log.completedReps} rep';
    }
  }

  IconData _dosageIcon(Exercise exercise) {
    switch (exercise.dosageType) {
      case 'isometrico':
        return Icons.timer_outlined;
      case 'estiramiento':
        return Icons.self_improvement;
      default:
        return Icons.repeat;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localDate = session.date.toLocal();
    final dateText =
        '${localDate.day}/${localDate.month}/${localDate.year} a las '
        '${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';

    // Mostramos como máximo 8 tarjetas de ejercicio + "+N más", igual
    // que la referencia, para que la imagen no quede eterna.
    final visibleEntries = entries.take(8).toList();
    final extraCount = entries.length - visibleEntries.length;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: cardWidth,
        padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
        decoration: const BoxDecoration(color: AppColors.primary),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              dateText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    value: '${session.durationMinutes} min',
                    icon: Icons.timer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _StatBox(
                    value: '${entries.length} ejercicios',
                    icon: Icons.fitness_center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 2.6,
              children: [
                for (int i = 0; i < visibleEntries.length; i++)
                  _ExerciseChip(
                    name: visibleEntries[i].exercise.name,
                    valueText: _dosageText(visibleEntries[i].exercise, visibleEntries[i].log),
                    icon: _dosageIcon(visibleEntries[i].exercise),
                    color: _cardPalette[i % _cardPalette.length],
                  ),
              ],
            ),
            if (extraCount > 0) ...[
              const SizedBox(height: 12),
              Text(
                '+ $extraCount más',
                style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
            const SizedBox(height: 28),
            Image.asset('assets/branding/avatar.png', width: 130),
            const SizedBox(height: 6),
            const Text(
              'RehabIA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                fontFamily: 'Baloo2',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final IconData icon;
  const _StatBox({required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ExerciseChip extends StatelessWidget {
  final String name;
  final String valueText;
  final IconData icon;
  final Color color;

  const _ExerciseChip({
    required this.name,
    required this.valueText,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  valueText,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Dibuja `card` "fuera de la pantalla visible" (usando el Overlay de
/// Flutter) y lo captura como bytes PNG — así podemos compartirlo como
/// imagen real, no como texto.
Future<Uint8List?> captureSessionCardAsPng(BuildContext context, Widget card) async {
  final repaintKey = GlobalKey();
  final overlay = Overlay.of(context);

  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => Positioned(
      // Muy a la izquierda y arriba, fuera del área visible, pero
      // sigue siendo parte del árbol de widgets real (por eso SÍ se
      // puede capturar como imagen).
      left: -4000,
      top: -4000,
      child: RepaintBoundary(key: repaintKey, child: card),
    ),
  );

  overlay.insert(entry);

  try {
    // Esperamos un par de frames para asegurarnos de que ya se
    // terminó de dibujar (las imágenes como el avatar tardan un
    // instante en decodificarse) antes de capturar.
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;

    final boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: 2.5);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } finally {
    entry.remove();
  }
}