import 'package:app_ropa/goRouter/router.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:app_ropa/repositories/userRepositorie.dart';
import 'package:app_ropa/service/generarIDService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Userscreen extends StatefulWidget {
  const Userscreen({super.key});

  @override
  State<Userscreen> createState() => _UserscreenState();
}

class _UserscreenState extends State<Userscreen> {
  @override
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  String tipoPersona = 'Seleccione';

  String _generarIdCliente() {
  final random = DateTime.now().millisecondsSinceEpoch;
  return random.toRadixString(16).substring(0, 8).toUpperCase(); // Ej: 2FD2529A
}
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Registro de Usuario",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            SizedBox(height: 40),

            Container(
              height: 100,
              width: 300,
              child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre de Usuario',
                  hintText: 'Ingrese su nombre de usuario',
                ),
              ),
            ),
            SizedBox(height: 10),

            Container(
              height: 100,
              width: 300,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo Electrónico',
                  hintText: 'Ingrese su correo electrónico',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              width: 300,
              child: TextField(
                controller: direccionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Dirección',
                  hintText: 'Ingrese su dirección',
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 100,
              width: 300,
              child: TextField(
                controller: telefonoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Teléfono',
                  hintText: 'Ingrese su teléfono',
                ),
              ),
            ),

            Container(
              height: 100,
              width: 300,
              child: DropdownButtonFormField<String>(
                value: tipoPersona,
                items:
                    ['Seleccione', 'Persona Natural', 'Empresa']
                        .map(
                          (tipoPersona) => DropdownMenuItem(
                            value: tipoPersona,
                            child: Text(tipoPersona),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    tipoPersona = value!;
                  });
                },
              ),
            ),
            SizedBox(height: 20),

            SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () async {
                if (usernameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    direccionController.text.isEmpty ||
                    telefonoController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, complete todos los campos'),
                    ),
                  );
                } else if (tipoPersona == "Seleccione") {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, seleccione un tipo de persona'),
                    ),
                  );
                } else {
                  final repo = UsuarioRepository();

                  String idGenerado = _generarIdCliente();
                  Usuario nuevoUsuario = Usuario(
                    id: idGenerado,
                    // 👈 genera un ID único local
                    nombre: usernameController.text,
                    direccion: direccionController.text,
                    email: emailController.text,
                    telefono: telefonoController.text,
                    tipo: tipoPersona,
                  );

                  try {
                    await repo.registrarUsuario(nuevoUsuario);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ Usuario guardado exitosamente'),
                      ),
                    );

                    // Navega al HomeScreen pasando el usuario
                    context.go('/home', extra: nuevoUsuario);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ Error al registrar usuario: $e'),
                      ),
                    );
                  }
                }
              },
              child: Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }
}
