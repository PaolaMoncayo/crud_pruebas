import 'package:app_crud_06/Paginas/AgregarProducto.dart';
import 'package:app_crud_06/Services/AgregarProductoService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockClient extends Mock implements http.Client {
  @override
  Future<http.Response> post(Uri url,
      {required Map<String, String> body}) async {
    // Simula una respuesta exitosa del servidor
    return Future.value(http.Response('{"mensaje": "éxito"}', 200));
  }
}

void main() {
  testWidgets('Agregar producto test', (WidgetTester tester) async {
    // Crea un mock del cliente HTTP
    final mockedClient = MockClient();

    // Renderiza el widget a probar
    await tester.pumpWidget(
      MaterialApp(
        home: AgregarProducto(
          agregarProductoService: AgregarProductoService(client: mockedClient),
        ),
      ),
    );

    // Encuentra los campos y el botón en la interfaz de usuario
    // ... (tu código para encontrar los elementos)

    // Ingresa datos en los campos
    // ... (tu código para ingresar datos)

    // Simula el clic en el botón de guardar
    await tester.tap(guardarButton);
    await tester.pumpAndSettle();

    // Verifica que se muestre el mensaje de éxito
    expect(find.text('Datos guardados exitosamente'), findsOneWidget);

    // Verifica que se haya llamado al mock con los argumentos correctos
    verify(mockedClient.post(
      Uri.parse('http://192.168.100.13/crud_06/create.php'),
      body: anyNamed('body'),
    ));
  });
}
