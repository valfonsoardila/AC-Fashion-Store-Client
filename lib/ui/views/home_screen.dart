import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/ui/models/assets_model.dart';
import 'package:acfashion_store/ui/models/favorite_model.dart';
import 'package:acfashion_store/ui/models/notification_model.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  final perfil;
  final compra;
  final favoritos;
  final productos;
  final id;
  final onProductosSeleccionados;
  final onCarrito;
  final onFavoritesProducts;
  const HomeScreen({
    super.key,
    this.perfil,
    this.compra,
    this.onFavoritesProducts,
    this.favoritos,
    this.productos,
    this.id,
    this.onProductosSeleccionados,
    this.onCarrito,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ControlConectividad controlconect = ControlConectividad();
  final PageController _pageController = PageController();
  bool _controllerconectivity = true;
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

  bool _isDarkMode = false;

  List<ProductModel> generateProducts() {
    return productos;
  }

  List<FavoriteModel> favoritosAux = [];
  List<NotificationModel> notificationsList() {
    return notifications;
  }

  //callbaks de favoritos
  void gestionFavoritos(List<FavoriteModel> favoritosobtenidos) {
    print("favoritos que se enviaran al dash: $favoritosobtenidos");
    widget.onFavoritesProducts(favoritosobtenidos);
  }

  void obtenerNuevaListaFavoritos(
    List<FavoriteModel> favoritosobtenidos,
  ) {
    // Asigna el valor de la cantidad de productos seleccionados a la variable
    this.favoritosAux = favoritosobtenidos;
    setState(() {
      if (favoritosAux.length > 0) {
        _isFavorite = true;
        favoritos.add(favoritosAux[0]);
      } else {
        _isFavorite = false;
        favoritos = [];
      }
    });
    gestionFavoritos(favoritos);
    print("Nueva lista de favoritos: $favoritos");
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
    print("perfil desde el home screen: ${widget.perfil}");
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
    super.dispose();
  }

  String selectedCategoryId = "0"; // ID de la categoría seleccionada
  List<Widget> buildCategories() {
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
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
                  color: _isDarkMode
                      ? Colors.grey.shade600
                      : MyColors.grayBackground,
                  child: e.modelo.isNotEmpty
                      ? Image.asset(
                          e.modelo,
                          height: 55,
                          width: 55,
                        )
                      : Container(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                e.category,
                style: TextStyle(
                    fontSize: 14,
                    color: _isDarkMode
                        ? Colors.white
                        : isSelected
                            ? Colors.white
                            : Colors.black38),
              ),
            ],
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              isSelected ? Colors.white : Colors.black38,
            ),
            backgroundColor: MaterialStateProperty.all<Color>(
              isSelected
                  ? MyColors.myPurple
                  : _isDarkMode
                      ? Colors.grey.shade900
                      : Colors.white,
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
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      body: Container(
        color: _isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 15,
                  top: 10), //paddin de los banners
              child: Stack(
                children: [
                  //banners de la pantalla principal
                  SingleChildScrollView(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: size.width,
                        height: 200,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onHorizontalDragUpdate: (details) {
                                if (details.delta.dx > 0) {
                                  // Deslizamiento hacia la derecha, cambiar a la página anterior
                                  _pageController.previousPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.ease);
                                } else if (details.delta.dx < 0) {
                                  // Deslizamiento hacia la izquierda, cambiar a la página siguiente
                                  _pageController.nextPage(
                                      duration: Duration(milliseconds: 400),
                                      curve: Curves.ease);
                                }
                              },
                              child: PageView(
                                controller: _pageController,
                                onPageChanged: (value) {
                                  setState(() {
                                    currentPage = value;
                                  });
                                },
                                children: List.generate(
                                  bannerImages.length,
                                  (index) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          bannerImages[index],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
              //categorias de la pantalla principal
              child: Container(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: buildCategories(),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //label de los nuevos diseños
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 30,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color:
                      _isDarkMode ? MyColors.myPurple : MyColors.grayBackground,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 5.0),
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                        text: "Nuevos diseños",
                        style: TextStyle(
                            color:
                                _isDarkMode ? Colors.white : MyColors.myPurple,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            //productos de la pantalla principal
            GridView.count(
              childAspectRatio: 0.6,
              crossAxisCount: 2,
              padding: EdgeInsets.all(5.0),
              children: generateProducts()
                  .map(
                    (e) => Card(
                      borderOnForeground: false,
                      color: _isDarkMode
                          ? Colors.grey.shade800
                          : Color.fromARGB(255, 250, 228, 231),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 0,
                      child: InkWell(
                        onTap: () async {
                          if (favoritos.length > 0) {
                            obteneridfavorito(e.id);
                          }
                          final result = await Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: DetailScreen(
                                    perfil: widget.perfil,
                                    accesible: true,
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
                                    onFavoritesProducts:
                                        obtenerNuevaListaFavoritos,
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
                          margin: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _controllerconectivity != false
                                    ? //Image del catalogo del producto
                                    CachedNetworkImage(
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Center(
                                          child: CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                        imageUrl: e.catalogo,
                                      )
                                    : //Image de verificacion de conexion
                                    Center(
                                        child: Image.asset(
                                          "assets/icons/ic_not_signal.png",
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              //label de la categoria y valoracion del producto
                              Row(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: e.category,
                                        style: TextStyle(
                                            color: _isDarkMode
                                                ? Colors.yellow
                                                : MyColors.myPurple,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow[700],
                                    size: 18,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    e.valoration.toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black87),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //label del titulo del producto
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: e.title,
                                    style: TextStyle(
                                        color: _isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 18.0)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //label de la descripcion del producto
                              Row(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: "\$ ${e.price}",
                                        style: TextStyle(
                                            color: _isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Spacer(),
                                  //boton de agregar al carrito
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
                                            "uid": '',
                                            "iduser": id,
                                            "idproducto": e.id,
                                            "cantidad": itemCount.value,
                                            "imagen": e.modelo,
                                            "titulo": e.title,
                                            "color": e.color,
                                            "talla": e.talla,
                                            "categoria": e.category,
                                            "descripcion": e.description,
                                            "valoracion": e.valoration,
                                            "precio": e.price,
                                          });
                                          print(
                                              "CARRITO DESDE EL HOME: $carrito");
                                          print(itemCount.value);
                                          seleccionarProductos(
                                              itemCount.value, carrito);
                                          // WidgetsBinding.instance!
                                          //     .addPostFrameCallback((_) {
                                          //   setState(
                                          //       () {}); // Actualizar inmediatamente después de cambiar el valor
                                          // });
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
      ),
    );
  }
}
