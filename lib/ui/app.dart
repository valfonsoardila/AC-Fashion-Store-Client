import 'package:acfashion_store/ui/anim/intro_screen.dart';
import 'package:acfashion_store/ui/auth/login_screen.dart';
import 'package:acfashion_store/ui/auth/perfil.dart';
import 'package:acfashion_store/ui/auth/register.dart';
import 'package:acfashion_store/ui/auth/restaurar.dart';
import 'package:acfashion_store/ui/home/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:netduino_upc_app/ui/anim/introFull_app.dart';
class App extends StatelessWidget {
  App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ac Fashion App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        // "/": (context) =>  IntroSimple(),
        "/": (context) => IntroScreen(),
        "/login": (context) => Login(),
        "/register": (context) => Register(),
        "/restaurar": (context) => Restaurar(),
        "/perfil": (context) => Perfil(),
        "/principal": (context) => MainScreen(),
      },
    );
  }
}
