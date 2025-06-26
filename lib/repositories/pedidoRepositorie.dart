import 'package:app_ropa/models/pedidoModel.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/service/pedidoServicio.dart';


class PedidoRepository {
  final PedidoService _pedidoService;

  PedidoRepository({PedidoService? pedidoService})
      : _pedidoService = pedidoService ?? PedidoService();

  Future<void> agregarPedido(Pedido pedido) async {
    try {
      await _pedidoService.guardarPedido(pedido);
    } catch (e) {
      throw Exception('Error al guardar el pedido: $e');
    }
  }

  Future<List<Pedido>> obtenerTodosLosPedidos() async {
    try {
      return await _pedidoService.obtenerPedidos();
    } catch (e) {
      throw Exception('Error al obtener los pedidos: $e');
    }
  }

  Future<void> eliminarPedido(String id) async {
    try {
      await _pedidoService.eliminarPedido(id);
    } catch (e) {
      throw Exception('Error al eliminar el pedido: $e');
    }
  }
}