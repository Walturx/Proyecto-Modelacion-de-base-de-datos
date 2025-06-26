import 'package:app_ropa/models/pedidoModel.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/views/cartScreen.dart';
import 'package:app_ropa/views/factura.dart';
import 'package:app_ropa/views/homeScreen.dart';
import 'package:app_ropa/views/productScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home, 
  routes: [
    // Ruta principal
    GoRoute(
      path: Routes.home,
      builder: (context, state) => const Homescreen(),
    ),

    // Ruta a la pantalla de producto
    GoRoute(
      path: Routes.ropa,
      builder: (context, state) {
        final producto = state.extra as Producto;
        return ProductScreen(producto: producto);
      },
    ),

    GoRoute(path: Routes.cartPage, builder: (context, state) {
      return const Cartscreen();
    }),
   GoRoute(
  path: Routes.facturaPage,
  builder: (context, state) {
    final pedido = state.extra as List<Pedido>;
    return FacturaScreen(pedidos: pedido);
  },
),
  ],
);

class Routes {
  Routes._();

  static const home = '/home';
  static const ropa = '/ropa';
  static const splash = '/splash';
  static const cartPage = '/cart';
  static const facturaPage = '/factura';
}