import 'package:app_ropa/models/pedidoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _collectionPath = 'pedidos';

  // Guardar un pedido
  Future<void> guardarPedido(Pedido pedido) async {
    await _db.collection(_collectionPath).add(pedido.toMap());
  }

  // Leer todos los pedidos
  Future<List<Pedido>> obtenerPedidos() async {
    final snapshot = await _db.collection(_collectionPath).get();
    return snapshot.docs.map((doc) => Pedido.fromMap(doc.data())).toList();
  }

  // Eliminar un pedido por ID (opcional)
  Future<void> eliminarPedido(String id) async {
    await _db.collection(_collectionPath).doc(id).delete();
  }
}
