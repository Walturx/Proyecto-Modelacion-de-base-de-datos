import 'package:app_ropa/goRouter/router.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:app_ropa/providers/productoProvider.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  final Producto producto;
  final Usuario usuario;

  const ProductScreen({
    super.key,
    required this.producto,
    required this.usuario,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

String? tallaSeleccionada;
String? colorSeleccionado;

class _ProductScreenState extends State<ProductScreen> {
  int counter = 1;

 @override
Widget build(BuildContext context) {
  final providerProducto = Provider.of<CarritoProvider>(context);

  return Scaffold(
    appBar: AppBar(
      title: const Text('Detalle del producto'),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {}, 
        ),
      ],
    ),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 400,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.network(
                    widget.producto.imagen,
                    fit: BoxFit.cover,
                  );
                },
                itemCount: 1,
                pagination: SwiperPagination(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.producto.nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "S/ ${widget.producto.precio.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Text( "Stock: ${widget.producto.stock}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 260),
                Text(widget.producto.stock > 0
                    ? "Disponible"
                    : "No disponible",
                  style: TextStyle(
                    color: widget.producto.stock > 0 ? Colors.green : Colors.red,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (counter > 1) counter--;
                          });
                        },
                      ),
                      Text('$counter', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            counter++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () {
                    if (tallaSeleccionada == null ||
                        colorSeleccionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona talla y color'),
                        ),
                      );
                      return;
                    }

                    if (counter <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Selecciona al menos 1 unidad'),
                        ),
                      );
                      return;
                    }

                    Provider.of<CarritoProvider>(
                      context,
                      listen: false,
                    ).agregarProducto(
                      widget.producto,
                      counter,
                      tallaSeleccionada!,
                      colorSeleccionado!,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Producto agregado al carrito'),
                      ),
                    );

                    GoRouter.of(context).go(
                      Routes.cartPage,
                      extra: widget.usuario,
                    );
                  },
                  child: const Text("Agregar al carrito"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.producto.descripcion,
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: widget.producto.tallas.map((talla) {
                  return ChoiceChip(
                    label: Text(talla),
                    selected: tallaSeleccionada == talla,
                    onSelected: (_) {
                      setState(() {
                        tallaSeleccionada = talla;
                      });
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: widget.producto.colores.map((color) {
                  return ChoiceChip(
                    label: Text(color),
                    selected: colorSeleccionado == color,
                    onSelected: (_) {
                      setState(() {
                        colorSeleccionado = color;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
