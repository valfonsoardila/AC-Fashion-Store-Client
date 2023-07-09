import 'package:acfashion_store/domain/controller/controllerProductos.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/ui/home/dashboard_screen.dart';
import 'package:acfashion_store/ui/models/data.dart';
import 'package:acfashion_store/ui/models/my_colors.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
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
  String msg = "";
  var id = "";
  var foto = "";
  var correo = "";
  var contrasena = "";
  var nombre = "";
  var profesion = "";
  var direccion = "";
  var celular = "";
  //VARIABLES DE PRODUCTOS
  var idProducto = "";
  var cantidadProducto = 0;
  var fotoProducto = "";
  var nombreProducto = "";
  var descripcionProducto = "";
  var colorProducto = "";
  var tallaProducto = "";
  var categoriaProducto = "";
  var valoracionProducto = "";
  var precioProducto = 0.0;
  //LISTAS
  List<Map<String, dynamic>> consultaProductos = [];
  List<ProductModel> productos = [];
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
          return Container(
            color: Colors.white,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: MyColors.myPurple,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Cargando perfil...',
                  style: TextStyle(
                      color: MyColors.myPurple,
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
          );
        } else if (snapshot.hasError) {
          // Si ocurre un error al obtener el perfil, puedes mostrar un mensaje de error
          return Text('Error al obtener el perfil');
        } else {
          final datosPerfil =
              snapshot.data ?? {}; // Obtener los datos del perfil del snapshot
          // Asignar los valores a las variables correspondientes
          id = datosPerfil['id'] ?? "";
          correo = datosPerfil['correo'] ?? "";
          contrasena = datosPerfil['contrasena'] ?? "";
          nombre = datosPerfil['nombre'] ?? "";
          profesion = datosPerfil['profesion'] ?? "";
          direccion = datosPerfil['direccion'] ?? "";
          celular = datosPerfil['celular'] ?? "";
          foto = datosPerfil['foto'] ?? "";
          controlp.obtenerproductos();
          msg = controlp.mensajesProducto;
          if (msg == "Proceso exitoso") {
            productos = [];
            consultaProductos = controlp.datosProductos;
            // print("Esto trae la lista de productos: ${consultaProductos}");
            for (int i = 0; i < consultaProductos.length; i++) {
              idProducto = consultaProductos[i]['id'];
              cantidadProducto = consultaProductos[i]['cantidad'];
              fotoProducto = consultaProductos[i]['foto'];
              nombreProducto = consultaProductos[i]['nombre'];
              descripcionProducto = consultaProductos[i]['descripcion'];
              colorProducto = consultaProductos[i]['color'];
              tallaProducto = consultaProductos[i]['talla'];
              categoriaProducto = consultaProductos[i]['categoria'];
              valoracionProducto = consultaProductos[i]['valoracion'];
              precioProducto = consultaProductos[i]['precio'];
              var productModel = ProductModel(
                idProducto,
                fotoProducto,
                nombreProducto,
                categoriaProducto,
                descripcionProducto,
                precioProducto,
              );
              productos.add(productModel);
            }
          }
          // print("Esto trae la lista de productos: ${productos.length}");
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Stack(
                children: [
                  DashboardScreen(
                    id: id,
                    nombre: nombre,
                    correo: correo,
                    contrasena: contrasena,
                    foto: foto,
                    profesion: profesion,
                    direccion: direccion,
                    celular: celular,
                    productos: productos,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
