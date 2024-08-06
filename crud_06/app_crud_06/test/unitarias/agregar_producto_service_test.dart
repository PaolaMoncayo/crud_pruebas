import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_crud_06/Services/AgregarProductoService.dart';
import 'package:http/http.dart' as http;
import 'agregar_producto_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('AgregarProductoService', () {
    test('debe retornar true cuando la operación de guardar es exitosa',
        () async {
      final client = MockClient();
      final service = AgregarProductoService(client: client);

      when(client.post(
        Uri.parse('http://localhost/crud_06/create.php'),
        body: {
          'nombre_producto': 'Producto 1',
          'precio_producto': '100.00',
        },
      )).thenAnswer(
        (_) async => http.Response('{"mensaje": "Éxito"}', 200),
      );

      final resultado = await service.guardarProducto(
        nombreProducto: 'Producto 1',
        precioProducto: '100.00',
      );

      expect(resultado, true);
    });

    test('debe retornar false cuando la operación de guardar falla', () async {
      final client = MockClient();
      final service = AgregarProductoService(client: client);

      when(client.post(
        Uri.parse('http://localhost/crud_06/create.php'),
        body: {
          'nombre_producto': 'Producto 1',
          'precio_producto': '100.00',
        },
      )).thenAnswer(
        (_) async => http.Response('{"mensaje": "Error"}', 200),
      );

      final resultado = await service.guardarProducto(
        nombreProducto: 'Producto 1',
        precioProducto: '100.00',
      );

      expect(resultado, false);
    });

    test('debe manejar excepciones y retornar false', () async {
      final client = MockClient();
      final service = AgregarProductoService(client: client);

      when(client.post(
        Uri.parse('http://localhost/crud_06/create.php'),
        body: {
          'nombre_producto': 'Producto 1',
          'precio_producto': '100.00',
        },
      )).thenThrow(Exception('Error de conexión'));

      final resultado = await service.guardarProducto(
        nombreProducto: 'Producto 1',
        precioProducto: '100.00',
      );

      expect(resultado, false);
    });
  });
}
