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

  test('Eliminar el último producto creado', () async {
    // Finders para el producto que se va a eliminar
    final SerializableFinder productItem = find.text('arroz');
    final SerializableFinder productPrice = find.text('\$1.25');
    final String idProducto = '11';
    final SerializableFinder deleteIconButton =
        find.byValueKey('delete_product_button_$idProducto');
    final SerializableFinder confirmDeleteButton =
        find.byValueKey('confirm_delete_button_$idProducto');

    // Asegúrate de que driver no es null antes de usarlo
    assert(driver != null);

    // Desplázate hasta el final de la lista
    bool found = false;
    while (!found) {
      try {
        // Desplazarse en la lista para buscar el producto
        await driver!.scroll(
          find.byType('ListView'), // Tipo de la lista
          0, // Desplazamiento en el eje X (0 para mantenerlo en la misma posición horizontal)
          -500.0, // Desplazamiento en el eje Y (negativo para desplazarse hacia abajo)
          Duration(seconds: 2), // Duración del desplazamiento
        );

        // Verifica si el producto es visible junto con el precio
        await driver!.waitFor(productItem, timeout: Duration(seconds: 10));
        await driver!.waitFor(productPrice, timeout: Duration(seconds: 10));
        found = true; // Si se encuentra el producto, termina el bucle
      } catch (e) {
        // Si no se encuentra el producto y no hay más para desplazarse, continua el bucle
        print('Producto no encontrado aún, desplazándose...');
      }
    }

    print('Producto encontrado, intentando tap en el ícono de eliminación...');

    // Tap en el ícono de eliminar (basura) al lado del producto
    await driver!.tap(deleteIconButton, timeout: Duration(seconds: 60));

    // Esperar un momento antes de interactuar con la confirmación
    await Future.delayed(Duration(seconds: 3));

    // Tap en el botón de confirmación para eliminar el producto
    await driver!.tap(confirmDeleteButton, timeout: Duration(seconds: 30));

    // Esperar un momento para confirmar la eliminación
    await Future.delayed(Duration(seconds: 5));

    // Opcional: Verificar que el producto ya no esté en la lista
    bool productStillExists = false;
    try {
      await driver!.waitFor(productItem, timeout: Duration(seconds: 10));
      productStillExists = true;
    } catch (e) {
      productStillExists = false;
    }

    expect(productStillExists, false); // Verifica que el producto fue eliminado
  });
}
