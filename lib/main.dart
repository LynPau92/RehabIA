import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/app_theme.dart';
import 'core/providers.dart';
import 'core/router.dart';
import 'core/database/app_database.dart';
import 'core/database/seed_data.dart';

void main() async {
  // Necesario porque vamos a hacer trabajo asíncrono (abrir la base de
  // datos y cargar el catálogo) ANTES de llamar a runApp().
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  await seedDatabaseIfEmpty(database);

  runApp(
    // ProviderScope habilita Riverpod en toda la app.
    // Aquí "inyectamos" la base de datos real, sobreescribiendo el
    // databaseProvider que definimos en core/providers.dart.
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
      ],
      child: const RehabIAApp(),
    ),
  );
}

class RehabIAApp extends StatelessWidget {
  const RehabIAApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'RehabIA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}