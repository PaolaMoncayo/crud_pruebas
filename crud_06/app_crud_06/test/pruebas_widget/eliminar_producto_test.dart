import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_crud_06/Paginas/PaginaProductos.dart';

void main() {
  testWidgets('Eliminar producto test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: PaginaProductos(),
    ));

    await tester.tap(find.byKey(ValueKey('delete_product_button_1')));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('confirm_delete_button_1')));
    await tester.pump();

    expect(find.text('Producto eliminado exitosamente'), findsOneWidget);
  });
}
