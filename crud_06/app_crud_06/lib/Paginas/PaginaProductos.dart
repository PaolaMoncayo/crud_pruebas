import 'dart:convert';
import 'package:app_crud_06/Services/AgregarProductoService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_crud_06/Paginas/AgregarProducto.dart';
import 'package:app_crud_06/Services/EliminarProductoService.dart';
import 'package:app_crud_06/Paginas/ActualizarProducto.dart';

class PaginaProductos extends StatefulWidget {
  const PaginaProductos({super.key});

  @override
  State<PaginaProductos> createState() => _PaginaProductosState();
}

class _PaginaProductosState extends State<PaginaProductos> {
  List _listaDatos = [];
  bool _cargando = true;
  final EliminarProductoService _eliminarProductoService =
      EliminarProductoService(client: http.Client());

  Future<void> _obtenerDatos() async {
    try {
      final respuesta = await http
          .get(Uri.parse('http://192.168.100.13/crud_06/conexion.php'));

      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);

        if (datos is List) {
          setState(() {
            _listaDatos = datos;
            _cargando = false;
          });
        } else {
          print('La respuesta no es una lista: $datos');
        }
      } else {
        print('Respuesta del servidor: ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _confirmarEliminacion(String idProducto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este producto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo sin hacer nada
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: ValueKey(
                  'confirm_delete_button_$idProducto'), // Añadir ValueKey aquí
              onPressed: () async {
                Navigator.of(context).pop(); // Cerrar el diálogo
                bool eliminado =
                    await _eliminarProductoService.eliminarProducto(idProducto);
                if (eliminado) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Producto eliminado exitosamente')),
                  );
                  _obtenerDatos(); // Actualizar la lista después de eliminar
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Error al eliminar el producto')),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _obtenerDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Página de productos",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    key: const ValueKey(
                        'add_product_button'), // Añadir ValueKey aquí
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Color verde
                    ),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgregarProducto(
                              agregarProductoService: AgregarProductoService()),
                        ),
                      );
                      if (result == true) {
                        _obtenerDatos(); // Actualizar la lista después de agregar
                      }
                    },
                    icon: const Icon(Icons.add,
                        color: Colors.white), // Icono de + blanco
                    label: const Text(
                      "Agregar Producto",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _listaDatos.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_listaDatos[index]["nombre_producto"]),
                          subtitle: Text(
                              "\$" + _listaDatos[index]["precio_producto"]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                key: ValueKey(
                                    'edit_icon_button_${_listaDatos[index]["id_producto"]}'), // Añadir ValueKey aquí
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActualizarProducto(
                                        idProducto: _listaDatos[index]
                                            ["id_producto"],
                                        nombreProducto: _listaDatos[index]
                                            ["nombre_producto"],
                                        precioProducto: _listaDatos[index]
                                            ["precio_producto"],
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    _obtenerDatos(); // Actualizar la lista después de actualizar
                                  }
                                },
                              ),
                              IconButton(
                                key: ValueKey(
                                    'delete_product_button_${_listaDatos[index]["id_producto"]}'), // Añadir ValueKey aquí
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _confirmarEliminacion(
                                      _listaDatos[index]["id_producto"]);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
    );
  }
}
