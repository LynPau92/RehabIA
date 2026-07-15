import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import 'tables.dart';

// Esta línea le dice a build_runner qué archivo generar.
// El archivo app_database.g.dart NO existe todavía —
// lo vamos a crear en el siguiente paso con un comando de terminal.
part 'app_database.g.dart';

/// Base de datos local de RehabIA.
///
/// @DriftDatabase le dice al generador de código qué tablas incluir.
/// Cuando corramos build_runner, drift va a crear automáticamente
/// TODO el código repetitivo (queries, clases de datos, etc.) para
/// cada una de estas tablas, basándose en lo que definimos en tables.dart.
@DriftDatabase(tables: [
  PatientProfiles,
  Injuries,
  Exercises,
  Sessions,
  SessionExerciseLogs,
  PainLogs,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // La versión del esquema. La subimos de 1 a 2 porque agregamos la
  // columna currentPhase a PatientProfiles.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Si alguien tiene la versión 1 instalada (sin currentPhase),
          // le agregamos la columna nueva con su valor por defecto (1),
          // sin borrar ningún dato existente.
          if (from < 2) {
            await m.addColumn(patientProfiles, patientProfiles.currentPhase);
          }
        },
      );
}

/// Abre (o crea, si no existe) el archivo físico de la base de datos
/// dentro de la carpeta privada de documentos de la app en el celular.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rehabia.sqlite'));

    // En Android/iOS necesitamos indicar explícitamente qué motor
    // nativo de SQLite usar; sqlite3_flutter_libs se encarga de
    // empaquetarlo dentro de la app.
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}