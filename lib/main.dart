import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'core/app_theme.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/database/app_database.dart';
import 'core/database/seed_data.dart';
import 'core/database/data_fixes.dart';
import 'core/notifications/notification_service.dart';
import 'core/voice/voice_assistant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await VoiceAssistant.init();

  final database = AppDatabase();
  await seedDatabaseIfEmpty(database);
  await applyKnownDataFixes(database);

  final existingProfiles = await database.select(database.patientProfiles).get();
  final initialLocation = existingProfiles.isNotEmpty ? '/home' : '/onboarding';

  // Si ya hay un perfil, aplicamos su velocidad/volumen de voz guardados
  // desde el arranque (en vez de esperar a que abra Ajustes).
  if (existingProfiles.isNotEmpty) {
    final profile = existingProfiles.first;
    await VoiceAssistant.applyPreferences(rate: profile.voiceRate, volume: profile.voiceVolume);
  }

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: RehabIAApp(initialLocation: initialLocation),
    ),
  );
}

class RehabIAApp extends ConsumerWidget {
  final String initialLocation;

  const RehabIAApp({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'RehabIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: buildAppRouter(initialLocation: initialLocation),
      // Aplicamos el tamaño de texto guardado en el perfil a TODA la
      // app, de forma reactiva: si lo cambias en Ajustes, se ve
      // reflejado al instante en cualquier pantalla, sin reiniciar.
      builder: (context, child) {
        return Consumer(
          builder: (context, ref, _) {
            final db = ref.watch(databaseProvider);
            return StreamBuilder<PatientProfile?>(
              stream: (db.select(db.patientProfiles)
                    ..orderBy([(t) => OrderingTerm.desc(t.id)])
                    ..limit(1))
                  .watchSingleOrNull(),
              builder: (context, snapshot) {
                final scale = snapshot.data?.textScaleFactor ?? 1.0;
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}