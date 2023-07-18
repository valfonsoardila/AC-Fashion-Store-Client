import 'dart:async';

import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/ui/models/assets_model.dart';
import 'package:acfashion_store/ui/models/favorite_model.dart';
import 'package:acfashion_store/ui/models/notification_model.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  final List<FavoriteModel> favoritos;
  final List<ProductModel> productos;
  final String id;
  final Function(int) onProductosSeleccionados;
  final Function(List<Map<String, dynamic>>) onCarrito;
  const HomeScreen({
    super.key,
    required this.favoritos,
    required this.productos,
    required this.id,
    required this.onProductosSeleccionados,
    required this.onCarrito,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ControlConectividad controlconect = ControlConectividad();
  bool _controllerconectivity = true;
  Timer? _timer;
  String id = "";
  bool _isFavorite = false;
  RxInt itemCount = 0.obs;
  String idProducto = "";
  int cantidadProducto = 0;
  String fotoProducto = "";
  String nombreProducto = "";
  String descripcionProducto = "";
  String colorProducto = "";
  String tallaProducto = "";
  String categoriaProducto = "";
  String valoracionProducto = "";
  String precioProducto = "";
  List<FavoriteModel> favoritos = [];
  List<Map<String, dynamic>> carrito = [];
  List<ProductModel> productos = [];
  List<ProductModel> productosAux = [];
  List<ProductModel> categories = [];
  List<ProductModel> colors = [];
  List<NotificationModel> notifications = [];

  List<ProductModel> generateProducts() {
    return productos;
  }

  List<NotificationModel> notificationsList() {
    return notifications;
  }

  void seleccionarProductos(
    dynamic cantidad,
    List<Map<String, dynamic>> carrito,
  ) {
    setState(() {
      itemCount.value = cantidad;
      print("itemCount desde el home secren: " + itemCount.value.toString());
    });
    widget.onProductosSeleccionados(itemCount.value);
    widget.onCarrito(carrito);
  }

  //Pendiente para cambiar esta funcion
  final List<String> bannerImages = [
    "assets/images/banners/img_banner1.png",
    "assets/images/banners/img_banner2.png",
    "assets/images/banners/img_banner3.png",
  ];
  int currentPage = 0;

  void cargarDatos() {
    id = widget.id;
    productos = widget.productos;
    productosAux = productos;
    favoritos = widget.favoritos;
  }

  void obteneridfavorito(String id) {
    for (var i = 0; i < favoritos.length; i++) {
      if (favoritos[i].uid == id) {
        print("id del favorito: ${favoritos[i].uid} es igual a $id");
        _isFavorite = true;
      } else {
        _isFavorite = false;
      }
    }
  }

  void seleccionarCategoria(categoria) {
    categories = [];
    productos = productosAux;
    if (categoria != "Todos") {
      for (var i = 0; i < productos.length; i++) {
        if (productos[i].category == categoria) {
          categories.add(productos[i]);
        }
      }
      productos = [];
      productos = categories;
    } else {
      productos = productosAux;
    }
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
    cargarDatos();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String selectedCategoryId = "0"; // ID de la categoría seleccionada
  List<Widget> buildCategories() {
    return AssetsModel.generateCategories().map((e) {
      bool isSelected = selectedCategoryId == e.id;
      return Container(
        padding: EdgeInsets.only(left: 15, bottom: 10),
        child: ElevatedButton(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: MyColors.grayBackground,
                  child: e.modelo.isNotEmpty
                      ? Image.asset(
                          e.modelo,
                          height: 45,
                          width: 45,
                        )
                      : Container(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                e.category,
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.white : Colors.black38,
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              isSelected ? MyColors.myPurple : Colors.white,
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          onPressed: () {
            setState(() {
              selectedCategoryId = e.id;
              seleccionarCategoria(e.category);
            });
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: size.width,
                      height: 200,
                      child: Stack(
                        children: [
                          PageView.builder(
                            itemCount: bannerImages.length,
                            onPageChanged: (index) {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(bannerImages[index]),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: 18, left: 18, top: 10, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          text: "Nuevo lanzamiento",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      RichText(
                                        textAlign: TextAlign.start,
                                        text: TextSpan(
                                          text: "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 28),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 62,
                                      ),
                                      ElevatedButton(
                                          child: Text(
                                              "  Comprar Ahora  ".toUpperCase(),
                                              style: TextStyle(fontSize: 12)),
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<Color>(
                                                      MyColors.myBlack),
                                              backgroundColor:
                                                  MaterialStateProperty.all<Color>(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(30)))),
                                          onPressed: () {}),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List<Widget>.generate(
                                    bannerImages.length, (index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: currentPage == index
                                            ? Colors.white
                                            : Colors.grey,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: buildCategories(),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  text: "Nuevos diseños",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GridView.count(
            childAspectRatio: 0.5,
            crossAxisCount: 2,
            padding: EdgeInsets.all(5.0),
            children: generateProducts()
                .map(
                  (e) => Card(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    elevation: 0,
                    child: InkWell(
                      onTap: () async {
                        obteneridfavorito(e.id);
                        final result = await Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                child: DetailScreen(
                                  isFavorited: _isFavorite,
                                  idUser: id,
                                  id: e.id,
                                  cantidad: e.cantidad,
                                  image: e.modelo,
                                  title: e.title,
                                  color: e.color,
                                  talla: e.talla,
                                  category: e.category,
                                  description: e.description,
                                  valoration: e.valoration,
                                  price: e.price,
                                )));
                        if (result != null) {
                          setState(() {
                            itemCount.value = result;
                            print(itemCount.value);
                            //seleccionarProductos(itemCount.value, );
                          });
                        }
                      },
                      child: Container(
                        height: 250,
                        width: 250,
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FutureBuilder<bool>(
                                  future: controlconect.verificarConexion(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      print("Cargando");
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      if (snapshot.hasError) {
                                        print("Error");
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        print("Conectado");
                                        return _controllerconectivity != false
                                            ? Image.network(
                                                e.catalogo,
                                                height: 250,
                                                width: double.infinity,
                                              )
                                            : Center(
                                                child: Image.asset(
                                                  "assets/icons/ic_not_signal.png",
                                                  height: 50,
                                                  width: 50,
                                                ),
                                              );
                                      }
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: e.category,
                                      style: TextStyle(
                                          color: MyColors.myPurple,
                                          fontSize: 16.0)),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
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
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: e.title,
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18.0)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: "\$ ${e.price}",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Spacer(),
                                ElevatedButton(
                                    child: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black87),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30)))),
                                    onPressed: () {
                                      if (e.cantidad > itemCount.value) {
                                        itemCount.value++;
                                        carrito.add({
                                          "id": e.id,
                                          "cantidad": e.cantidad,
                                          "imagen": e.modelo,
                                          "titulo": e.title,
                                          "color": e.color,
                                          "talla": e.talla,
                                          "categoria": e.category,
                                          "descripcion": e.description,
                                          "valoracion": e.valoration,
                                          "precio": e.price,
                                        });
                                        print(carrito);
                                        print(itemCount.value);
                                        seleccionarProductos(
                                            itemCount.value, carrito);
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          setState(
                                              () {}); // Actualizar inmediatamente después de cambiar el valor
                                        });
                                      }
                                    })
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
          )
        ],
      ),
    );
  }
}
