import 'package:app_ropa/models/pedidoModel.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:app_ropa/service/pedidoServicio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PedidoRepository {
  final PedidoService _pedidoService;

  PedidoRepository({PedidoService? pedidoService})
    : _pedidoService = pedidoService ?? PedidoService();

  /// Guarda el pedido en Firebase y en Oracle
Future<void> agregarPedido(Pedido pedido, Usuario usuario) async {
  try {
    // Guardar en Firebase
    await _pedidoService.guardarPedidoCompleto(
      pedido: pedido,
      usuario: usuario,
      items: [
        {
          'id_producto': pedido.idProducto,
          'cantidad': pedido.cantidad,
          'talla': pedido.talla,
          'color': pedido.color,
          'precio_unitario': pedido.precio,
        },
      ],
    );

    await _guardarEnOracle(pedido, usuario);

  } catch (e) {
    throw Exception('Error al guardar el pedido: $e');
  }
}
  Future<void> _guardarEnOracle(Pedido pedido, Usuario usuario) async {
    final url = Uri.parse('http://10.0.2.2:3000/insertar-pedido');

    final data = {
      "usuario": {
        "id": usuario.id,
        "nombre": usuario.nombre,
        "direccion": usuario.direccion,
        "email": usuario.email,
        "telefono": usuario.telefono,
        "tipo": usuario.tipo,
      },
      "factura": {
        "monto_total": pedido.total,
        "fecha_emision": DateTime.now().toIso8601String().substring(0, 10),
        "estado_pago": "pendiente",
        "metodo_pago": "tarjeta",
        "divisa": "PEN",
      },
      "pedido": {
        "id": pedido.id,
        "fecha_ingreso": DateTime.now().toIso8601String().substring(0, 10),
        "estado_pedido": "procesando",
        "total": pedido.total,
        "fecha_entrega_estimada": DateTime.now()
            .add(Duration(days: 7))
            .toIso8601String()
            .substring(0, 10),
      },
      "items": [
        {
          "cantidad": pedido.cantidad,
          "talla": pedido.talla,
          "color": pedido.color,
          "precio_unitario": pedido.precio,
          "id_producto": pedido.idProducto,
        },
      ],
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('❌ Oracle error: ${response.body}');
    } else {
      print('✅ Pedido completo guardado en Oracle');
    }
  }

  Future<List<Pedido>> obtenerTodosLosPedidos() async {
    return await _pedidoService.obtenerPedidos();
  }

  Future<void> eliminarPedido(String id) async {
    await _pedidoService.eliminarPedido(id);
  }

  Future<void> reducirStockEnOracle(int idProducto, int cantidadVendida) async {
    final url = Uri.parse('http://192.168.1.100:3000/reducir-stock');

    final body = {'id_producto': idProducto, 'cantidad': cantidadVendida};

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('✅ Stock actualizado en Oracle');
      } else {
        print('❌ Error al reducir stock en Oracle: ${response.body}');
      }
    } catch (e) {
      print('❌ Error de red al reducir stock en Oracle: $e');
    }
  }
}
