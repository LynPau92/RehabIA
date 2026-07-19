import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/providers.dart';
import '../../core/database/app_database.dart';
import '../../core/notifications/notification_service.dart';

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
      ],
    );
  }
}