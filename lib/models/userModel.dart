class Usuario {
  final String id;
  final String nombre;
  final String direccion;
  final String email;
  final String telefono;
  final String tipo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.email,
    required this.telefono,
    required this.tipo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'email': email,
      'telefono': telefono,
      'tipo': tipo,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nombre: map['nombre'],
      direccion: map['direccion'],
      email: map['email'],
      telefono: map['telefono'].toString(),
      tipo: map['tipo'],
    );
  }

  @override
  String toString() {
    return 'Usuario(id: $id, nombre: $nombre)';
  }
}
