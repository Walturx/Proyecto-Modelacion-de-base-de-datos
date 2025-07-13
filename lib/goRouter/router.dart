import 'package:app_ropa/models/pedidoModel.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:app_ropa/views/cartScreen.dart';
import 'package:app_ropa/views/factura.dart';
import 'package:app_ropa/views/homeScreen.dart';
import 'package:app_ropa/views/productScreen.dart';
import 'package:app_ropa/views/userScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.register, 
  routes: [
    // Ruta principal
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const Userscreen(),
    ),

    // Ruta a la pantalla de producto

 GoRoute(
  path: Routes.home,
  builder: (context, state) {
    if (state.extra == null || state.extra is! Usuario) {
      return const Scaffold(
        body: Center(child: Text('⚠️ Usuario no enviado')),
      );
    }

    final usuario = state.extra as Usuario;
    return Homescreen(usuario: usuario);
  },
),



   GoRoute(
  path: Routes.ropa,
  builder: (context, state) {
    final map = state.extra as Map<String, dynamic>;
    final producto = map['producto'] as Producto;
    final usuario = map['usuario'] as Usuario;
    return ProductScreen(producto: producto, usuario: usuario);
  },
),


    GoRoute(
  path: Routes.cartPage,
  builder: (context, state) {
    final usuario = state.extra as Usuario;
    return Cartscreen(usuario: usuario); // ⬅️ pásalo aquí
  },
),
GoRoute(
  path: Routes.facturaPage,
  builder: (context, state) {
    final extra = state.extra;

    // 🟡 DEPURACIÓN: mostrar qué llega en el .extra
    print('📦 state.extra = $extra');

    // 🔒 Verifica que no sea null
    if (extra == null) {
      return const Scaffold(
        body: Center(child: Text('❌ No se pasó información')),
      );
    }

    // 🔒 Verifica que sea un mapa
    if (extra is! Map) {
      return const Scaffold(
        body: Center(child: Text('❌ El parámetro extra no es un Map')),
      );
    }

    final map = extra as Map;

    // 🔒 Verifica que contenga los datos esperados
    if (!map.containsKey('pedidos') || !map.containsKey('usuario')) {
      return const Scaffold(
        body: Center(child: Text('❌ Faltan datos en el mapa')),
      );
    }

    final pedidosRaw = map['pedidos'];
    final usuario = map['usuario'];

    if (usuario is! Usuario) {
      return const Scaffold(
        body: Center(child: Text('❌ Usuario inválido')),
      );
    }

    // ✅ Convertimos la lista de forma segura
    final List<Pedido> pedidos = pedidosRaw is List
        ? pedidosRaw.map<Pedido>((e) {
            if (e is Pedido) return e;
            if (e is Map) return Pedido.fromJson(Map<String, dynamic>.from(e));
            throw Exception('Elemento inválido en pedidos: $e');
          }).toList()
        : [];

    return FacturaScreen(
      pedidos: pedidos,
      usuario: usuario,
    );
  },
),





  ],
);

class Routes {
  Routes._();
  static const register = '/register';
  static const home = '/home';
  static const ropa = '/ropa';
  static const splash = '/splash';
  static const cartPage = '/cart';
  static const facturaPage = '/factura';
}