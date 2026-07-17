// ARCHIVO GENERADO A PARTIR DEL DOCUMENTO DE REQUERIMIENTOS.
// Contiene el catálogo completo de lesiones y ejercicios de RehabIA.
import 'package:drift/drift.dart';
import 'app_database.dart';

/// Carga el catálogo inicial de lesiones y ejercicios en la base de datos,
/// pero solo si la tabla de lesiones está vacía (para no duplicar datos
/// cada vez que se abre la app).
Future<void> seedDatabaseIfEmpty(AppDatabase db) async {
  final existing = await db.select(db.injuries).get();
  if (existing.isNotEmpty) return; // Ya hay datos, no hacer nada.

  final injury0 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Esguince de Tobillo (Grados I y II)',
      bodyRegion: 'miembro_inferior',
      focusDescription: 'Enfoque en devolver la movilidad, activar los tendones peroneos y reentrenar la propiocepción (equilibrio).',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 1,
      orderIndex: 1,
      name: 'Abecedario con el pie',
      instructions: 'Dibujar las letras en el aire con el dedo gordo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 1,
      orderIndex: 2,
      name: 'Bombeo de tobillo',
      instructions: 'Mover el pie arriba y abajo sentado.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 1,
      orderIndex: 3,
      name: 'Arrugar toalla',
      instructions: 'Recoger una toalla con los dedos del pie.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 1,
      orderIndex: 4,
      name: 'Recogida de canicas',
      instructions: 'Agarrar objetos pequeños con los dedos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 2,
      orderIndex: 5,
      name: 'Eversión con banda',
      instructions: 'Jalar el pie hacia afuera contra resistencia elástica.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 2,
      orderIndex: 6,
      name: 'Inversión con banda',
      instructions: 'Jalar el pie hacia adentro contra resistencia.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 2,
      orderIndex: 7,
      name: 'Flexión dorsal con banda',
      instructions: 'Llevar la punta del pie hacia la espinilla.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 2,
      orderIndex: 8,
      name: 'Elevación de talones',
      instructions: 'Pararse de puntitas apoyado en una silla.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 2,
      orderIndex: 9,
      name: 'Elevación de puntas',
      instructions: 'Apoyar talones y levantar las puntas del pie.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 3,
      orderIndex: 10,
      name: 'Equilibrio unipodal',
      instructions: 'Sostenerse en un solo pie por 30 segundos.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 3,
      orderIndex: 11,
      name: 'Equilibrio sobre almohada',
      instructions: 'Pararse en un pie sobre superficie inestable.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury0.id,
      phase: 3,
      orderIndex: 12,
      name: 'Estocadas controladas',
      instructions: 'Dar pasos al frente flexionando rodilla sin dolor.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury1 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Post-Operatorio de Ligamento Cruzado Anterior (LCA - Rodilla)',
      bodyRegion: 'miembro_inferior',
      focusDescription: 'Foco estricto en la extensión completa de la rodilla, activación del cuádriceps y control motor.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 1,
      orderIndex: 1,
      name: 'Extensiones pasivas',
      instructions: 'Colocar un rodillo en el talón, dejando la rodilla al aire.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 1,
      orderIndex: 2,
      name: 'Deslizamiento en pared',
      instructions: 'Sentado, deslizar el pie por la pared para flexionar.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 1,
      orderIndex: 3,
      name: 'Isométrico de cuádriceps',
      instructions: 'Aplastar una toalla bajo la rodilla contra el suelo.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 1,
      orderIndex: 4,
      name: 'Deslizamiento de talón',
      instructions: 'Llevar el talón hacia el glúteo sentado en el suelo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 2,
      orderIndex: 5,
      name: 'Elevación de pierna recta (SLR)',
      instructions: 'Levantar la pierna estirada boca arriba.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 2,
      orderIndex: 6,
      name: 'Elevación lateral de pierna',
      instructions: 'Acostado de lado, levantar la pierna afectada.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 2,
      orderIndex: 7,
      name: 'Puente de glúteos',
      instructions: 'Elevar la cadera con rodillas flexionadas a 90 grados.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 2,
      orderIndex: 8,
      name: 'Isometría en pared',
      instructions: 'Sentadilla estática contra la pared a 45 grados.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 2,
      orderIndex: 9,
      name: 'Prensa con banda',
      instructions: 'Empujar una banda elástica extendiendo la rodilla.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 3,
      orderIndex: 10,
      name: 'Mini sentadilla',
      instructions: 'Flexión de rodillas a 30-45 grados con peso corporal.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 3,
      orderIndex: 11,
      name: 'Paso arriba (Step-up)',
      instructions: 'Subir a un escalón bajo de manera controlada.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 3,
      orderIndex: 12,
      name: 'Paso atrás (Step-down)',
      instructions: 'Bajar del escalón controlando la caída de la rodilla.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury1.id,
      phase: 3,
      orderIndex: 13,
      name: 'Sentadilla unipodal',
      instructions: 'Sentarse y pararse de una silla alta a un solo pie.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury2 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Fractura de Peroné / Tibia (Post-Inmovilización)',
      bodyRegion: 'miembro_inferior',
      focusDescription: 'Apta para cuando el médico retira el yeso o bota ortopédica y autoriza la carga de peso.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 1,
      orderIndex: 1,
      name: 'Estiramiento de pantorrilla',
      instructions: 'Usar una sábana para jalar el pie hacia el cuerpo.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 1,
      orderIndex: 2,
      name: 'Flexión plantar asistida',
      instructions: 'Empujar el pie hacia abajo con las manos suavemente.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 1,
      orderIndex: 3,
      name: 'Masaje de cicatriz',
      instructions: 'Movimientos circulares si hubo cirugía (placas/tornillos).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 1,
      orderIndex: 4,
      name: 'Movilización de rótula',
      instructions: 'Con los dedos, mueve suavemente hacia los lados el hueso redondo que está al frente de tu rodilla (la rótula).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 2,
      orderIndex: 5,
      name: 'Báscula de peso',
      instructions: 'De pie entre dos sillas, pasar el peso de un pie a otro.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 2,
      orderIndex: 6,
      name: 'Sentadilla asistida',
      instructions: 'Agarrado de una mesa, realizar flexión corta.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 2,
      orderIndex: 7,
      name: 'Elevación de talón sentado',
      instructions: 'Levantar talones despegándolos del suelo sentados.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 2,
      orderIndex: 8,
      name: 'Marcha estática',
      instructions: 'Elevar rodillas marchando sin moverse del sitio.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 3,
      orderIndex: 9,
      name: 'Caminata talón-punta',
      instructions: 'Caminar siguiendo una línea recta en el suelo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 3,
      orderIndex: 10,
      name: 'Sentadilla isométrica',
      instructions: 'Sostener posición baja por 15 segundos.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 3,
      orderIndex: 11,
      name: 'Monster walks',
      instructions: 'Caminar de lado con banda elástica en los tobillos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury2.id,
      phase: 3,
      orderIndex: 12,
      name: 'Saltos bipodales mínimos',
      instructions: 'Despegues milimétricos del suelo (fase final).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury3 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Fascitis Plantar',
      bodyRegion: 'miembro_inferior',
      focusDescription: 'Lesión por sobreuso del tejido de la planta del pie.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 1,
      orderIndex: 1,
      name: 'Rodar botella congelada',
      instructions: 'Deslizar la planta del pie sobre una botella con hielo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 1,
      orderIndex: 2,
      name: 'Rodar pelota de tenis',
      instructions: 'Presionar una pelota bajo el arco del pie.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 1,
      orderIndex: 3,
      name: 'Estiramiento de fascia',
      instructions: 'Jalar los dedos del pie hacia atrás con la mano.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 1,
      orderIndex: 4,
      name: 'Estiramiento de gastrocnemio',
      instructions: 'Apoyar las manos en la pared y estirar la pierna trasera.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 2,
      orderIndex: 5,
      name: 'Estiramiento de sóleo',
      instructions: 'Flexionar ambas rodillas apoyado en la pared.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 2,
      orderIndex: 6,
      name: 'Elevación de talón invertido',
      instructions: 'Pararse en el borde de un escalón, bajando el talón lentamente (esta parte del movimiento es la que trabaja el músculo).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 2,
      orderIndex: 7,
      name: 'Separación de dedos',
      instructions: 'Intentar abrir los dedos de los pies en abanico.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 2,
      orderIndex: 8,
      name: 'Caminata sobre talones',
      instructions: 'Andar descalzo apoyando solo los talones.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 3,
      orderIndex: 9,
      name: 'Protocolo Rathleff',
      instructions: 'Elevar talón en escalón con una toalla bajo los dedos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 3,
      orderIndex: 10,
      name: 'Desplazamiento lateral',
      instructions: 'Pasos laterales manteniendo el pie plano.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury3.id,
      phase: 3,
      orderIndex: 11,
      name: 'Sentadilla profunda con talón apoyado',
      instructions: 'Mejorar el movimiento de llevar la punta del pie hacia la espinilla.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury4 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Artrosis de Rodilla (Gonartrosis)',
      bodyRegion: 'miembro_inferior',
      focusDescription: 'Rehabilitación enfocada en proteger la articulación fortaleciendo los músculos circundantes.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 1,
      orderIndex: 1,
      name: 'Extensión de rodilla sentado',
      instructions: 'Enderezar la pierna mientras se está sentado.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 1,
      orderIndex: 2,
      name: 'Isométrico de aductores',
      instructions: 'Apretar una pelota entre las rodillas.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 1,
      orderIndex: 3,
      name: 'Estiramiento de isquiotibiales',
      instructions: 'Estirar la pierna sobre una silla e inclinarse al frente.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 1,
      orderIndex: 4,
      name: 'Deslizamiento lateral en cama',
      instructions: 'Abrir y cerrar la pierna acostado boca arriba.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 2,
      orderIndex: 5,
      name: 'Paso lateral con banda',
      instructions: 'Ejercitar glúteo medio para estabilizar la pelvis.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 2,
      orderIndex: 6,
      name: 'Puente con pelota',
      instructions: 'Elevar cadera apretando una pelota entre las rodillas.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 2,
      orderIndex: 7,
      name: 'Elevación recta boca abajo',
      instructions: 'Levantar la pierna hacia atrás apretando el glúteo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 2,
      orderIndex: 8,
      name: 'Pedaleo en el aire',
      instructions: 'Acostado, simular andar en bicicleta de forma suave.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 3,
      orderIndex: 9,
      name: 'Sentadilla en silla',
      instructions: 'Sentarse y pararse de una silla sin usar las manos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 3,
      orderIndex: 10,
      name: 'Zancada estática',
      instructions: 'Dar un paso al frente y mantener la posición baja.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury4.id,
      phase: 3,
      orderIndex: 11,
      name: 'Caminata hacia atrás',
      instructions: 'Caminar hacia atrás en terreno seguro (esto activa el músculo de adelante del muslo).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury5 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Fractura de Fémur (Post-Consolidación / Post-Cirugía)',
      bodyRegion: 'miembro_inferior',
      focusDescription: 'Recuperar la fuerza del cuádriceps, la movilidad de cadera y rodilla, y reentrenar la marcha.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 1,
      orderIndex: 1,
      name: 'Isométrico de cuádriceps con rodillo',
      instructions: 'Coloca una toalla enrollada bajo la rodilla y empuja hacia abajo apretando el muslo.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 1,
      orderIndex: 2,
      name: 'Deslizamiento de talón asistido',
      instructions: 'Usa una banda o correa en el pie para jalar el talón hacia los glúteos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 1,
      orderIndex: 3,
      name: 'Extensión terminal de rodilla (TKE)',
      instructions: 'Sentado con piernas estiradas, levanta solo el talón del suelo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 1,
      orderIndex: 4,
      name: 'Movilización pasiva de rótula',
      instructions: 'Con los dedos, mueve suavemente el hueso redondo de tu rodilla (la rótula) hacia arriba, abajo y hacia los lados.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 2,
      orderIndex: 5,
      name: 'Elevación de pierna recta (SLR) boca arriba',
      instructions: 'Aprieta el músculo de adelante del muslo y levanta la pierna afectada unos 20 cm.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 2,
      orderIndex: 6,
      name: 'Abducción de cadera acostado lateral',
      instructions: 'Acostado del lado sano, levanta la pierna afectada hacia el techo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 2,
      orderIndex: 7,
      name: 'Extensión de cadera boca abajo',
      instructions: 'Boca abajo, levanta la pierna estirada apretando el glúteo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 2,
      orderIndex: 8,
      name: 'Prensa de piernas con banda',
      instructions: 'Sentado, banda en la planta del pie, flexiona y empuja extendiendo la pierna.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 3,
      orderIndex: 9,
      name: 'Sentadilla parcial asistida',
      instructions: 'Sujeto de una barra, baja la cadera máximo 45 grados.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 3,
      orderIndex: 10,
      name: 'Paso al frente controlado (Step-up)',
      instructions: 'Sube un escalón bajo con la pierna afectada.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury5.id,
      phase: 3,
      orderIndex: 11,
      name: 'Sostén unipodal',
      instructions: 'De pie apoyado en la pierna afectada, mantener 20-30 segundos.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );

  final injury6 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Tendinopatía del Manguito Rotador / Síndrome de Pinzamiento',
      bodyRegion: 'miembro_superior',
      focusDescription: 'Recuperación del espacio subacromial y fortalecimiento de rotadores internos y externos.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 1,
      orderIndex: 1,
      name: 'Péndulo de Codman',
      instructions: 'Inclinarse y balancear el brazo relajado en círculos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 1,
      orderIndex: 2,
      name: 'Elevación asistida',
      instructions: 'Usar un bastón para levantar el brazo sano al enfermo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 1,
      orderIndex: 3,
      name: 'Rotación externa asistida',
      instructions: 'Usar un bastón para empujar la mano hacia afuera.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 1,
      orderIndex: 4,
      name: 'Deslizamiento en pared',
      instructions: 'Colocar manos en la pared y deslizar hacia arriba con una toalla.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 2,
      orderIndex: 5,
      name: 'Isométrico rotación externa',
      instructions: 'Empujar el dorso de la mano contra la pared.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 2,
      orderIndex: 6,
      name: 'Isométrico rotación interna',
      instructions: 'Empujar la palma de la mano contra una esquina.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 2,
      orderIndex: 7,
      name: 'Rotación externa con banda',
      instructions: 'Codo a 90 grados pegado al cuerpo, abrir el brazo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 2,
      orderIndex: 8,
      name: 'Rotación interna con banda',
      instructions: 'Jalar la banda elástica hacia el abdomen.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 2,
      orderIndex: 9,
      name: 'Remo bajo con banda',
      instructions: 'Jalar la banda hacia atrás doblando los codos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 3,
      orderIndex: 10,
      name: 'Flexión en Y',
      instructions: 'Levantar los brazos en diagonal hacia arriba con resistencia ligera.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 3,
      orderIndex: 11,
      name: 'Abducción horizontal (T)',
      instructions: 'Abrir los brazos en cruz con banda elástica.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 3,
      orderIndex: 12,
      name: 'Flexión en pared con resistencia',
      instructions: 'Banda en muñecas, subir por la pared.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury6.id,
      phase: 3,
      orderIndex: 13,
      name: 'Flexiones modificadas',
      instructions: 'Lagartijas apoyando las manos en una mesa alta.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury7 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Fractura de Clavícula (Post-Inmovilización)',
      bodyRegion: 'miembro_superior',
      focusDescription: 'Activación progresiva tras semanas usando el cabestrillo.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 1,
      orderIndex: 1,
      name: 'Encogimiento de hombros',
      instructions: 'Elevar y bajar los hombros suavemente.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 1,
      orderIndex: 2,
      name: 'Retracción escapular',
      instructions: 'Junta los omóplatos (los huesos planos que sientes en tu espalda, debajo de los hombros), como si quisieras sostener un lápiz entre ellos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 1,
      orderIndex: 3,
      name: 'Péndulo frontal',
      instructions: 'Balancear el brazo adelante y atrás.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 1,
      orderIndex: 4,
      name: 'Péndulo lateral',
      instructions: 'Balancear el brazo de izquierda a derecha.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 2,
      orderIndex: 5,
      name: 'Escalera de dedos',
      instructions: 'Caminar con los dedos hacia arriba por la pared.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 2,
      orderIndex: 6,
      name: 'Abducción activa',
      instructions: 'Levantar el brazo hacia el lado hasta donde sea cómodo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 2,
      orderIndex: 7,
      name: 'Rotación interna detrás de la espalda',
      instructions: 'Llevar la mano a la zona lumbar.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 2,
      orderIndex: 8,
      name: 'Flexión frontal activa',
      instructions: 'Elevar el brazo al frente sin peso.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 3,
      orderIndex: 9,
      name: 'Pase de pelota',
      instructions: 'Lanzar y atrapar una pelota ligera contra la pared.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 3,
      orderIndex: 10,
      name: 'Press de hombros ligero',
      instructions: 'Elevar una botella de agua sobre la cabeza.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 3,
      orderIndex: 11,
      name: 'Abducción con mancuerna ligera',
      instructions: 'Levantar peso hacia el lateral (máximo 1-2 kg).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury7.id,
      phase: 3,
      orderIndex: 12,
      name: 'Plancha sobre rodillas',
      instructions: 'Sostener el peso corporal sobre rodillas y antebrazos.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );

  final injury8 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Epicondilitis Lateral (Codo de Tenista)',
      bodyRegion: 'miembro_superior',
      focusDescription: 'Sobrecarga en los tendones extensores de la muñeca.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 1,
      orderIndex: 1,
      name: 'Estiramiento de extensores',
      instructions: 'Brazo estirado, empujar los dedos hacia abajo.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 1,
      orderIndex: 2,
      name: 'Estiramiento de flexores',
      instructions: 'Brazo estirado, empujar los dedos hacia arriba.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 1,
      orderIndex: 3,
      name: 'Masaje transverso profundo',
      instructions: 'Fricción suave con el dedo sobre el punto de dolor.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 1,
      orderIndex: 4,
      name: 'Auto-tracción de codo',
      instructions: 'Sujetar la muñeca contraria y traccionar suavemente.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 2,
      orderIndex: 5,
      name: 'Isométrico de extensión',
      instructions: 'Mano plana sobre la mesa, intentar levantarla contra la otra mano.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 2,
      orderIndex: 6,
      name: 'Extensión excéntrica',
      instructions: 'Subir la muñeca con la mano sana, bajarla despacio con la enferma usando peso.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 2,
      orderIndex: 7,
      name: 'Flexión de muñeca',
      instructions: 'Antebrazo apoyado, levantar una mancuerna ligera hacia arriba.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 2,
      orderIndex: 8,
      name: 'Pronosupinación',
      instructions: 'Girar un martillo o botella de un lado a otro con el codo doblado.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 3,
      orderIndex: 9,
      name: 'Apretar pelota',
      instructions: 'Presionar una pelota de goma suave manteniendo 5 segundos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 3,
      orderIndex: 10,
      name: 'Extensión de dedos con banda',
      instructions: 'Colocar una banda elástica alrededor de los dedos y abrirlos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury8.id,
      phase: 3,
      orderIndex: 11,
      name: 'Enrollar cuerda',
      instructions: 'Usar un palo con una cuerda y un peso, enrollar y desenrollar.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury9 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Síndrome del Túnel Carpiano',
      bodyRegion: 'miembro_superior',
      focusDescription: 'Compresión del nervio mediano en la muñeca.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 1,
      orderIndex: 1,
      name: 'Deslizamiento del nervio mediano',
      instructions: 'Pasar de puño cerrado a dedos estirados (puño a palma).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 1,
      orderIndex: 2,
      name: 'Extensión de muñeca y dedos',
      instructions: 'Llevar la muñeca hacia atrás abriendo la palma.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 1,
      orderIndex: 3,
      name: 'Estiramiento del pulgar',
      instructions: 'Jalar suavemente el pulgar hacia atrás.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 1,
      orderIndex: 4,
      name: 'Oración invertida',
      instructions: 'Juntar los dorsos de las manos frente al pecho apuntando hacia abajo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 2,
      orderIndex: 5,
      name: 'Flexión/extensión activa',
      instructions: 'Mover la muñeca arriba y abajo libremente.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 2,
      orderIndex: 6,
      name: 'Desviación radial/cubital',
      instructions: 'Mover la muñeca de lado a lado (como saludando).',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 2,
      orderIndex: 7,
      name: 'Oposición del pulgar',
      instructions: 'Tocar la punta de cada dedo con el pulgar.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 2,
      orderIndex: 8,
      name: 'Giros de muñeca',
      instructions: 'Rotar las muñecas en ambos sentidos de forma lenta.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 3,
      orderIndex: 9,
      name: 'Pinza digital',
      instructions: 'Apretar una pinza de ropa con cada dedo y el pulgar.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 3,
      orderIndex: 10,
      name: 'Apretar esponja en agua',
      instructions: 'Trabaja la fuerza de prensión global.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury9.id,
      phase: 3,
      orderIndex: 11,
      name: 'Flexión de muñeca con banda',
      instructions: 'Sentado, jalar la banda elástica hacia arriba.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury10 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Lumbalgia Mecánica (Dolor de Espalda Baja)',
      bodyRegion: 'tronco_columna',
      focusDescription: 'Enfoque en estabilización lumbopélvica (Core) y descompresión.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 1,
      orderIndex: 1,
      name: 'Rodillas al pecho',
      instructions: 'Acostado, abrazar ambas rodillas hacia el pecho.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 1,
      orderIndex: 2,
      name: 'Meneo de cola',
      instructions: 'A cuatro patas, mover la cadera de lado a lado.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 1,
      orderIndex: 3,
      name: 'Gato-Camello',
      instructions: 'Arquear la espalda hacia arriba y luego curvarla hacia abajo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 1,
      orderIndex: 4,
      name: 'Postura del niño',
      instructions: 'Sentarse sobre los talones estirando los brazos al frente en el suelo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 2,
      orderIndex: 5,
      name: 'Báscula pélvica',
      instructions: 'Acostado, aplanar la espalda baja contra el suelo contrayendo el abdomen.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 2,
      orderIndex: 6,
      name: 'Perro de muestra (Bird-Dog)',
      instructions: 'A cuatro patas, estirar brazo derecho y pierna izquierda.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 2,
      orderIndex: 7,
      name: 'Puente supino',
      instructions: 'Elevar la pelvis manteniendo la alineación del tronco.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 2,
      orderIndex: 8,
      name: 'El bicho muerto (Dead Bug)',
      instructions: 'Boca arriba, alternar movimiento de brazo y pierna contraria sin despegar la espalda.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 3,
      orderIndex: 9,
      name: 'Plancha frontal modificada',
      instructions: 'Apoyo en antebrazos y rodillas manteniendo el abdomen firme.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 3,
      orderIndex: 10,
      name: 'Plancha lateral sobre rodillas',
      instructions: 'Elevar la cadera de lado apoyado en el antebrazo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury10.id,
      phase: 3,
      orderIndex: 11,
      name: 'Caminata de granjero ligera',
      instructions: 'Caminar erguido sosteniendo un peso ligero en cada mano.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury11 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Cervicalgia (Dolor de Cuello / Latigazo Cervical)',
      bodyRegion: 'tronco_columna',
      focusDescription: 'Relajación de trapecios y fortalecimiento de flexores profundos del cuello.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 1,
      orderIndex: 1,
      name: 'Rotaciones laterales',
      instructions: 'Girar la cabeza lentamente a la derecha e izquierda.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 1,
      orderIndex: 2,
      name: 'Inclinaciones laterales',
      instructions: 'Llevar la oreja hacia el hombro sin levantar el hombro.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 1,
      orderIndex: 3,
      name: 'Flexión frontal',
      instructions: 'Llevar la barbilla hacia el pecho.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 1,
      orderIndex: 4,
      name: 'Retracción cervical (doble mentón)',
      instructions: 'Llevar la cabeza hacia atrás, sacando \'papada\'.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 2,
      orderIndex: 5,
      name: 'Isométrico lateral',
      instructions: 'Empujar la cabeza contra la mano lateralmente sin que se mueva.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 2,
      orderIndex: 6,
      name: 'Isométrico frontal',
      instructions: 'Empujar la frente contra las manos.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 2,
      orderIndex: 7,
      name: 'Isométrico posterior',
      instructions: 'Empujar la nuca contra las manos entrelazadas atrás.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 3,
      orderIndex: 8,
      name: 'Auto-estiramiento de trapecio',
      instructions: 'Inclinar cabeza y jalar suavemente con la mano.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 3,
      orderIndex: 9,
      name: 'Retracción cervical acostado',
      instructions: 'Boca arriba, empujar la cabeza contra la cama.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury11.id,
      phase: 3,
      orderIndex: 10,
      name: 'Elevación de cabeza prono',
      instructions: 'Boca abajo, levantar la frente un centímetro del suelo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury12 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Fractura de Muñeca (Radio / Colles - Post-Inmovilización)',
      bodyRegion: 'otras',
      focusDescription: 'Recuperación de rango de movimiento y fuerza de pinza tras retirar la inmovilización.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 1,
      orderIndex: 1,
      name: 'Deslizamiento en mesa',
      instructions: 'Manos planas, deslizar el antebrazo adelante y atrás.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 1,
      orderIndex: 2,
      name: 'Flexión asistida con otra mano',
      instructions: 'Empujar suavemente la muñeca hacia la flexión.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 1,
      orderIndex: 3,
      name: 'Pronosupinación pasiva',
      instructions: 'Girar la palma arriba y abajo ayudándose de la mano sana.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 1,
      orderIndex: 4,
      name: 'Estiramiento de dedos',
      instructions: 'Extender por completo los nudillos rígidos por el yeso.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 2,
      orderIndex: 5,
      name: 'Cerrar puño bloqueando pulgar',
      instructions: 'Apretar el pulgar por fuera de los dedos.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 2,
      orderIndex: 6,
      name: 'Desviación cubital con peso',
      instructions: 'Sostener una botella por la base y mover de lado.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 2,
      orderIndex: 7,
      name: 'Flexión con banda elástica',
      instructions: 'Pisar la banda y hacer curls de muñeca.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 2,
      orderIndex: 8,
      name: 'Extensión con banda elástica',
      instructions: 'Jalar la banda hacia arriba con el dorso de la mano.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 3,
      orderIndex: 9,
      name: 'Girar pomo de puerta simulado',
      instructions: 'Usar resistencia de una banda elástica para simular el giro.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 3,
      orderIndex: 10,
      name: 'Escribir / dibujar',
      instructions: 'Ejercicios de motricidad fina texturizada.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury12.id,
      phase: 3,
      orderIndex: 11,
      name: 'Estrujar una toalla',
      instructions: 'Enrollar una toalla seca con ambas manos aplicando fuerza opuesta.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury13 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Rotura de Fibras en Isquiotibiales (Fase de Remodelación)',
      bodyRegion: 'otras',
      focusDescription: 'Recuperación progresiva de fibras musculares posteriores del muslo.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 1,
      orderIndex: 1,
      name: 'Puente isométrico bajo',
      instructions: 'Elevar cadera muy poco y sostener.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 1,
      orderIndex: 2,
      name: 'Presión de talón',
      instructions: 'Sentado, empujar el talón contra el suelo hacia atrás.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 1,
      orderIndex: 3,
      name: 'Estiramiento pasivo en puerta',
      instructions: 'Colocar la pierna estirada en el marco de una puerta.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 2,
      orderIndex: 4,
      name: 'Curl de piernas con banda',
      instructions: 'Boca abajo, doblar rodilla contra banda elástica.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 2,
      orderIndex: 5,
      name: 'Puente con marcha',
      instructions: 'Elevar cadera y dar pasos cortos con los talones alejándose.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 2,
      orderIndex: 6,
      name: 'Peso muerto rumano sin peso',
      instructions: 'Bisagra de cadera manteniendo la espalda recta.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 2,
      orderIndex: 7,
      name: 'Deslizamiento de talones en suelo',
      instructions: 'Usar calcetines en suelo liso para alejar los talones en puente.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 3,
      orderIndex: 8,
      name: 'Peso muerto rumano unipodal',
      instructions: 'Balanceo a una pierna controlando el descenso.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 3,
      orderIndex: 9,
      name: 'Zancadas largas',
      instructions: 'Dar pasos largos, sintiendo cómo se estira el músculo de atrás del muslo mientras bajas con control.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury13.id,
      phase: 3,
      orderIndex: 10,
      name: 'Patadas de glúteo altas',
      instructions: 'Extensión total de cadera y rodilla boca abajo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

  final injury14 = await db.into(db.injuries).insertReturning(
    InjuriesCompanion.insert(
      name: 'Pubalgia / Osteopatía Dinámica de Pubis',
      bodyRegion: 'otras',
      focusDescription: 'Dolor en la zona inguinal común en atletas.',
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 1,
      orderIndex: 1,
      name: 'Isométrico de aductores con pelota',
      instructions: 'Apretar pelota entre las rodillas (acostado).',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 1,
      orderIndex: 2,
      name: 'Estiramiento de flexores de cadera',
      instructions: 'Zancada del caballero (rodilla al suelo).',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 1,
      orderIndex: 3,
      name: 'Estiramiento de aductores en mariposa',
      instructions: 'Sentado con plantas de los pies juntas.',
      dosageType: 'estiramiento',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(25),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 2,
      orderIndex: 4,
      name: 'Abdomen transverso',
      instructions: 'Hundir el ombligo manteniendo respiración normal.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 2,
      orderIndex: 5,
      name: 'Plancha lateral corta',
      instructions: 'Sostenerse sobre rodillas alineando cadera y pubis.',
      dosageType: 'isometrico',
      sets: const Value.absent(),
      reps: const Value.absent(),
      holdSeconds: Value(8),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 2,
      orderIndex: 6,
      name: 'Elevación de pierna en diagonal',
      instructions: 'Acostado de lado, elevar la pierna de abajo hacia arriba.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 2,
      orderIndex: 7,
      name: 'Plancha Copenhagen modificada',
      instructions: 'Rodilla de arriba apoyada en silla, elevar la de abajo.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 3,
      orderIndex: 8,
      name: 'Sentadilla sumo',
      instructions: 'Sentadilla con piernas abiertas y puntas hacia afuera.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 3,
      orderIndex: 9,
      name: 'Puente con banda sobre rodillas',
      instructions: 'Empujar hacia afuera mientras se sube la cadera.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );
  await db.into(db.exercises).insert(
    ExercisesCompanion.insert(
      injuryId: injury14.id,
      phase: 3,
      orderIndex: 10,
      name: 'Puente de glúteo unipodal',
      instructions: 'Mantener la pelvis nivelada en una sola pierna.',
      dosageType: 'repeticiones',
      sets: Value(2),
      reps: Value(12),
      holdSeconds: const Value.absent(),
    ),
  );

}