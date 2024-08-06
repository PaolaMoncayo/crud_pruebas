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

  test('Actualizar el último producto creado', () async {
    // Finders para el producto que se va a actualizar
    final SerializableFinder productItem =
        find.text('Nuevo Nuevo Producto Actualiza');
    final SerializableFinder productPrice = find.text('\$49.99');
    final String idProducto = '25';
    final SerializableFinder editIconButton =
        find.byValueKey('edit_icon_button_$idProducto');

    // Finders para los elementos en la pantalla de Actualizar Producto
    final SerializableFinder nombreProductoField =
        find.byValueKey('edit_product_name');
    final SerializableFinder precioProductoField =
        find.byValueKey('edit_product_price');
    final SerializableFinder actualizarButton =
        find.byValueKey('update_button');
    final SerializableFinder mensajeActualizacion =
        find.text('Producto actualizado exitosamente');

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

    print('Producto encontrado, intentando tap en el ícono de edición...');

    // Tap en el ícono de editar (lápiz) al lado del producto
    await driver!.tap(editIconButton, timeout: Duration(seconds: 60));

    // Esperar un momento antes de interactuar con los campos
    await Future.delayed(Duration(seconds: 5));

    // Esperar a que los campos de actualización estén visibles
    await driver!.waitFor(nombreProductoField, timeout: Duration(seconds: 30));
    await driver!.waitFor(precioProductoField, timeout: Duration(seconds: 30));

    // Esperar un momento antes de ingresar los datos
    await Future.delayed(Duration(seconds: 2));

    // Rellenar los campos del formulario en la pantalla de Actualizar Producto
    await driver!.tap(nombreProductoField, timeout: Duration(seconds: 30));
    await driver!.enterText('galleta oreo');

    // Esperar un momento antes de ingresar el precio
    await Future.delayed(Duration(seconds: 2));

    await driver!.tap(precioProductoField, timeout: Duration(seconds: 30));
    await driver!.enterText('0.5');

    // Esperar un momento antes de guardar
    await Future.delayed(Duration(seconds: 2));

    // Guardar el producto actualizado
    await driver!.tap(actualizarButton, timeout: Duration(seconds: 30));

    // Verificar que el mensaje de éxito aparece
    await driver!.waitFor(mensajeActualizacion, timeout: Duration(seconds: 30));
    final mensajeTexto = await driver!
        .getText(mensajeActualizacion, timeout: Duration(seconds: 30));
    expect(mensajeTexto, isNotNull); // Verifica que el texto existe
    expect(mensajeTexto,
        'Producto actualizado exitosamente'); // Verifica el contenido del texto
  });
}
