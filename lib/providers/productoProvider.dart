import 'package:app_ropa/models/ropaModel.dart';
import 'package:flutter/material.dart';

class CarritoProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _productos = [];

  List<Map<String, dynamic>> get productos => _productos;

  void agregarProducto(
    Producto producto,
    int cantidad,
    String talla,
    String color,
  ) {
    _productos.add({
      'producto': producto,
      'cantidad': cantidad,
      'talla': talla,
      'color': color,
      'descripcion': producto.descripcion,
    });
    notifyListeners();
  }
 int _cantidad = 0;
  int get cantidad => _cantidad;
  void obtenerCantidad(int cantidades) {
    _cantidad = cantidades;
    notifyListeners();
  }
  double get total {
    return _productos.fold(
      0.0,
      (suma, item) => suma + item['producto'].precio * item['cantidad'],
    );
  }

  void vaciarCarrito() {
    _productos.clear();
    notifyListeners();
  }

  void printCarrito() {
    for (var item in _productos) {
      final p = item['producto'] as Producto;
      print(
          "Producto: ${p.nombre} | Precio: S/${p.precio} | Cantidad: ${item['cantidad']} | Talla: ${item['talla']} | Color: ${item['color']} | Descripción: ${item['descripcion']}");
    }
    print("Total: S/${total.toStringAsFixed(2)}");
  }
}