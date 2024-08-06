import 'dart:convert';
import 'package:http/http.dart' as http;

class ActualizarProductoService {
  // URL fija apuntando al localhost
  final String url = 'http://192.168.100.13/crud_06/update.php';

  Future<bool> actualizarProducto({
    required String idProducto,
    required String nombreProducto,
    required String precioProducto,
    required http.Client client,
  }) async {
    try {
      final respuesta = await client.post(
        Uri.parse(url),
        body: {
          'id_producto': idProducto,
          'nombre_producto': nombreProducto,
          'precio_producto': precioProducto,
        },
      );

      if (respuesta.statusCode == 200) {
        final body = jsonDecode(respuesta.body);
        return body['mensaje'] == 'Éxito';
      } else {
        print('Error del servidor: ${respuesta.statusCode}');
        print('Respuesta del servidor: ${respuesta.body}');
        return false;
      }
    } catch (e) {
      print('Error de excepción: $e');
      return false;
    }
  }
}
