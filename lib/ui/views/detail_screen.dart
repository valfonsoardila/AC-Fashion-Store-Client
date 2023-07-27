import 'dart:async';

import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/domain/controller/controllerFavorito.dart';
import 'package:acfashion_store/domain/controller/controllerProducto.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final perfil;
  final bool accesible;
  final bool isFavorited;
  final String idUser;
  final String id;
  final int cantidad;
  final String image;
  final String title;
  final String color;
  final String talla;
  final String category;
  final String description;
  final String valoration;
  final String price;

  DetailScreen({
    Key? key,
    required this.perfil,
    required this.accesible,
    required this.isFavorited,
    required this.idUser,
    required this.id,
    required this.cantidad,
    required this.image,
    required this.title,
    required this.color,
    required this.talla,
    required this.category,
    required this.description,
    required this.valoration,
    required this.price,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DetailScreen> {
  ControlConectividad controlconect = ControlConectividad();
  ControlProducto controlp = new ControlProducto();
  ControlFavoritos controlf = new ControlFavoritos();
  List<Map<String, dynamic>> carrito = [];
  List<Map<String, dynamic>> nuevaconsultafavoritos = [];
  bool _controllerconectivity = true;
  bool _isFavorited = false;
  bool _isAccessible = false;
  bool autoRotate = false;
  String idUser = "";
  String msg = "";
  int rotationCount = 22;
  int swipeSensitivity = 2;
  bool allowSwipeToRotate = true;
  bool imagePrecached = true;
  List<ProductModel> productos = [];
  var itemCount;
  var idProducto = "";
  var cantidad = 0;
  var imagen = "";
  var titulo = "";
  var color = "";
  var talla = "";
  var categoria = "";
  var descripcion = "";
  var valoracion = "";
  var precio = "";

  bool _isDarkMode = false;
  void _initConnectivity() async {
    // Obtiene el estado de la conectividad al inicio
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    // Escucha los cambios en la conectividad y actualiza el estado en consecuencia
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      _updateConnectionStatus(connectivityResult);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    setState(() {
      _controllerconectivity = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _isFavorited = widget.isFavorited;
    idUser = widget.idUser;
    idProducto = widget.id;
    imagen = widget.image;
    titulo = widget.title;
    color = widget.color;
    talla = widget.talla;
    categoria = widget.category;
    descripcion = widget.description;
    valoracion = widget.valoration;
    precio = widget.price;
    cantidad = widget.cantidad;
    _isAccessible = widget.accesible;
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<ProductModel> colorCategories() {
    return productos;
  }

  List<Widget> buildColorWidgets() {
    return colorCategories()
        .map(
          (e) => Container(
            padding: EdgeInsets.only(left: 5, bottom: 10, top: 15),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: e.id == 1 ? MyColors.myPurple : Colors.white),
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset(
                  e.modelo,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: _isDarkMode ? Colors.white : MyColors.myBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          categoria,
          style: TextStyle(color: MyColors.myPurple),
        ),
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        iconTheme:
            IconThemeData(color: _isDarkMode ? MyColors.myBlack : Colors.white),
        elevation: 0,
        actions: [
          _isFavorited != false
              ? IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _isFavorited = !_isFavorited;
                      print("id del producto: $idProducto");
                      controlf.eliminarfavorito(idProducto).then((value) {
                        print("Eliminado");
                        setState(() {
                          msg = controlf.mensajesFavorio;
                          print(msg);
                        });
                        if (msg == "Proceso exitoso") {
                          controlf.obtenerfavoritos(idUser).then((value) {
                            setState(() {
                              msg = controlf.mensajesFavorio;
                            });
                            if (msg == "Proceso exitoso") {
                              setState(() {
                                nuevaconsultafavoritos =
                                    controlf.datosFavoritos;
                              });
                            }
                            Get.offAndToNamed("/principal", arguments: idUser);
                          });
                        }
                      });
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.favorite_border,
                      color: _isDarkMode ? Colors.white : Colors.black),
                  onPressed: () {
                    setState(() {
                      _isFavorited = !_isFavorited;
                      var favorito = {
                        "uid": idProducto,
                        "id": idUser,
                        "cantidad": cantidad,
                        "imagen": imagen,
                        "nombre": titulo,
                        "color": color,
                        "talla": talla,
                        "categoria": categoria,
                        "descripcion": descripcion,
                        "valoracion": valoracion,
                        "precio": precio,
                      };
                      controlf.agregarfavorito(favorito);
                      controlf.obtenerfavoritos(idUser).then((value) {
                        setState(() {
                          msg = controlf.mensajesFavorio;
                        });
                        if (msg == "Proceso exitoso") {
                          setState(() {
                            nuevaconsultafavoritos = controlf.datosFavoritos;
                          });
                          Get.offAndToNamed("/principal", arguments: idUser);
                        }
                      });
                    });
                  },
                ),
          // _isAccessible != false
          //     ? IconButton(
          //         icon: Icon(Icons.add_shopping_cart_outlined),
          //         splashColor: Colors.transparent,
          //         highlightColor: Colors.transparent,
          //         color: _isDarkMode ? Colors.white : Colors.black,
          //         onPressed: () async {
          //           if (cantidad >= 1) {
          //             carrito.add({
          //               "id": idProducto,
          //               "cantidad": cantidad,
          //               "imagen": imagen,
          //               "titulo": titulo,
          //               "color": color,
          //               "talla": talla,
          //               "categoria": categoria,
          //               "descripcion": descripcion,
          //               "valoracion": valoracion,
          //               "precio": precio,
          //             });
          //             final result = await Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => ShopScreen(
          //                           perfil: widget.perfil,
          //                           compra: carrito,
          //                           itemCount: 1,
          //                           id: idUser,
          //                         )));
          //             if (result != null) {
          //               setState(() {
          //                 itemCount = result;
          //               });
          //             }
          //           }
          //         },
          //       )
          //     : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: _isDarkMode ? Colors.grey[900] : Colors.white,
          child: Column(
            children: [
              Container(
                color: _isDarkMode ? Colors.black12 : Colors.white,
                height: size.width - 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          heightFactor: 1.4,
                          child: Container(
                            //height: size.width * 0.2,
                            height: size.height * 1.5,
                            width: size.width,
                            decoration: _isDarkMode
                                ? BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/pasarela.jpg"),
                                      fit: BoxFit.fill,
                                      alignment: Alignment.bottomCenter,
                                    ),
                                  )
                                : BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/pasarela3.jpg"),
                                      fit: BoxFit.fill,
                                      alignment: Alignment.bottomCenter,
                                    ),
                                  ),
                          ),
                        ),
                        Container(
                          height: size.width * 0.8,
                          width: size.width * 0.9,
                          margin: EdgeInsets.only(top: 35),
                          decoration: _controllerconectivity != false
                              ? BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(imagen),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                )
                              : BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/icons/ic_not_signal.png"),
                                    fit: BoxFit.contain,
                                    alignment: Alignment.center,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  width: size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: new BoxDecoration(
                      color: _isDarkMode
                          ? Color.fromARGB(255, 39, 39, 39)
                          : Color.fromARGB(255, 247, 246, 246),
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      )),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: titulo,
                              style: TextStyle(
                                  color:
                                      _isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: valoracion,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                    fontSize: 16.0,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: "(1125 Review)",
                                  style: TextStyle(
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                    fontSize: 16.0,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: descripcion,
                              style: TextStyle(
                                color:
                                    _isDarkMode ? Colors.white : Colors.black54,
                                fontSize: 16.0,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: "Selecciona el color :",
                              style: TextStyle(
                                color:
                                    _isDarkMode ? Colors.white : Colors.black54,
                                fontSize: 20.0,
                              )),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            color,
                            style: TextStyle(
                              color:
                                  _isDarkMode ? Colors.white : Colors.black54,
                              fontSize: 16.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDarkMode
                                ? Color.fromARGB(255, 39, 39, 39)
                                : Color.fromARGB(255, 247, 246, 246),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: "Selecciona la talla :",
                              style: TextStyle(
                                color:
                                    _isDarkMode ? Colors.white : Colors.black54,
                                fontSize: 20.0,
                              )),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            talla,
                            style: TextStyle(
                              color:
                                  _isDarkMode ? Colors.white : Colors.black54,
                              fontSize: 16.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isDarkMode
                                ? Color.fromARGB(255, 39, 39, 39)
                                : Color.fromARGB(255, 247, 246, 246),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        _isAccessible != false
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (cantidad >= 1) {
                                        carrito.add({
                                          "id": idProducto,
                                          "cantidad": cantidad,
                                          "imagen": imagen,
                                          "titulo": titulo,
                                          "color": color,
                                          "talla": talla,
                                          "categoria": categoria,
                                          "descripcion": descripcion,
                                          "valoracion": valoracion,
                                          "precio": precio,
                                        });
                                        final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShopScreen(
                                                      perfil: widget.perfil,
                                                      compra: carrito,
                                                      itemCount: 1,
                                                      id: idUser,
                                                    )));
                                        if (result != null) {
                                          setState(() {
                                            itemCount = result;
                                          });
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add_shopping_cart_outlined,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Agregar al carrito',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: MyColors.myPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: buildColorWidgets(),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
