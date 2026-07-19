import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

import 'tables.dart';

part 'app_database.g.dart';

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

  // v1: esquema inicial.
  // v2: se agregó PatientProfiles.currentPhase.
  // v3: se agregaron los campos de recordatorio (reminderEnabled,
  //     reminderHour, reminderMinute).
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(patientProfiles, patientProfiles.currentPhase);
          }
          if (from < 3) {
            await m.addColumn(patientProfiles, patientProfiles.reminderEnabled);
            await m.addColumn(patientProfiles, patientProfiles.reminderHour);
            await m.addColumn(patientProfiles, patientProfiles.reminderMinute);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rehabia.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    final cachebase = (await getTemporaryDirectory()).path;
    sqlite3.tempDirectory = cachebase;

    return NativeDatabase.createInBackground(file);
  });
}