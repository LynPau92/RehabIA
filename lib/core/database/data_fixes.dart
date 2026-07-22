import 'package:drift/drift.dart' show Value;
import 'app_database.dart';

/// Corrige errores puntuales de datos que quedaron del script que
/// generó el catálogo original (Paso 2b) — por ejemplo, ejercicios
/// "isométricos" a los que se les asignó 8 segundos por defecto sin
/// fijarse en la duración real que decía el propio texto de
/// instrucciones.
///
/// Es seguro correr esta función CADA VEZ que abre la app (por eso la
/// llamamos junto a seedDatabaseIfEmpty en main.dart) — solo actualiza
/// si el valor guardado es distinto al correcto, así que no hace nada
/// en aperturas posteriores una vez ya corregido.
Future<void> applyKnownDataFixes(AppDatabase db) async {
  // Mapa: nombre exacto del ejercicio -> segundos correctos según sus
  // propias instrucciones.
  const fixes = <String, int>{
    'Sostén unipodal': 25, // instrucciones dicen "mantener 20-30 segundos"
  };

  for (final entry in fixes.entries) {
    final exercise = await (db.select(db.exercises)..where((e) => e.name.equals(entry.key)))
        .getSingleOrNull();

    if (exercise != null && exercise.holdSeconds != entry.value) {
      await (db.update(db.exercises)..where((e) => e.id.equals(exercise.id))).write(
        ExercisesCompanion(holdSeconds: Value(entry.value)),
      );
    }
  }
}