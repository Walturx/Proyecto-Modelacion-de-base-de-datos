import 'package:flutter/material.dart';

class Loginprovider with ChangeNotifier{
  String _email = "";
  String get email  => _email;
  String _password = "";
  String get password => _password;

  void setEmail(String correo) {
    _email = correo;
    notifyListeners();
  }
  void setPassword(String contrasena) {
    _password = contrasena;
    notifyListeners();
  }

}