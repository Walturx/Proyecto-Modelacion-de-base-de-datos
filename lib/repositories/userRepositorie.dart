import 'dart:convert';

import 'package:app_ropa/models/userModel.dart';
import 'package:app_ropa/service/userService.dart';
import 'package:http/http.dart' as http;


class UsuarioRepository {
  final UsuarioService _usuarioService = UsuarioService();

  Future<List<Usuario>> obtenerTodosLosUsuarios() async {
    return await _usuarioService.obtenerUsuarios();
  }

  Future<Usuario?> buscarUsuarioPorId(String id) async {
    return await _usuarioService.obtenerUsuarioPorId(id);
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    await _usuarioService.actualizarUsuario(usuario);
  }

  Future<void> eliminarUsuario(String id) async {
    await _usuarioService.eliminarUsuario(id);
  }

  Future<void> registrarUsuario(Usuario usuario) async {
    // Firebase
    await _usuarioService.agregarUsuario(usuario);

    // Oracle SQL
    await _guardarUsuarioEnOracle(usuario);
  }

  Future<void> _guardarUsuarioEnOracle(Usuario usuario) async {
    final url = Uri.parse('http://10.0.2.2:3000/insertar-usuario');

    final data = {
      "id": usuario.id,
      "nombre": usuario.nombre,
      "tipo": usuario.tipo,
      "email": usuario.email,
      "telefono": usuario.telefono,
      "direccion": usuario.direccion
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('❌ Error al guardar usuario en Oracle: ${response.body}');
    } else {
      print('✅ Usuario guardado en Oracle');
    }
    
  }
  Future<Usuario?> obtenerUsuarioPorEmail(String email) async {
  return await _usuarioService.obtenerUsuarioPorEmail(email);
}

}