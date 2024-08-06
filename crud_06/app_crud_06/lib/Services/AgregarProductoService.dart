import 'dart:convert';
import 'package:http/http.dart' as http;

class AgregarProductoService {
  final http.Client client;

  AgregarProductoService({http.Client? client})
      : client = client ?? http.Client();

  Future<bool> guardarProducto({
    required String nombreProducto,
    required String precioProducto,
  }) async {
    try {
      final respuesta = await client.post(
        Uri.parse('http://192.168.100.13/crud_06/create.php'),
        body: {
          'nombre_producto': nombreProducto,
          'precio_producto': precioProducto,
        },
      );

      if (respuesta.statusCode == 200) {
        final body = jsonDecode(respuesta.body);

        if (body.containsKey('mensaje') &&
            body['mensaje'].toLowerCase() == 'éxito') {
          return true;
        } else {
          print('Error: ${body['mensaje']}');
          return false;
        }
      } else {
        print('Error: Código de estado ${respuesta.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de excepción: $e');
      return false;
    }
  }
}
