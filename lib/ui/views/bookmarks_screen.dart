import 'dart:async';

import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/ui/models/favorite_model.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class BookMarksScreen extends StatefulWidget {
  final List<FavoriteModel> favoritos;
  BookMarksScreen({super.key, required this.favoritos});

  @override
  State<BookMarksScreen> createState() => _BookMarksScreenState();
}

class _BookMarksScreenState extends State<BookMarksScreen> {
  ControlConectividad controlconect = ControlConectividad();
  bool _controllerconectivity = true;
  String id = '';
  List<FavoriteModel> favoritos = [];

  bool _isDarkMode = false;
  List<FavoriteModel> generateFavoritos() {
    return favoritos;
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

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    favoritos = widget.favoritos;
    print("favoritos: $favoritos");
    if (favoritos.isNotEmpty) {
      id = favoritos[0].id;
    }
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
    return favoritos.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                SizedBox(height: 16),
                Container(
                  height: 30,
                  color: MyColors.myPurple,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Productos favoritos',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                favoritos.isNotEmpty
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
                                        : Color.fromARGB(255, 250, 228, 231),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: DetailScreen(
                                                accesible: false,
                                                isFavorited: true,
                                                idUser: id,
                                                id: e.id,
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
                                                child: _controllerconectivity !=
                                                        false
                                                    ? Image.network(
                                                        e.imagen,
                                                        height: 89,
                                                        width: double.infinity,
                                                      )
                                                    : Center(
                                                        child: Image.asset(
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
                                                  fontWeight: FontWeight.bold,
                                                  color: _isDarkMode
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              e.color,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: _isDarkMode
                                                      ? Color.fromARGB(
                                                          255, 127, 5, 136)
                                                      : Colors.black),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${e.category}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
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
                                                SizedBox(width: 115),
                                                Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 24,
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
                            Text('No hay productos favoritos',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            SizedBox(height: 16),
                            Text('Agrega productos a favoritos',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('para verlos aquí',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('más tarde',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('👇',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Para hacerlo, solo debes',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('presionar el corazón',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                                Text(' en la parte superior',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Icon(
                                  Icons.arrow_upward,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ],
                        ),
                      )
              ],
            ),
          )
        : Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text('No hay productos favoritos',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 16),
                  Text('Agrega productos a favoritos',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('para verlos aquí',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('más tarde',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('👇',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('Para hacerlo, solo debes',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('presionar el corazón',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                      ),
                      Text(' en la parte superior',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Icon(
                        Icons.arrow_upward,
                        color: Colors.black,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
