import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final String id;
  final DateTime fecha;
  final String nombre;
  final double precio;
  final String talla;
  final String color;
  final int cantidad;
  final double total;
  final int idProducto;

  Pedido({
    required this.id,
    required this.fecha,
    required this.nombre,
    required this.precio,
    required this.talla,
    required this.color,
    required this.cantidad,
    required this.total,
    required this.idProducto,
  });

  factory Pedido.fromMap(Map<String, dynamic> data) {
    return Pedido(
      id: data['id'],
      fecha: (data['fecha'] as Timestamp).toDate(),
      nombre: data['nombre'] ?? '',
      precio: (data['precio'] as num).toDouble(),
      talla: data['talla'] ?? '',
      color: data['color'] ?? '',
      cantidad: int.parse(data['cantidad'].toString()),
      total: (data['total'] as num).toDouble(),
      idProducto: data['id_detalle_prod'] ?? 0,
    );
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      fecha: _parseFecha(json['fecha']),
      nombre: json['nombre'] ?? '',
      precio: (json['precio'] as num).toDouble(),
      talla: json['talla'] ?? '',
      color: json['color'] ?? '',
      cantidad: int.parse(json['cantidad'].toString()),
      total: (json['total'] as num).toDouble(),
      idProducto: json['id_detalle_prod'] ?? json['idProducto'] ?? 0,
    );
  }

  static DateTime _parseFecha(dynamic fecha) {
    if (fecha is Timestamp) return fecha.toDate();
    if (fecha is DateTime) return fecha;
    if (fecha is String) return DateTime.tryParse(fecha) ?? DateTime.now();
    throw Exception('❌ Tipo de fecha no válido: $fecha');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'nombre': nombre,
      'precio': precio,
      'talla': talla,
      'color': color,
      'cantidad': cantidad.toString(),
      'total': total,
      'id_detalle_prod': idProducto,
    };
  }

  Map<String, dynamic> toJson() => toMap(); 
}
