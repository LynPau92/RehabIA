// Prueba básica de arranque de la app.
// Verifica simplemente que la app se construye sin errores.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rehabia/main.dart';

void main() {
  testWidgets('La app arranca sin errores', (WidgetTester tester) async {
    // Construimos la app envuelta en ProviderScope, igual que en main.dart.
    await tester.pumpWidget(
      const ProviderScope(
        child: RehabIAApp(initialLocation: '/onboarding'),
      ),
    );

    // Verificamos que la pantalla de Onboarding (Paso 1) aparece.
    expect(find.textContaining('Cuéntanos sobre ti'), findsOneWidget);
  });
}