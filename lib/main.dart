import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'core/app_theme.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/database/app_database.dart';
import 'core/database/seed_data.dart';
import 'core/database/data_fixes.dart';
import 'core/notifications/notification_service.dart';
import 'core/voice/voice_assistant.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Le decimos al splash nativo (el que configuramos con
  // flutter_native_splash: avatar + "RehabIA" sobre fondo turquesa)
  // que se quede visible, en vez de desaparecer solo apenas Flutter
  // dibuje su primer fotograma. Así evitamos el "doble splash" que
  // viste antes (nativo → pantalla de carga nuestra aparte) — ahora
  // es UNA sola imagen continua hasta que la app esté lista de verdad.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const _Bootstrap());
}

class _BootstrapResult {
  final AppDatabase database;
  final String initialLocation;
  _BootstrapResult({required this.database, required this.initialLocation});
}

/// Hace todo el trabajo de arranque (base de datos, voz,
/// notificaciones) mientras el splash nativo sigue visible por
/// fuera. En cuanto termina, llama a `FlutterNativeSplash.remove()`
/// UNA sola vez, y recién ahí construye la app real.
class _Bootstrap extends StatefulWidget {
  const _Bootstrap();

  @override
  State<_Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<_Bootstrap> {
  late final Future<_BootstrapResult> _future;

  @override
  void initState() {
    super.initState();
    _future = _runBootstrap().then((result) {
      // Quitamos el splash nativo justo aquí — el único punto donde
      // sabemos con certeza que los datos ya están listos.
      FlutterNativeSplash.remove();
      return result;
    });
  }

  Future<_BootstrapResult> _runBootstrap() async {
    await NotificationService.init();
    await VoiceAssistant.init();

    final database = AppDatabase();
    await seedDatabaseIfEmpty(database);
    await applyKnownDataFixes(database);

    final existingProfiles = await database.select(database.patientProfiles).get();
    final initialLocation = existingProfiles.isNotEmpty ? '/home' : '/onboarding';

    if (existingProfiles.isNotEmpty) {
      final profile = existingProfiles.first;
      await VoiceAssistant.applyPreferences(rate: profile.voiceRate, volume: profile.voiceVolume);
    }

    return _BootstrapResult(database: database, initialLocation: initialLocation);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: FutureBuilder<_BootstrapResult>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // El splash nativo sigue tapando la pantalla completa
            // gracias a preserve() — aquí abajo no hace falta dibujar
            // NADA (ni mascota, ni spinner); cualquier cosa que
            // pongamos sería la "segunda imagen" que ya no queremos.
            return const SizedBox.shrink();
          }
          final result = snapshot.data!;
          return ProviderScope(
            overrides: [
              databaseProvider.overrideWithValue(result.database),
            ],
            child: RehabIAApp(initialLocation: result.initialLocation),
          );
        },
      ),
    );
  }
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