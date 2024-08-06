import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_crud_06/Services/ActualizarProductoService.dart';

class ActualizarProducto extends StatefulWidget {
  final String idProducto;
  final String nombreProducto;
  final String precioProducto;

  const ActualizarProducto({
    super.key,
    required this.idProducto,
    required this.nombreProducto,
    required this.precioProducto,
  });

  @override
  State<ActualizarProducto> createState() => _ActualizarProductoState();
}

class _ActualizarProductoState extends State<ActualizarProducto> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController nombreProductoController;
  late TextEditingController precioProductoController;
  final ActualizarProductoService _actualizarProductoService =
      ActualizarProductoService();

  @override
  void initState() {
    super.initState();
    nombreProductoController =
        TextEditingController(text: widget.nombreProducto);
    precioProductoController =
        TextEditingController(text: widget.precioProducto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                key:
                    const ValueKey('edit_product_name'), // Añadir ValueKey aquí
                controller: nombreProductoController,
                decoration: const InputDecoration(
                  hintText: 'Nombre Producto',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre del producto no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey(
                    'edit_product_price'), // Añadir ValueKey aquí
                controller: precioProductoController,
                decoration: const InputDecoration(
                  hintText: 'Precio Producto',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El precio del producto no puede estar vacío';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: const ValueKey('update_button'), // Añadir ValueKey aquí
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    bool resultado =
                        await _actualizarProductoService.actualizarProducto(
                      idProducto: widget.idProducto,
                      nombreProducto: nombreProductoController.text,
                      precioProducto: precioProductoController.text,
                      client: http.Client(),
                    );
                    if (resultado) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Producto actualizado exitosamente')),
                      );
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error al actualizar el producto')),
                      );
                    }
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
