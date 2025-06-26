class Producto {
  final String nombre;
  final String imagen;
  final double precio;
  final List<String> tallas;
  final List<String> colores;
  final String descripcion;
  final int stock;

  Producto({
    required this.nombre,
    required this.imagen,
    required this.precio,
    required this.tallas,
    required this.colores,
    required this.descripcion,
    required this.stock,
  });

  factory Producto.fromMap(Map<String, dynamic> data) {
    return Producto(
      nombre: data['nombre'] ?? '',
      imagen: data['imagen'] ?? '',
      precio: (data['precio'] is int)
          ? (data['precio'] as int).toDouble()
          : (data['precio'] is double)
              ? data['precio']
              : double.tryParse(data['precio'].toString()) ?? 0.0,
      tallas: List<String>.from(data['tallas'] ?? []),
      colores: List<String>.from(data['colores'] ?? []),
      descripcion: data['descripcion'] ?? '',
      stock: data['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'imagen': imagen,
      'precio': precio,
      'tallas': tallas,
      'colores': colores,
      'descripcion': descripcion,
      'stock': stock,
    };
  }
}
