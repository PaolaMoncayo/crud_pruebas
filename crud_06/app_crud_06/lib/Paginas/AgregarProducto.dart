import 'package:flutter/material.dart';
import 'package:app_crud_06/Services/AgregarProductoService.dart';

class AgregarProducto extends StatefulWidget {
  final AgregarProductoService agregarProductoService;

  const AgregarProducto({
    Key? key,
    required this.agregarProductoService,
  }) : super(key: key);

  @override
  State<AgregarProducto> createState() => _AgregarProductoState();
}

class _AgregarProductoState extends State<AgregarProducto> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nombreProducto = TextEditingController();
  TextEditingController precioProducto = TextEditingController();

  void _vaciarCampos() {
    setState(() {
      nombreProducto.clear();
      precioProducto.clear();
    });
  }

  String? _validarNombreProducto(String? value) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    if (value == null || value.isEmpty) {
      return 'El nombre del producto no puede estar vacío';
    } else if (!regex.hasMatch(value)) {
      return 'El nombre del producto solo puede contener letras y espacios';
    }
    return null;
  }

  String? _validarPrecioProducto(String? value) {
    final regex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (value == null || value.isEmpty) {
      return 'El precio del producto no puede estar vacío';
    } else if (!regex.hasMatch(value)) {
      return 'Ingresa un precio válido (ej. 123.45)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar producto"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                key: ValueKey('product_name'),
                controller: nombreProducto,
                decoration: const InputDecoration(
                  hintText: 'Nombre Producto',
                ),
                validator: _validarNombreProducto,
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: ValueKey('product_price'),
                controller: precioProducto,
                decoration: const InputDecoration(
                  hintText: 'Precio Producto',
                ),
                keyboardType: TextInputType.number,
                validator: _validarPrecioProducto,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                key: ValueKey('save_button'),
                onPressed: () async {
                  if (formKey.currentState?.validate() ?? false) {
                    // Añadir impresión de datos para depurar
                    print(
                        'Datos enviados: nombre=${nombreProducto.text}, precio=${precioProducto.text}');

                    bool resultado =
                        await widget.agregarProductoService.guardarProducto(
                      nombreProducto: nombreProducto.text,
                      precioProducto: precioProducto.text,
                    );
                    if (resultado) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Datos guardados exitosamente'),
                        ),
                      );
                      _vaciarCampos();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al guardar los datos'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
