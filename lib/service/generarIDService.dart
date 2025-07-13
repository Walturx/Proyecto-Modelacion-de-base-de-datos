// utils/id_generator.dart
import 'dart:math';

String generarId({bool conPrefijo = false}) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final rand = Random.secure();

  String id = List.generate(8, (index) => chars[rand.nextInt(chars.length)]).join();

  return conPrefijo ? 'PED-$id' : id;
}
