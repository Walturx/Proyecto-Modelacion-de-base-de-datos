import 'package:app_ropa/auth/authService.dart';
import 'package:app_ropa/cubit/ropa_cubit.dart';
import 'package:app_ropa/goRouter/router.dart';
import 'package:app_ropa/models/ropaModel.dart';
import 'package:app_ropa/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
class Homescreen extends StatefulWidget {
  final Usuario usuario;

  const Homescreen({super.key, required this.usuario});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
   @override
  void initState() {
    super.initState();
    context.read<RopaCubit>().getRopa();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Prendas'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              context.push(Routes.cartPage, extra: widget.usuario);
              
            },
          ),
         IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              context.go('/register'); // o context.go(Routes.register);
            },
         )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 20),
              BlocBuilder<RopaCubit, RopaState>(
                builder: (context, state) {
                  if (state is RopaSuccess) {
                    Set<String> categorias = {};
                  
                    
                
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categorias.map((categoria) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              categoria,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  } else if (state is RopaError) {
                    return Text(state.error);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(height: 20),
              Text("Todas las prendas",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              BlocBuilder<RopaCubit, RopaState>(
                builder: (context, state) {
                  if (state is RopaSuccess) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.77,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.ropa.length,
                      itemBuilder: (context, index) {
                        return buildRopaCard(context, state.ropa[index]);
                      },
                    );
                  } else if (state is RopaError) {
                    return Text(state.error);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRopaCard(BuildContext context, Producto ropa) {
    return InkWell(
      onTap: () {
         context.push(Routes.ropa, extra: {
  'producto': ropa,
  'usuario': widget.usuario,
});

      },
      child: Container(
        height: 400,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2.0,
              blurRadius: 5.0,
            )
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                ropa.imagen,
                fit: BoxFit.fitHeight,
                width: double.infinity,
                height: 180,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ropa.nombre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "S/${ropa.precio}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}