import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'databaseProvider debe ser sobreescrito en main.dart antes de usarse.',
  );
});