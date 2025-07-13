import 'package:app_ropa/goRouter/router.dart';
import 'package:app_ropa/models/pedidoModel.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:app_ropa/providers/productoProvider.dart';
import 'package:app_ropa/repositories/pedidoRepositorie.dart';
import 'package:app_ropa/service/ropaService.dart';
import 'package:app_ropa/views/factura.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Cartscreen extends StatelessWidget {
  final Usuario usuario;

  const Cartscreen({super.key, required this.usuario});

  String _generarIdPedido() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final codigo = timestamp.toRadixString(16).substring(0, 8).toUpperCase();
    return 'PED-$codigo';
  }

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);

    double subtotal = 0.0;
    for (var item in carrito.productos) {
      subtotal += item['producto'].precio * item['cantidad'];
    }

    const double envio = 10.0;
    final double total = subtotal + envio;
    final ropaService = RopaServiceFirebase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de compras'),
        actions: [
          IconButton(
            onPressed: () {
    context.go(Routes.home, extra: usuario);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ],
      ),
      body:
          carrito.productos.isEmpty
              ? const Center(child: Text('Tu carrito está vacío'))
              : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: carrito.productos.length,
                        itemBuilder: (context, index) {
                          final item = carrito.productos[index];
                          final producto = item['producto'] as Producto;
                          final int cantidad = item['cantidad'];

                          return Column(
                            children: [
                              SizedBox(
                                height: 180,
                                child: Row(
                                  children: [
                                    Image.network(
                                      producto.imagen,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            producto.nombre,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Talla: ${item['talla']} - Color: ${item['color']}',
                                          ),
                                          Text(
                                            "S/ ${(producto.precio * cantidad).toStringAsFixed(2)}",
                                            style: const TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              onPressed: () {
                                                if (cantidad > 1) {
                                                  carrito
                                                      .productos[index]['cantidad']--;
                                                  carrito.notifyListeners();
                                                }
                                              },
                                            ),
                                            Text('$cantidad'),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              onPressed: () {
                                                carrito
                                                    .productos[index]['cantidad']++;
                                                carrito.notifyListeners();
                                              },
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            carrito.productos.removeAt(index);
                                            carrito.notifyListeners();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildResumenCompra(
                      carrito.productos.length,
                      subtotal,
                      envio,
                      total,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final repo = PedidoRepository();
                        final ropaService = RopaServiceFirebase();
                        List<Pedido> listaPedidos = [];

                        try {
                          for (var item in carrito.productos) {
                            final producto = item['producto'];
                            if (producto == null || producto is! Producto) {
                              print('❌ Producto inválido: $item');
                              continue;
                            }

                            final pedido = Pedido(
                              id: _generarIdPedido(),
                              idProducto: producto.idProducto,
                              fecha: DateTime.now(),
                              nombre: producto.nombre,
                              precio: producto.precio,
                              talla: item['talla'],
                              color: item['color'],
                              cantidad: item['cantidad'],
                              total: producto.precio * item['cantidad'],
                            );

                            print("✅ Pedido creado: ${pedido.toMap()}");

                            await repo.agregarPedido(pedido, usuario);
                            await ropaService.reducirStockEnFirebase(
                              producto.idProducto.toString(),
                              item['cantidad'],
                            );
                            await repo.reducirStockEnOracle(
                              producto.idProducto,
                              item['cantidad'],
                            );

                            listaPedidos.add(pedido);
                          }
                        } catch (e, stack) {
                          print('❌ Error durante registro: $e');
                          print(stack);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al registrar pedido: $e'),
                            ),
                          );
                          return; // 🚫 Evita continuar si hubo error
                        }

                        if (listaPedidos.isEmpty) {
                          print(
                            '⚠️ No se generaron pedidos. Navegación cancelada.',
                          );
                          return;
                        }

                        carrito.vaciarCarrito();

                        print(
                          "🟢 Navegando a factura con ${listaPedidos.length} pedidos",
                        );

                        context.push(
                          Routes.facturaPage,
                          extra: {'pedidos': listaPedidos, 'usuario': usuario},
                        );
                      },
                      child: const Text(
                        "Pagar",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildResumenCompra(
    int items,
    double subtotal,
    double envio,
    double total,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Subtotal ($items productos):",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "S/ ${subtotal.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Envío:", style: TextStyle(fontSize: 18)),
            Text(
              "S/ 10.00",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Divider(height: 30, thickness: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "S/ ${total.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
