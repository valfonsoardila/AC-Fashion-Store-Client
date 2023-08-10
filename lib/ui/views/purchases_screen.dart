import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/ui/models/favorite_model.dart';
import 'package:acfashion_store/ui/models/purchases_model.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PurchasesScreen extends StatefulWidget {
  final perfil;
  final List<PurchasesModel> compras;
  PurchasesScreen({super.key, this.perfil, required this.compras});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  ControlConectividad controlconect = ControlConectividad();
  bool _controllerconectivity = true;
  String id = '';
  int dinero = 0;
  List<PurchasesModel> compras = [];

  bool _isDarkMode = false;
  List<PurchasesModel> generateFavoritos() {
    return compras;
  }

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

  void sumarDinero() {
    for (var i = 0; i < compras.length; i++) {
      double formato = compras[i].price.toDouble();
      int dineroPorProducto = (formato * 1000).toInt();
      dinero = dinero + dineroPorProducto;
    }
    print("dinero: $dinero");
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    compras = widget.compras;
    print("Compras: $compras");
    if (compras.isNotEmpty) {
      id = compras[0].uid;
    }
    sumarDinero();
  }

  @override
  void dispose() {
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
    return compras.isNotEmpty
        ? Scaffold(
            body: SingleChildScrollView(
              child: Container(
                color: _isDarkMode ? Colors.black : Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            color: MyColors.myPurple,
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Compras realizadas',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                color: _isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.black,
                                width: 200,
                                height: 30,
                                child: Text('Inv: \$' + '${dinero}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    compras.isNotEmpty
                        ? Container(
                            child: GridView.count(
                              childAspectRatio: 0.6,
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(5.0),
                              children: generateFavoritos()
                                  .map(
                                    (e) => Card(
                                        color: _isDarkMode
                                            ? Colors.grey.shade800
                                            : Color.fromARGB(
                                                255, 250, 228, 231),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        elevation: 0,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType.fade,
                                                  child: DetailScreen(
                                                    perfil: widget.perfil,
                                                    accesible: false,
                                                    isFavorited: true,
                                                    idUser: id,
                                                    id: e.uid,
                                                    cantidad: e.cantidad,
                                                    image: e.imagen,
                                                    title: e.nombre,
                                                    color: e.color,
                                                    talla: e.talla,
                                                    category: e.category,
                                                    description: e.description,
                                                    valoration: e.valoration,
                                                    price: e.price,
                                                  )),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 250,
                                                    child:
                                                        _controllerconectivity !=
                                                                false
                                                            ? CachedNetworkImage(
                                                                progressIndicatorBuilder:
                                                                    (context,
                                                                            url,
                                                                            downloadProgress) =>
                                                                        Center(
                                                                  child: CircularProgressIndicator(
                                                                      value: downloadProgress
                                                                          .progress),
                                                                ),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                                imageUrl:
                                                                    e.imagen,
                                                              )
                                                            : Center(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/icons/ic_not_signal.png",
                                                                  height: 50,
                                                                  width: 50,
                                                                ),
                                                              ),
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  e.nombre,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _isDarkMode
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  e.color,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _isDarkMode
                                                          ? Colors.yellow
                                                          : Colors.black),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  '${e.category}',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: _isDarkMode
                                                          ? Colors.white
                                                          : MyColors.myPurple),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow[700],
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(
                                                      e.valoration.toString(),
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: _isDarkMode
                                                              ? Colors.white
                                                              : Colors.black),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        )),
                                  )
                                  .toList(),
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                            ),
                          )
                        : Container(
                            child: Column(
                              children: [
                                SizedBox(height: 16),
                                Text('No ha comprado nada aún',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                SizedBox(height: 16),
                                Text('¡No te preocupes!',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                Text('Puedes hacerlo',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                Text('ahora o puedes hacerlo',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                Text('más tarde',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                Text('para hacerlo solo debes',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('presionar el icono de',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _isDarkMode
                                                ? Colors.white
                                                : Colors.black)),
                                    Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: _isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    Text('en el producto que desees',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _isDarkMode
                                                ? Colors.white
                                                : Colors.black)),
                                  ],
                                ),
                                Text('comprar y ¡listo!',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ),
          )
        : Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text('No ha comprado nada aún',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black)),
                  SizedBox(height: 16),
                  Text('¡No te preocupes!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black)),
                  Text('Puedes hacerlo',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black)),
                  Text('ahora o puedes hacerlo',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black)),
                  Text('más tarde',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black)),
                  Text('para hacerlo solo debes',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('presionar el icono de',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  _isDarkMode ? Colors.white : Colors.black)),
                      Icon(
                        Icons.add_shopping_cart_outlined,
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                      Text('en el producto que desees',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  _isDarkMode ? Colors.white : Colors.black)),
                    ],
                  ),
                  Text('comprar y ¡listo!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
            ),
          );
  }
}
