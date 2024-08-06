import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver? driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    if (driver != null) {
      driver!.close();
    }
  });

  group('CRUD Operations Test', () {
    final addProductButton = find.byValueKey('add_product_button');
    final nombreProductoField = find.byValueKey('product_name');
    final precioProductoField = find.byValueKey('product_price');
    final guardarButton = find.byValueKey('save_button');
    final mensajeExito = find.text('Datos guardados exitosamente');
    final productItem = find.text('Nuevo Producto');
    final editProductButton = find.byValueKey('edit_product_button');
    final deleteProductButton = find.byValueKey('delete_product_button');
    final mensajeActualizacion = find.text('Datos actualizados exitosamente');
    final mensajeEliminacion = find.text('Producto eliminado exitosamente');

    Future<void> esperar() async {
      await Future.delayed(Duration(seconds: 3)); // Espera de 2 segundos
    }

    test('Crear un producto', () async {
      await driver!.tap(addProductButton);
      await esperar(); // Espera antes de la siguiente acción
      await driver!.tap(nombreProductoField);
      await driver!.enterText('Nuevo Producto');
      await esperar();
      await driver!.tap(precioProductoField);
      await driver!.enterText('19.99');
      await esperar();
      await driver!.tap(guardarButton);
      await esperar();
      final mensajeTexto = await driver!.getText(mensajeExito);
      expect(mensajeTexto, 'Datos guardados exitosamente');
    });

    test('Leer (Verificar) el producto creado', () async {
      await esperar();
      final productItemText = await driver!.getText(productItem);
      expect(productItemText, 'Nuevo Producto');
    });

    test('Actualizar el producto', () async {
      await driver!.tap(productItem);
      await esperar();
      await driver!.tap(editProductButton);
      await esperar();
      await driver!.tap(nombreProductoField);
      await driver!.enterText('Producto Actualizado');
      await esperar();
      await driver!.tap(guardarButton);
      await esperar();
      final mensajeTexto = await driver!.getText(mensajeActualizacion);
      expect(mensajeTexto, 'Datos actualizados exitosamente');
      final updatedProductItem = find.text('Producto Actualizado');
      final updatedProductItemText = await driver!.getText(updatedProductItem);
      expect(updatedProductItemText, 'Producto Actualizado');
    });

    test('Eliminar el producto', () async {
      await driver!.tap(find.text('Producto Actualizado'));
      await esperar();
      await driver!.tap(deleteProductButton);
      await esperar();
      final mensajeTexto = await driver!.getText(mensajeEliminacion);
      expect(mensajeTexto, 'Producto eliminado exitosamente');
      final productExists =
          await driver!.getText(find.text('Producto Actualizado'));
      expect(productExists, isNull);
    });
  });
}
