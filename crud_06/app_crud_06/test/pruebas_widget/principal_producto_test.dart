import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_crud_06/Paginas/PaginaProductos.dart';
import 'package:app_crud_06/Services/AgregarProductoService.dart';
import 'package:mockito/mockito.dart';

class MockAgregarProductoService extends Mock
    implements AgregarProductoService {}

void main() {
  testWidgets('Verificar UI de PaginaProductos y el flujo de agregar producto',
      (WidgetTester tester) async {
    // Crear un mock del servicio de agregar producto

    // Renderizar el widget en el entorno de prueba
    await tester.pumpWidget(MaterialApp(
      home: PaginaProductos(),
    ));

    // Verificar que el CircularProgressIndicator se muestra mientras carga
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simular que los datos se cargaron
    await tester.pump(); // Para simular que la UI se re-renderiza

    // Verificar que el botón de agregar producto está presente
    expect(find.byKey(const ValueKey('add_product_button')), findsOneWidget);

    // Simular un clic en el botón de agregar producto
    await tester.tap(find.byKey(const ValueKey('add_product_button')));
    await tester.pumpAndSettle(); // Esperar a que las animaciones terminen

    // Aquí podrías simular la interacción con la pantalla de agregar producto...
    // Por ejemplo, podrías verificar si un campo de texto está presente en la nueva pantalla
    // expect(find.byKey(const ValueKey('product_name')), findsOneWidget);
  });
}
