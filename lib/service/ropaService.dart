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
  
}
