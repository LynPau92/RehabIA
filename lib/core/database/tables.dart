import 'package:drift/drift.dart';

/// ============================================================
/// TABLA 1: Perfil del paciente
/// ============================================================
/// Guarda los datos que el usuario ingresa en el Onboarding
/// y que puede actualizar luego.
class PatientProfiles extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get age => integer()();
  RealColumn get weightKg => real()();
  TextColumn get email => text().nullable()();

  // Relación con la lesión seleccionada por el usuario.
  IntColumn get injuryId =>
      integer().nullable().references(Injuries, #id)();

  // Nivel de dolor actual, escala 1-10 (requerimiento del Módulo 1).
  IntColumn get painLevel => integer().withDefault(const Constant(0))();

  // Respuestas del cuestionario inicial.
  BoolColumn get hasMedicalIndication =>
      boolean().withDefault(const Constant(false))();
  IntColumn get daysSinceInjury => integer().withDefault(const Constant(0))();
  BoolColumn get hadPriorTherapy =>
      boolean().withDefault(const Constant(false))();

  // Accesibilidad (Módulo 6): factor de escala de texto, 1.0 = normal.
  RealColumn get textScaleFactor => real().withDefault(const Constant(1.0))();

  // En qué fase de ejercicios está actualmente (1 = inicial, 2 = intermedia,
  // 3 = avanzada). Empieza en 1 y solo avanza cuando el usuario confirma
  // que completó la fase anterior sin dolor (regla de tu documento).
  IntColumn get currentPhase => integer().withDefault(const Constant(1))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// ============================================================
/// TABLA 2: Catálogo de lesiones (datos fijos, precargados)
/// ============================================================
/// Estas son las 14 lesiones de tu documento. El usuario NO las
/// crea ni las edita — vienen ya incluidas en la app ("seed data"),
/// y las vamos a insertar en el Paso 2b.
class Injuries extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text()(); // Ej: "Esguince de Tobillo (Grados I y II)"

  // Región anatómica, usada para agrupar el catálogo visualmente
  // (Módulo 2: "catálogo organizado por zona corporal").
  // Valores esperados: 'miembro_inferior', 'miembro_superior',
  // 'tronco_columna', 'otras'
  TextColumn get bodyRegion => text()();

  TextColumn get focusDescription => text()(); // Ej: "Enfoque en devolver la movilidad..."

  // Texto de "Banderas Rojas" que pediste mostrar destacado en cada módulo.
  TextColumn get redFlagsText => text().withDefault(const Constant(
      'Detén el ejercicio si sientes dolor agudo o punzante superior a 4/10, '
      'inflamación súbita de la articulación o mareos.'))();
}

/// ============================================================
/// TABLA 3: Ejercicios (el catálogo completo, ligado a una lesión)
/// ============================================================
class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get injuryId => integer().references(Injuries, #id)();

  // Fase 1 = Inicial, 2 = Intermedia, 3 = Avanzada.
  // Regla de tu documento: no se desbloquea la fase N+1 hasta que
  // el usuario confirme que completó la fase N sin dolor.
  IntColumn get phase => integer()();

  // Orden de aparición dentro de su fase (1, 2, 3...).
  IntColumn get orderIndex => integer()();

  TextColumn get name => text()();
  TextColumn get instructions => text()();

  // 'repeticiones' | 'isometrico' | 'estiramiento'
  // Define qué controles mostrar en pantalla:
  //  - repeticiones  -> series x repeticiones (ej. 2-3 series de 10-15 reps)
  //  - isometrico    -> temporizador de sostenimiento (5-10 segundos)
  //  - estiramiento  -> temporizador continuo (20-30 segundos)
  TextColumn get dosageType => text()();

  IntColumn get sets => integer().nullable()();       // series (si aplica)
  IntColumn get reps => integer().nullable()();        // repeticiones (si aplica)
  IntColumn get holdSeconds => integer().nullable()(); // segundos a sostener (si aplica)

  // Ruta de la imagen/animación demostrativa (Módulo 2).
  // La llenamos más adelante cuando tengamos los assets del avatar.
  TextColumn get imageAsset => text().nullable()();

  // Si este ejercicio se beneficia del seguimiento por cámara (Módulo 3).
  BoolColumn get usesCameraTracking =>
      boolean().withDefault(const Constant(false))();
}

/// ============================================================
/// TABLA 4: Sesiones completadas (historial general)
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
/// Guarda, dentro de cada sesión, cómo le fue al usuario en cada
/// ejercicio específico — incluyendo el % de postura correcta que
/// detecte la cámara (Módulo 3), útil para el resumen de progreso.
class SessionExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get sessionId => integer().references(Sessions, #id)();
  IntColumn get exerciseId => integer().references(Exercises, #id)();

  IntColumn get completedSets => integer().withDefault(const Constant(0))();
  IntColumn get completedReps => integer().withDefault(const Constant(0))();

  // Null si el usuario no usó la cámara en este ejercicio.
  RealColumn get postureCorrectPercentage => real().nullable()();
}

/// ============================================================
/// TABLA 6: Registro histórico de dolor
/// ============================================================
/// Para la escala 1-10 que el usuario reporta periódicamente
/// (Módulo 4: "seguimiento y progreso").
class PainLogs extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get profileId => integer().references(PatientProfiles, #id)();
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
  IntColumn get painLevel => integer()(); // 1-10
  TextColumn get note => text().nullable()();
}