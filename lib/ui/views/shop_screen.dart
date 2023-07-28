import 'dart:async';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  final perfil;
  final String id;
  final compra;
  final itemCount;
  const ShopScreen({
    Key? key,
    required this.perfil,
    required this.id,
    this.compra,
    this.itemCount,
  }) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ControlConectividad controlconect = ControlConectividad();
  Timer? _timer;
  bool _controllerconectivity = true;
  String id = '';
  List<Map<String, dynamic>> compra = [];
  var count;

  bool _isDarkMode = false;

  int total() {
    int total = 0;
    double precio = 0;
    int nuevoPrecio = 0;
    for (var i = 0; i < compra.length; i++) {
      precio = double.parse(compra[i]['precio']);
      nuevoPrecio = precio.toInt() * 1000;
      total = total + nuevoPrecio;
    }
    return total;
  }

  void _initConnectivity() async {
    // Obtiene el estado de la conectividad al inicio
    bool connectivityResult = await controlconect.verificarConexion();
    _updateConnectionStatus();

    // Escucha los cambios en la conectividad y actualiza el estado en consecuencia
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      _updateConnectionStatus();
    });
  }

  void _updateConnectionStatus() {
    setState(() {
      _controllerconectivity = controlconect.conexion;
    });
  }

  void _cargardatos() {
    id = widget.id;
    compra = widget.compra;
    count = widget.itemCount;
    print("este es el perfil en ShopScreen: ${widget.perfil}");
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _cargardatos();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: _isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.shopping_cart,
                color: _isDarkMode ? Colors.white : Colors.black,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Mi carrito de compras',
                style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: _isDarkMode ? Colors.black : Colors.white,
        child: compra.isEmpty
            ? Center(
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No hay artículos seleccionados',
                          style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: _isDarkMode ? Colors.white : Colors.black,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Agrega artículos a tu carrito de compras',
                          style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'para poder comprarlos',
                          style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '¡Es muy fácil!',
                          style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '1. Selecciona el artículo que deseas comprar',
                          style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '2. Presiona el botón "Agregar al carrito"',
                              style: TextStyle(
                                  color:
                                      _isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                            Icon(
                              Icons.add_shopping_cart_outlined,
                              size: 30,
                              color: _isDarkMode ? Colors.white : Colors.black,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '3. ¡Listo! Ya puedes comprar tus artículos',
                          style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ]),
                ),
              )
            : Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        color: MyColors.myPurple,
                        alignment: Alignment.center,
                        child: Text(
                          'Artículos seleccionados',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      child: Expanded(
                    child: ListView.builder(
                      itemCount: compra.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                _isDarkMode ? Colors.grey[900] : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                alignment: Alignment.center,
                                child: Text('${index + 1}',
                                    style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors
                                            .grey, // Aquí puedes definir el color de fondo deseado
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: _controllerconectivity !=
                                              false
                                          ? BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    compra[index]['imagen']),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            )
                                          : BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/icons/ic_not_signal.png'),
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      compra[index]['titulo'],
                                      style: TextStyle(
                                          color: _isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      compra[index]['descripcion'],
                                      style: TextStyle(
                                          color: _isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '\$' + compra[index]['precio'].toString(),
                                      style: TextStyle(
                                          color: _isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: IconButton(
                                  hoverColor: Colors.red,
                                  splashRadius: 20,
                                  splashColor: Colors.red,
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      compra.removeAt(index);
                                      count = count - 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color:
                                        _isDarkMode ? Colors.red : Colors.black,
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    color: const Color.fromARGB(255, 96, 6, 102),
                    alignment: Alignment.center,
                    child: Text(
                      'Total de compra: \$' + total().toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 70,
                      color: MyColors.myPurple,
                      alignment: Alignment.center,
                      child: _controllerconectivity != false
                          ? ElevatedButton(
                              onPressed: () {
                                print("COMPRA EN SHOP: $compra");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentScreen(
                                            perfil: widget.perfil,
                                            compra: compra,
                                            total: total(),
                                          )),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Seleccionar método de pago',
                                      textAlign: TextAlign.center,
                                    ),
                                    Icon(
                                      Icons.monetization_on_outlined,
                                    )
                                  ],
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                            )
                          : Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/ic_not_signal.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'No hay conexión a internet',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                ],
              ),
      ),
    );
  }
}
