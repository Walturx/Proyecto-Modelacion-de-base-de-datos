import 'package:flutter/material.dart';
import 'package:app_ropa/models/pedidoModel.dart';
import 'package:go_router/go_router.dart';

class FacturaScreen extends StatelessWidget {
  final List<Pedido> pedidos;
  final double envio;

  const FacturaScreen({
    super.key,
    required this.pedidos,
    this.envio = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    double subtotal = pedidos.fold(
      0.0,
      (sum, item) => sum + (item.precio * item.cantidad),
    );

    double total = subtotal + envio;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Factura"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🧾 Detalle de Factura",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Fecha: ${DateTime.now().toString().substring(0, 19)}",
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 30),

            Expanded(
              child: ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green, size: 30),
                    title: Text(
                      pedido.nombre,
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Talla: ${pedido.talla} - Color: ${pedido.color}", style: TextStyle(fontSize: 20),),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("x${pedido.cantidad}",style: TextStyle(fontSize: 20),),
                        Text(
                          "S/ ${(pedido.precio * pedido.cantidad).toStringAsFixed(2)}",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Divider(thickness: 2, height: 30),

            // Totales
            _buildSummaryRow("Subtotal", subtotal),
            _buildSummaryRow("Envío", envio),
            const SizedBox(height: 10),
            _buildSummaryRow("Total", total, isBold: true),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                onPressed: () {
                   context.go('/home');
                },
                label: const Text("Volver al inicio"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$label:",
          style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          "S/ ${value.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 18, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}
