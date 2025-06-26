import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final DateTime fecha;
  final String nombre;
  final double precio;
  final String talla;
  final String color;
  final int cantidad;
  final double total;

  Pedido({
    required this.fecha,
    required this.nombre,
    required this.precio,
    required this.talla,
    required this.color,
    required this.cantidad,
    required this.total,
  });

  // Para crear desde Firestore
  factory Pedido.fromMap(Map<String, dynamic> data) {
    return Pedido(
      fecha: (data['fecha'] as Timestamp).toDate(),
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] as num).toDouble(),
      talla: data['talla'] ?? '',
      color: data['color'] ?? '',
      cantidad: int.parse(data['cantidad'] ?? '0'),
      total: (data['total'] as num).toDouble(),
    );
  }

  // Para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'nombre': nombre,
      'precio': precio,
      'talla': talla,
      'color': color,
      'cantidad': cantidad.toString(),
      'total': total,
    };
  }
}
