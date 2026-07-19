import 'package:drift/drift.dart';

/// ============================================================
/// TABLA 1: Perfil del paciente
/// ============================================================
class PatientProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get age => integer()();
  RealColumn get weightKg => real()();
  TextColumn get email => text().nullable()();

  IntColumn get injuryId =>
      integer().nullable().references(Injuries, #id)();

  IntColumn get painLevel => integer().withDefault(const Constant(0))();

  BoolColumn get hasMedicalIndication =>
      boolean().withDefault(const Constant(false))();
  IntColumn get daysSinceInjury => integer().withDefault(const Constant(0))();
  BoolColumn get hadPriorTherapy =>
      boolean().withDefault(const Constant(false))();

  RealColumn get textScaleFactor => real().withDefault(const Constant(1.0))();

  // En qué fase de ejercicios está actualmente (1 = inicial, 2 = intermedia,
  // 3 = avanzada).
  IntColumn get currentPhase => integer().withDefault(const Constant(1))();

  // --- Recordatorio diario (Módulo 5) ---
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get reminderHour => integer().nullable()(); // 0-23
  IntColumn get reminderMinute => integer().nullable()(); // 0-59

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// ============================================================
/// TABLA 2: Catálogo de lesiones (datos fijos, precargados)
/// ============================================================
class Injuries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()();
  TextColumn get bodyRegion => text()();
  TextColumn get focusDescription => text()();

  TextColumn get redFlagsText => text().withDefault(const Constant(
      'Detén el ejercicio si sientes dolor agudo o punzante superior a 4/10, '
      'inflamación súbita de la articulación o mareos.'))();
}

/// ============================================================
/// TABLA 3: Ejercicios
/// ============================================================
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get injuryId => integer().references(Injuries, #id)();
  IntColumn get phase => integer()();
  IntColumn get orderIndex => integer()();
  TextColumn get name => text()();
  TextColumn get instructions => text()();
  TextColumn get dosageType => text()();
  IntColumn get sets => integer().nullable()();
  IntColumn get reps => integer().nullable()();
  IntColumn get holdSeconds => integer().nullable()();
  TextColumn get imageAsset => text().nullable()();
  BoolColumn get usesCameraTracking =>
      boolean().withDefault(const Constant(false))();
}

/// ============================================================
/// TABLA 4: Sesiones completadas
/// ============================================================
class Sessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(PatientProfiles, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get durationMinutes => integer()();
  IntColumn get exercisesCompleted => integer()();
  IntColumn get exercisesTotal => integer()();
  TextColumn get notes => text().nullable()();
}

/// ============================================================
/// TABLA 5: Detalle de ejercicios por sesión
/// ============================================================
class SessionExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get completedSets => integer().withDefault(const Constant(0))();
  IntColumn get completedReps => integer().withDefault(const Constant(0))();
  RealColumn get postureCorrectPercentage => real().nullable()();
}

/// ============================================================
/// TABLA 6: Registro histórico de dolor
/// ============================================================
class PainLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get profileId => integer().references(PatientProfiles, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get painLevel => integer()();
  TextColumn get note => text().nullable()();
}