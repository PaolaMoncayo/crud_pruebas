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

  test('Agregar un producto', () async {
    // Finder para el botón de agregar producto en la pantalla principal
    final SerializableFinder addProductButton =
        find.byValueKey('add_product_button');

    // Finders para los elementos en la pantalla de Agregar Producto
    final SerializableFinder nombreProductoField =
        find.byValueKey('product_name');
    final SerializableFinder precioProductoField =
        find.byValueKey('product_price');
    final SerializableFinder guardarButton = find.byValueKey('save_button');
    final SerializableFinder mensajeExito =
        find.text('Datos guardados exitosamente');

    // Asegúrate de que driver no es null antes de usarlo
    assert(driver != null);

    // Tap en el botón de agregar producto en la pantalla principal
    await driver!.tap(addProductButton);

    // Rellenar los campos del formulario en la pantalla de Agregar Producto
    await driver!.tap(nombreProductoField);
    await driver!.enterText('Nuevo Producto');
    await driver!.tap(precioProductoField);
    await driver!.enterText('19.99');

    // Guardar el producto
    await driver!.tap(guardarButton);

    // Verificar que el mensaje de éxito aparece
    final mensajeTexto = await driver!.getText(mensajeExito);
    expect(mensajeTexto, isNotNull); // Verifica que el texto existe
    expect(mensajeTexto,
        'Datos guardados exitosamente'); // Verifica el contenido del texto
  });
}
