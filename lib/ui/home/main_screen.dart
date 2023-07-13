import 'package:acfashion_store/domain/controller/controllerProductos.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/ui/auth/login_screen.dart';
import 'package:acfashion_store/ui/home/dashboard_screen.dart';
import 'package:acfashion_store/ui/home/drawer_screen.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //CONTROLADORES
  ControlUserAuth controlua = Get.find();
  ControlUserPerfil controlup = Get.put(ControlUserPerfil());
  ControlProducto controlp = Get.put(ControlProducto());
  //VARIABLES DE CONTROL
  String idUsuario = '';
  String? uid;
  String msg = "";
  int tiempoDeintento = 5;
  //VARIABLES DE PERFIL
  var id = "";
  var foto = "";
  var correo = "";
  var contrasena = "";
  var nombre = "";
  var profesion = "";
  var direccion = "";
  var celular = "";
  //VARIABLES PRODUCTOS
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
  //MAPAS
  Map<String, dynamic> perfil = {};

  @override
  void initState() {
    super.initState();
    //Se consulta el uid del perfil autenticado
    controlua.consultarUser().then((value) {
      setState(() {
        uid = controlua.uidValido;
        idUsuario = uid!;
      });
      cargarDatos();
    });
  }

  void cargarDatos() {
    //Se obtienen datos de perfil autenticado
    controlup.obtenerperfil(idUsuario).then((value) {
      setState(() {
        msg = controlup.mensajesPerfil;
      });
      if (msg == "Proceso exitoso") {
        setState(() {
          perfil = controlup.datosPerfil;
          id = perfil['id'] ?? '';
          foto = perfil['foto'] ?? '';
          correo = perfil['correo'] ?? '';
          contrasena = perfil['contrasena'] ?? '';
          nombre = perfil['nombre'] ?? '';
          profesion = perfil['profesion'] ?? '';
          direccion = perfil['direccion'] ?? '';
          celular = perfil['celular'] ?? '';
          print("Datos perfil recibidos en MainScreen: $perfil");
        });
      } else {
        print("Error al cargar datos del perfil");
      }
    });
    //Se obtienen datos de productos
    controlp.obtenerproductos().then((value) {
      setState(() {
        msg = controlp.mensajesProducto;
      });
      if (msg == "Proceso exitoso") {
        setState(() {
          consultaProductos = controlp.datosProductos;
          print(
              "Datos de productos recibidos en MainScreen: $consultaProductos");
          for (var i = 0; i < consultaProductos.length; i++) {
            idProducto = consultaProductos[i]['id'] ?? '';
            cantidadProducto = consultaProductos[i]['cantidad'] ?? 0;
            fotoProducto = consultaProductos[i]['foto'] ?? '';
            nombreProducto = consultaProductos[i]['nombre'] ?? '';
            descripcionProducto = consultaProductos[i]['descripcion'] ?? '';
            colorProducto = consultaProductos[i]['color'] ?? '';
            tallaProducto = consultaProductos[i]['talla'] ?? '';
            categoriaProducto = consultaProductos[i]['categoria'] ?? '';
            valoracionProducto = consultaProductos[i]['valoracion'] ?? '';
            precioProducto = consultaProductos[i]['precio'] ?? 0.0;
            productos.add(ProductModel(
              idProducto,
              fotoProducto,
              nombreProducto,
              colorProducto,
              tallaProducto,
              categoriaProducto,
              descripcionProducto,
              precioProducto,
            ));
          }
        });
      } else {
        print("Error al cargar datos de productos");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: FutureBuilder(
            future: Future.delayed(
                Duration(seconds: 6)), //Establece el tiempo de carga
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: MyColors.myPurple,
                      backgroundColor: Colors.purple[400],
                    ),
                    Text(
                      "Cargando...",
                      style: TextStyle(
                        color: MyColors.myPurple,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                );
              } else {
                if (productos.isNotEmpty && perfil.isNotEmpty) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: Scaffold(
                      body: Stack(
                        children: [
                          DrawerScreen(
                            uid: id,
                            nombre: nombre,
                            correo: correo,
                            contrasena: contrasena,
                            celular: celular,
                            direccion: direccion,
                            foto: foto,
                            profesion: profesion,
                          ),
                          //MainScreen(uid: uid, foto: foto), //Pantalla principal
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
                  // return DashboardScreen(
                  //           id: id,
                  //           nombre: nombre,
                  //           correo: correo,
                  //           contrasena: contrasena,
                  //           foto: foto,
                  //           profesion: profesion,
                  //           direccion: direccion,
                  //           celular: celular,
                  //           productos: productos,
                  //         ),
                } else {
                  if (snapshot.hasError) {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.network_check,
                                color: Colors.red,
                              ),
                              Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          Text(
                            "Error: ${snapshot.error}",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Verifique su conexión a internet",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            color: Colors.black,
                            backgroundColor: MyColors.myBlack,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.offAll(() => MainScreen());
                            },
                            child: Text(
                              "Intentar de nuevo",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.help_outline,
                            color: Colors.red,
                          ),
                          Text(
                            "Error desconocido",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          Text(
                            "Por favor vuelva a ingresar",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.offAllNamed("/login");
                            },
                            child: Text(
                              "Volver",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
