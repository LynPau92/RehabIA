import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database/app_database.dart';

/// Provider global de la base de datos.
///
/// Se "sobreescribe" con la instancia real en main.dart (ver overrides
/// en ProviderScope). Cualquier pantalla puede acceder a la base de
/// datos así: `ref.watch(databaseProvider)`.
final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'databaseProvider debe ser sobreescrito en main.dart antes de usarse.',
  );
});