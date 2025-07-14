import 'package:app_ropa/auth/authService.dart';
import 'package:app_ropa/goRouter/router.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:app_ropa/providers/loginProvider.dart';
import 'package:app_ropa/repositories/userRepositorie.dart';
import 'package:app_ropa/service/generarIDService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Userscreen extends StatefulWidget {
  const Userscreen({super.key});

  @override
  State<Userscreen> createState() => _UserscreenState();
}

class _UserscreenState extends State<Userscreen> {
  @override
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController telefonoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String tipoPersona = 'Seleccione';
  bool isLogin = true;
  late List<Usuario> users;

  String _generarIdCliente() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return random.toRadixString(16).substring(0, 8).toUpperCase();
  }

  final AuthService _authService = AuthService();
  void _registerAndSave() async {
    String idGenerado = _generarIdCliente();
    Usuario nuevoUsuario = Usuario(
      id: idGenerado,
      nombre: usernameController.text,
      direccion: direccionController.text,
      email: emailController.text,
      telefono: telefonoController.text,
      tipo: tipoPersona,
    );

    try {
      await UsuarioRepository().registrarUsuario(nuevoUsuario);
      Fluttertoast.showToast(
        msg: "Usuario registrado con éxito",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      context.go('/home', extra: nuevoUsuario);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error al registrar usuario",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<dynamic> _register() async {
    String email = emailController.text;
    String password = passwordController.text;
    var user = await _authService.registerWithEmailAndPassword(email, password);
    if (user != null) {
      print("Usuario registrado con éxito: ${user.email}");
      return user;
    } else {
      print("Error en el registro");
      Fluttertoast.showToast(
        msg: "❌ Error al registrar en Firebase Auth",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

void _login() async {
  String email = emailController.text.trim();
  String password = passwordController.text.trim();

  var user = await _authService.signInWithEmailAndPassword(email, password);
  if (user != null) {
    print("✅ Usuario logueado con éxito: ${user.email}");

    final usuario = await UsuarioRepository().obtenerUsuarioPorEmail(user.email!);

    if (usuario != null) {
      print("📦 Usuario cargado desde Firestore: ${usuario.nombre}");
      context.go('/home', extra: usuario); 
    } else {
      print("⚠️ No se encontró el perfil en Firestore");
      Fluttertoast.showToast(msg: "No se encontró el usuario en la base de datos");
    }
  } else {
    Fluttertoast.showToast(msg: "Cuenta o contraseña incorrectos");
  }
}


  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }

  void getUsers() async {
    try {
      users = await UsuarioRepository().obtenerTodosLosUsuarios();
      for (Usuario us in users) {
        print(us.nombre);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    final providerLogin = Provider.of<Loginprovider>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? 'Iniciar Sesión' : 'Crear Cuenta',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!isLogin) ...[
                        TextFormField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Ingrese su nombre'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: direccionController,
                          decoration: const InputDecoration(
                            labelText: 'Dirección',
                            prefixIcon: Icon(Icons.home),
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Ingrese su dirección'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: telefonoController,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Ingrese su teléfono'
                                      : null,
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: tipoPersona,
                          items:
                              ['Seleccione','Natural', 'Empresa']
                                  .map(
                                    (tipo) => DropdownMenuItem(
                                      value: tipo,
                                      child: Text(tipo),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (value) => setState(() => tipoPersona = value!),
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Persona',
                            prefixIcon: Icon(Icons.business),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        validator:
                            (value) =>
                                value == null ||
                                        value.isEmpty ||
                                        !value.contains('@')
                                    ? 'Ingrese un correo válido'
                                    : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator:
                            (value) =>
                                value == null || value.length < 6
                                    ? 'La contraseña debe tener al menos 6 caracteres'
                                    : null,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (isLogin) {
                              _login();
                              providerLogin.setEmail(emailController.text);
                              providerLogin.setPassword(
                                passwordController.text,
                              );
                            } else {
                              final registrado = await _register();
                              if (registrado != null) {
                                _registerAndSave(); 
                              }
                            }
                          }
                        },
                        child: Text(isLogin ? 'Iniciar Sesión' : 'Registrarse'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 32,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: toggleAuthMode,
                        child: Text(
                          isLogin
                              ? '¿No tienes cuenta? Regístrate'
                              : '¿Ya tienes cuenta? Inicia sesión',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
