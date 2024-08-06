import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_crud_06/Paginas/ActualizarProducto.dart';
import 'package:app_crud_06/Services/ActualizarProductoService.dart';

void main() {
  testWidgets('Actualizar producto test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ActualizarProducto(
        idProducto: '1',
        nombreProducto: 'Producto Test',
        precioProducto: '12.50',
      ),
    ));

    await tester.enterText(
        find.byKey(ValueKey('edit_product_name')), 'Producto Actualizado');
    await tester.enterText(find.byKey(ValueKey('edit_product_price')), '15.00');

    await tester.tap(find.byKey(ValueKey('update_button')));
    await tester.pump();

    expect(find.text('Producto actualizado exitosamente'), findsOneWidget);
  });
}
