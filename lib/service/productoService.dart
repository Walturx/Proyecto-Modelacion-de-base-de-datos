import 'package:cloud_firestore/cloud_firestore.dart';

class ProductoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> restarStockPorNombre(String nombre, int cantidad) async {
    final query = await _db
        .collection('productos')
        .where('nombre', isEqualTo: nombre)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception('Producto "$nombre" no encontrado');
    }

    final docRef = query.docs.first.reference;

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final stockActual = snapshot.get('stock');

      if (stockActual < cantidad) {
        throw Exception('Stock insuficiente para "$nombre"');
      }

      transaction.update(docRef, {
        'stock': stockActual - cantidad,
      });
    });
  }
}
