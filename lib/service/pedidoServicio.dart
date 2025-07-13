import 'package:app_ropa/models/pedidoModel.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'pedidos';
Future<void> guardarPedidoCompleto({
  required Pedido pedido,
  required Usuario usuario,
  required List<Map<String, dynamic>> items,
}) async {
  final docRef = _db.collection(_collectionPath).doc(pedido.id);

  await docRef.set({
    'pedido': pedido.toMap(),
    'usuario': {
      'id': usuario.id,
      'nombre': usuario.nombre,
      'direccion': usuario.direccion,
      'email': usuario.email,
      'telefono': usuario.telefono,
      'tipo': usuario.tipo,
    },
    'items': items,
  });
}


 Future<List<Pedido>> obtenerPedidos() async {
  final snapshot = await _db.collection(_collectionPath).get();
  return snapshot.docs.map((doc) {
    final data = doc.data();
    final pedidoMap = data['pedido'];
    return Pedido.fromMap(pedidoMap);
  }).toList();
}


  Future<void> eliminarPedido(String id) async {
    await _db.collection(_collectionPath).doc(id).delete();
  }
}
