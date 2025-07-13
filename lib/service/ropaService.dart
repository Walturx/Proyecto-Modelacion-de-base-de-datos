import 'package:app_ropa/models/ropaModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RopaServiceFirebase {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<Producto>> getAllRopa() async {
    try {
      final QuerySnapshot querySnapshot = await db.collection('productos').get();

      List<Producto> listaRopa = querySnapshot.docs.map((doc) {
        Map<String, dynamic> ropaData = doc.data() as Map<String, dynamic>;

        return Producto.fromMap(ropaData);
      }).toList();
      print(listaRopa);
      return listaRopa;
    } catch (e) {
      print("Error al obtener ropa: $e");
      return [];
    }
  }
  
  
Future<void> reducirStockEnFirebase(String idProducto, int cantidadVendida) async {
  final ropaRef = FirebaseFirestore.instance.collection('productos');

  try {
    // Asegúrate que idProducto es número
    final idNum = int.tryParse(idProducto);
    if (idNum == null) {
      throw Exception('ID de producto inválido: $idProducto');
    }

    final query = await ropaRef.where('id', isEqualTo: idNum).get();

    if (query.docs.isEmpty) {
      print('❌ Producto con id $idNum no encontrado por campo "id"');
      throw Exception('Producto no encontrado en Firebase');
    }

    final doc = query.docs.first;
    final docRef = ropaRef.doc(doc.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final data = snapshot.data();

      if (data == null) {
        throw Exception('Documento vacío');
      }

      final stockActual = (data['stock'] ?? 0) as int;
      final nuevoStock = stockActual - cantidadVendida;

      transaction.update(docRef, {'stock': nuevoStock});
    });

    print('🟢 Stock reducido correctamente en Firebase para ID $idNum');
  } catch (e) {
    print('❌ Error durante la reducción de stock: $e');
    rethrow;
  }
}
}

