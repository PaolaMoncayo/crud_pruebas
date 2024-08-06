import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:app_crud_06/Services/EliminarProductoService.dart';
import 'package:http/http.dart' as http;

import 'eliminar_producto_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('EliminarProductoService', () {
    test('debe retornar true cuando la operación de eliminar es exitosa',
        () async {
      final client = MockClient();
      final service = EliminarProductoService(client: client);

      when(client.post(
        Uri.parse('http://localhost/crud_06/delete.php'),
        body: {'id_producto': '1'},
      )).thenAnswer(
        (_) async => http.Response(jsonEncode({'mensaje': 'Éxito'}), 200),
      );

      final resultado = await service.eliminarProducto('1');
      expect(resultado, true);
    });

    test('debe retornar false cuando la operación de eliminar falla', () async {
      final client = MockClient();
      final service = EliminarProductoService(client: client);

      when(client.post(
        Uri.parse('http://localhost/crud_06/delete.php'),
        body: {'id_producto': '1'},
      )).thenAnswer(
        (_) async => http.Response(jsonEncode({'mensaje': 'Error'}), 200),
      );

      final resultado = await service.eliminarProducto('1');
      expect(resultado, false);
    });

    test('debe manejar excepciones y retornar false', () async {
      final client = MockClient();
      final service = EliminarProductoService(client: client);

      when(client.post(
        Uri.parse('http://localhost/crud_06/delete.php'),
        body: {'id_producto': '1'},
      )).thenThrow(Exception('Error de conexión'));

      final resultado = await service.eliminarProducto('1');
      expect(resultado, false);
    });
  });
}
