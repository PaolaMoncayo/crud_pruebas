import 'dart:convert';
import 'package:http/http.dart' as http;

class EliminarProductoService {
  final http.Client client;

  // Constructor que acepta un http.Client
  EliminarProductoService({required this.client});

  Future<bool> eliminarProducto(String idProducto) async {
    try {
      final respuesta = await client.post(
        Uri.parse('http://192.168.100.13/crud_06/delete.php'),
        body: {
          'id_producto': idProducto,
        },
      );

      if (respuesta.statusCode == 200) {
        final body = jsonDecode(respuesta.body);
        if (body['mensaje'] == 'Éxito') {
          return true;
        } else {
          print('Error al eliminar: ${body['error']}');
          return false;
        }
      } else {
        print('Error del servidor: ${respuesta.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error de excepción: $e');
      return false;
    }
  }
}
