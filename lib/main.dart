import 'package:app_ropa/cubit/ropa_cubit.dart';
import 'package:app_ropa/firebase_options.dart';
import 'package:app_ropa/goRouter/router.dart';
import 'package:app_ropa/providers/loginProvider.dart';
import 'package:app_ropa/providers/productoProvider.dart';
import 'package:app_ropa/views/homeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform, 
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarritoProvider()),
        ChangeNotifierProvider(create: (_) => Loginprovider()),

        BlocProvider(create: (_) => RopaCubit()..getRopa()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App Ropa',
      debugShowCheckedModeBanner: false,
      routerConfig: router, 
    );
  }
}