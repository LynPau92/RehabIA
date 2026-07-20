import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/voice/voice_assistant.dart';

/// Pantalla de Ajustes (Módulo 5 y 6): recordatorio diario de
/// ejercicios, y a futuro accesibilidad (tamaño de texto, volumen del
/// asistente de voz).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      backgroundColor: AppColors.background,
      body: StreamBuilder<PatientProfile?>(
        stream: (db.select(db.patientProfiles)
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(1))
            .watchSingleOrNull(),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return _ReminderSection(profile: profile);
        },
      ),
    );
  }
}

class _ReminderSection extends ConsumerWidget {
  final PatientProfile profile;
  const _ReminderSection({required this.profile});

  Future<void> _toggleReminder(WidgetRef ref, bool enabled) async {
    final db = ref.read(databaseProvider);

    if (enabled) {
      // Si nunca eligió hora, usamos 9:00 AM como valor por defecto.
      final hour = profile.reminderHour ?? 9;
      final minute = profile.reminderMinute ?? 0;
      await NotificationService.scheduleDailyReminder(hour: hour, minute: minute);
    } else {
      await NotificationService.cancelReminder();
    }

    await (db.update(db.patientProfiles)..where((t) => t.id.equals(profile.id))).write(
      PatientProfilesCompanion(
        reminderEnabled: Value(enabled),
        reminderHour: Value(profile.reminderHour ?? 9),
        reminderMinute: Value(profile.reminderMinute ?? 0),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final initial = TimeOfDay(
      hour: profile.reminderHour ?? 9,
      minute: profile.reminderMinute ?? 0,
    );

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;

    await NotificationService.scheduleDailyReminder(hour: picked.hour, minute: picked.minute);

    await (db.update(db.patientProfiles)..where((t) => t.id.equals(profile.id))).write(
      PatientProfilesCompanion(
        reminderEnabled: const Value(true),
        reminderHour: Value(picked.hour),
        reminderMinute: Value(picked.minute),
      ),
    );
  }

  String _formatTime(int? hour, int? minute) {
    if (hour == null || minute == null) return '9:00 AM';
    final h = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final period = hour >= 12 ? 'PM' : 'AM';
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m $period';
  }

  Future<void> _updateTextScale(WidgetRef ref, double scale) async {
    final db = ref.read(databaseProvider);
    await (db.update(db.patientProfiles)..where((t) => t.id.equals(profile.id))).write(
      PatientProfilesCompanion(textScaleFactor: Value(scale)),
    );
  }

  Future<void> _updateVoicePrefs(WidgetRef ref, {double? rate, double? volume}) async {
    final db = ref.read(databaseProvider);
    final newRate = rate ?? profile.voiceRate;
    final newVolume = volume ?? profile.voiceVolume;

    await VoiceAssistant.applyPreferences(rate: newRate, volume: newVolume);
    await (db.update(db.patientProfiles)..where((t) => t.id.equals(profile.id))).write(
      PatientProfilesCompanion(voiceRate: Value(newRate), voiceVolume: Value(newVolume)),
    );
  }

  Future<void> _confirmAndResetData(BuildContext context, WidgetRef ref) async {
    final firstConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('¿Borrar todos tus datos?'),
        content: const Text(
          'Esto elimina tu perfil, historial de sesiones y registros de '
          'dolor por completo. No se puede deshacer.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.alert),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
    if (firstConfirm != true || !context.mounted) return;

    // Segunda confirmación, a propósito: es una acción irreversible.
    final secondConfirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Esto es definitivo'),
        content: const Text('¿Segura que quieres borrar TODOS tus datos? Esta es tu última oportunidad de cancelar.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.alert),
            child: const Text('Sí, borrar todo'),
          ),
        ],
      ),
    );
    if (secondConfirm != true || !context.mounted) return;

    final db = ref.read(databaseProvider);
    await NotificationService.cancelReminder();
    await db.delete(db.painLogs).go();
    await db.delete(db.sessionExerciseLogs).go();
    await db.delete(db.sessions).go();
    await db.delete(db.patientProfiles).go();

    if (context.mounted) context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Recordatorios', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Recordatorio diario'),
                subtitle: const Text('Te avisamos todos los días a la hora que elijas.'),
                value: profile.reminderEnabled,
                activeThumbColor: AppColors.primary,
                onChanged: (value) => _toggleReminder(ref, value),
              ),
              if (profile.reminderEnabled) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.access_time, color: AppColors.primary),
                  title: const Text('Hora del recordatorio'),
                  subtitle: Text(_formatTime(profile.reminderHour, profile.reminderMinute)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickTime(context, ref),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'La notificación puede llegar con algunos minutos de diferencia '
            'respecto a la hora exacta — así evitamos pedirte permisos '
            'adicionales de "alarmas exactas".',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ),

        const SizedBox(height: 28),
        Text('Accesibilidad', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.text_fields, color: AppColors.primary),
                    const SizedBox(width: 12),
                    const Text('Tamaño de texto'),
                    const Spacer(),
                    Text('${(profile.textScaleFactor * 100).round()}%',
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                Slider(
                  value: profile.textScaleFactor,
                  min: 0.85,
                  max: 1.6,
                  divisions: 15,
                  activeColor: AppColors.primary,
                  onChanged: (v) => _updateTextScale(ref, v),
                ),
                // Vista previa en vivo, para que sepas qué esperar antes
                // de soltar el slider.
                Text(
                  'Así se ve el texto normal en la app.',
                  style: TextStyle(fontSize: 14 * profile.textScaleFactor),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.speed, color: AppColors.assistant),
                    const SizedBox(width: 12),
                    const Text('Velocidad de la voz'),
                    const Spacer(),
                    Text(
                      profile.voiceRate < 0.4
                          ? 'Lenta'
                          : profile.voiceRate > 0.6
                              ? 'Rápida'
                              : 'Normal',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                Slider(
                  value: profile.voiceRate,
                  min: 0.25,
                  max: 0.75,
                  activeColor: AppColors.assistant,
                  onChanged: (v) => _updateVoicePrefs(ref, rate: v),
                ),
                Row(
                  children: [
                    const Icon(Icons.volume_up, color: AppColors.assistant),
                    const SizedBox(width: 12),
                    const Text('Volumen de la voz'),
                    const Spacer(),
                    Text('${(profile.voiceVolume * 100).round()}%',
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
                Slider(
                  value: profile.voiceVolume,
                  min: 0.1,
                  max: 1.0,
                  activeColor: AppColors.assistant,
                  onChanged: (v) => _updateVoicePrefs(ref, volume: v),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => VoiceAssistant.speak(
                      'Así suena el asistente de voz de RehabIA.',
                    ),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Probar voz'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),
        Text('Datos', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(
          color: AppColors.alert.withValues(alpha: 0.08),
          child: ListTile(
            leading: const Icon(Icons.delete_forever, color: AppColors.alert),
            title: const Text('Borrar todos mis datos', style: TextStyle(color: AppColors.alert)),
            subtitle: const Text('Elimina tu perfil, sesiones y dolor registrado.'),
            onTap: () => _confirmAndResetData(context, ref),
          ),
        ),

        const SizedBox(height: 28),
        Text('Acerca de', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline, color: AppColors.textSecondary),
            title: Text('RehabIA'),
            subtitle: Text('Versión 0.1.0 · App de rehabilitación física en casa'),
          ),
        ),
      ],
    );
  }
}