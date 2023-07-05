import 'package:acfashion_store/domain/controller/controllerProductos.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/ui/home/dashboard_screen.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//CLASE PRINCIPAL
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //CONTROLADORES
  ControlUserAuth controlua = Get.find();
  ControlUserPerfil controlup = Get.put(ControlUserPerfil());
  ControlProducto controlp = Get.put(ControlProducto());
  //VARIABLES DE PERFIL
  String? uid = ''; // Variable local para almacenar el ID del usuario
  var foto = "";
  var correo = "";
  var nombre = "";
  var profesion = "";
  var direccion = "";
  var celular = "";
  //VARIABLES DE PRODUCTOS
  var idProducto = "";
  var cantidadProducto = "";
  var fotoProducto = "";
  var nombreProducto = "";
  var descripcionProducto = "";
  var colorProducto = "";
  var tallaProducto = "";
  var categoriaProducto = "";
  var valoracionProducto = "";
  var precioProducto = "";
  //LISTAS
  List<Map<String, dynamic>> datosProductos = [];
  //FUNCIONES
  @override
  void initState() {
    super.initState();
    controlua.consultarUser().then((value) {
      setState(() {
        uid = controlua.userValido?.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: controlup.obtenerperfil(uid!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras se carga el perfil, puedes mostrar un indicador de carga, por ejemplo:
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.myPurple,
            ),
          );
        } else if (snapshot.hasError) {
          // Si ocurre un error al obtener el perfil, puedes mostrar un mensaje de error
          return Text('Error al obtener el perfil');
        } else {
          final datosPerfil =
              snapshot.data ?? {}; // Obtener los datos del perfil del snapshot
          // Asignar los valores a las variables correspondientes
          correo = datosPerfil['correo'] ?? "";
          nombre = datosPerfil['nombre'] ?? "";
          profesion = datosPerfil['profesion'] ?? "";
          direccion = datosPerfil['direccion'] ?? "";
          celular = datosPerfil['celular'] ?? "";
          foto = datosPerfil['foto'] ?? "";
          controlp.obtenerproductos();
          final datosProductos = snapshot.data ?? {};
          idProducto = datosProductos['id'] ?? "";
          cantidadProducto = datosProductos['cantidad'] ?? "";
          fotoProducto = datosProductos['foto'] ?? "";
          nombreProducto = datosProductos['nombre'] ?? "";
          descripcionProducto = datosProductos['descripcion'] ?? "";
          colorProducto = datosProductos['color'] ?? "";
          tallaProducto = datosProductos['talla'] ?? "";
          categoriaProducto = datosProductos['categoria'] ?? "";
          valoracionProducto = datosProductos['valoracion'] ?? "";
          precioProducto = datosProductos['precio'] ?? "";
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Stack(
                children: [
                  DashboardScreen(
                      nombre: nombre,
                      correo: correo,
                      foto: foto,
                      profesion: profesion,
                      direccion: direccion,
                      celular: celular),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
