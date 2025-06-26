import 'package:app_ropa/models/pedidoModel.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/providers/productoProvider.dart';
import 'package:app_ropa/repositories/pedidoRepositorie.dart';
import 'package:app_ropa/views/factura.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cartscreen extends StatelessWidget {
  const Cartscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = Provider.of<CarritoProvider>(context);

    double subtotal = 0.0;
    for (var item in carrito.productos) {
      subtotal += item['producto'].precio * item['cantidad'];
    }

    const double envio = 10.0;
    final double total = subtotal + envio;

    return Scaffold(
      appBar: AppBar(title: const Text('Carrito de compras')),
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
                              Container(
                                height: 120,
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
                        final carrito = Provider.of<CarritoProvider>(
                          context,
                          listen: false,
                        );
                        final repo = PedidoRepository();

                        List<Pedido> listaPedidos = [];

                        try {
                          for (var item in carrito.productos) {
                            final producto = item['producto'];
                            final pedido = Pedido(
                              fecha: DateTime.now(),
                              nombre: producto.nombre,
                              precio: producto.precio,
                              talla: item['talla'],
                              color: item['color'],
                              cantidad: item['cantidad'],
                              total: producto.precio * item['cantidad'],
                            );

                            await repo.agregarPedido(pedido);
                            listaPedidos.add(pedido);
                          }

                          carrito.vaciarCarrito();

                          // Redirigir a la pantalla de factura
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (_) => FacturaScreen(pedidos: listaPedidos),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al registrar pedido: $e'),
                            ),
                          );
                        }
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
