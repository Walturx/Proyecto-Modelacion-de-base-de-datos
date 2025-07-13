import 'package:app_ropa/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsuarioService {
  final CollectionReference usuariosRef =
      FirebaseFirestore.instance.collection('usuarios'); // ← corregido: colección en minúscula

  // Crear o registrar un usuario
  Future<void> agregarUsuario(Usuario usuario) async {
    await usuariosRef.doc(usuario.id).set(usuario.toMap());
  }

  Future<List<Usuario>> obtenerUsuarios() async {
    try {
      QuerySnapshot snapshot = await usuariosRef.get();
      return snapshot.docs
          .map((doc) => Usuario.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener usuarios: $e');
      return [];
    }
  }

  Future<Usuario?> obtenerUsuarioPorId(String id) async {
    try {
      DocumentSnapshot doc = await usuariosRef.doc(id).get();
      if (doc.exists) {
        return Usuario.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error al obtener usuario por ID: $e');
    }
    return null;
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    try {
      await usuariosRef.doc(usuario.id).update(usuario.toMap());
    } catch (e) {
      print('Error al actualizar usuario: $e');
    }
  }

  Future<void> eliminarUsuario(String id) async {
    try {
      await usuariosRef.doc(id).delete();
    } catch (e) {
      print('Error al eliminar usuario: $e');
    }
  }
}
