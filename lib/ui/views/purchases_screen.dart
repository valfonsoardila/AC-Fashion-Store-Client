import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/ui/models/favorite_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class PurchasesScreen extends StatefulWidget {
  final List<FavoriteModel> favoritos;
  PurchasesScreen({super.key, required this.favoritos});

  @override
  State<PurchasesScreen> createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends State<PurchasesScreen> {
  ControlConectividad controlconect = ControlConectividad();
  bool _controllerconectivity = true;
  String id = '';
  List<FavoriteModel> favoritos = [];
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
    return favoritos.isNotEmpty
        ? Container(
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
                            color: Colors.black,
                            width: 200,
                            height: 30,
                            child: Text('Inversiones: \$ 0.00',
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
                favoritos.isNotEmpty
                    ? Container(
                        child: GridView.count(
                          childAspectRatio: 0.6,
                          crossAxisCount: 2,
                          padding: EdgeInsets.all(5.0),
                          children: generateFavoritos()
                              .map(
                                (e) => Card(
                                    color: Color.fromARGB(255, 247, 243, 243),
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
                                              CrossAxisAlignment.start,
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
                                                  color: Colors.black),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              e.color,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${e.category}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
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
                                                      color: Colors.black),
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
                                    color: Colors.black)),
                            SizedBox(height: 16),
                            Text('¡No te preocupes!',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('Puedes hacerlo',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('ahora o puedes hacerlo',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('más tarde',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Text('para hacerlo solo debes',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('presionar el icono de',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Icon(
                                  Icons.add_shopping_cart_outlined,
                                  color: Colors.black,
                                ),
                                Text('en el producto que desees comprar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text('Y ¡listo!')
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
                  Text('No ha realizado ninguna compra',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 16),
                  Text('¡No te preocupes!',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('Haz una compra de algún producto',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text('En la app store',
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
                      Text('presionar el carrito de compras',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      Icon(
                        Icons.add_shopping_cart,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  Text('del catalogo del producto',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  Text(
                    'Y ¡listo!',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          );
  }
}
