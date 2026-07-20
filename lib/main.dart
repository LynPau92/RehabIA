import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/database/app_database.dart';
import 'core/database/seed_data.dart';
import 'core/notifications/notification_service.dart';
import 'core/voice/voice_assistant.dart';

void main() async {
  // Necesario porque vamos a hacer trabajo asíncrono (abrir la base de
  // datos, cargar el catálogo, y revisar si ya existe un perfil) ANTES
  // de llamar a runApp().
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();
  await VoiceAssistant.init();

  final database = AppDatabase();
  await seedDatabaseIfEmpty(database);

  // Si ya existe al menos un perfil guardado, el usuario ya pasó por
  // el Onboarding antes — entramos directo a Home. Si no hay ninguno
  // (primera vez que se abre la app), mostramos el Onboarding.
  final existingProfiles = await database.select(database.patientProfiles).get();
  final initialLocation = existingProfiles.isNotEmpty ? '/home' : '/onboarding';

  runApp(
    // ProviderScope habilita Riverpod en toda la app.
    // Aquí "inyectamos" la base de datos real, sobreescribiendo el
    // databaseProvider que definimos en core/providers.dart.
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: RehabIAApp(initialLocation: initialLocation),
    ),
  );
}

class RehabIAApp extends StatelessWidget {
  final String initialLocation;

  const RehabIAApp({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RehabIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: buildAppRouter(initialLocation: initialLocation),
    );
  }
}