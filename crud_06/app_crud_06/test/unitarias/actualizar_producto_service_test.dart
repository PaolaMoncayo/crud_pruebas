import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:app_crud_06/Services/ActualizarProductoService.dart';
import 'actualizar_producto_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('ActualizarProductoService', () {
    test('debe retornar true cuando la actualización es exitosa', () async {
      final client = MockClient();
      final service = ActualizarProductoService();

      // Configuramos el mock para que responda con un status 200 y un mensaje de éxito
      when(client.post(
        Uri.parse('http://localhost/crud_06/update.php'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('{"mensaje": "Éxito"}', 200),
      );

      final resultado = await service.actualizarProducto(
        idProducto: '1',
        nombreProducto: 'Producto actualizado',
        precioProducto: '20.00',
        client: client,
      );

      expect(resultado, true);
    });

    test('debe retornar false cuando la actualización falla', () async {
      final client = MockClient();
      final service = ActualizarProductoService();

      // Configuramos el mock para que responda con un status 200 pero con un mensaje de error
      when(client.post(
        Uri.parse('http://localhost/crud_06/update.php'),
        body: anyNamed('body'),
      )).thenAnswer(
        (_) async => http.Response('{"mensaje": "Error"}', 200),
      );

      final resultado = await service.actualizarProducto(
        idProducto: '1',
        nombreProducto: 'Producto actualizado',
        precioProducto: '20.00',
        client: client,
      );

      expect(resultado, false);
    });

    test('debe manejar correctamente una excepción', () async {
      final client = MockClient();
      final service = ActualizarProductoService();

      // Configuramos el mock para que lance una excepción
      when(client.post(
        Uri.parse('http://localhost/crud_06/update.php'),
        body: anyNamed('body'),
      )).thenThrow(Exception('Error de conexión'));

      final resultado = await service.actualizarProducto(
        idProducto: '1',
        nombreProducto: 'Producto actualizado',
        precioProducto: '20.00',
        client: client,
      );

      expect(resultado, false);
    });
  });
}
