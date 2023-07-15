import 'package:acfashion_store/ui/models/notification_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/models/assets_model.dart';
import 'package:acfashion_store/ui/views/bookmarks_screen.dart';
import 'package:acfashion_store/ui/views/home_screen.dart';
import 'package:acfashion_store/ui/views/purchases_screen.dart';
import 'package:acfashion_store/ui/views/settings_screen.dart';
import 'package:acfashion_store/ui/views/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:badges/badges.dart' as badges;

class DashboardScreen extends StatefulWidget {
  final String id;
  final String nombre;
  final String correo;
  final String contrasena;
  final String celular;
  final String direccion;
  final String foto;
  final String profesion;
  final List<ProductModel> productos;
  DashboardScreen({
    Key? key,
    required this.id,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    required this.celular,
    required this.direccion,
    required this.foto,
    required this.profesion,
    required this.productos,
  }) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _page = 0;
  RxInt itemCount = 0.obs;
  bool isSearchOpen = false; // Índice del icono seleccionado
  double tamano = 0.0;
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  String id = "";
  String nombrePerfil = 'Nombre de usuario';
  String correoPerfil = 'correo electrónico';
  String contrasenaPerfil = 'Contraseña';
  String telefonPerfil = 'Teléfono';
  String direccionPerfil = 'Dirección';
  String fotoPerfil = 'Foto de perfil';
  String profesionPerfil = 'Profesión';

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

  //Pendiente para cambiar esta funcion
  final List<String> bannerImages = [
    "assets/images/banners/img_banner1.png",
    "assets/images/banners/img_banner2.png",
    "assets/images/banners/img_banner3.png",
  ];
  int currentPage = 0;
  int cantidadProductosSeleccionados = 0;
  void obtenerCantidadProductosSeleccionados(
      int cantidadProductosSeleccionados) {
    // Asigna el valor de la cantidad de productos seleccionados a la variable
    this.cantidadProductosSeleccionados = cantidadProductosSeleccionados;
    setState(() {
      itemCount.value = cantidadProductosSeleccionados;
    });
  }

  void obtenerCarrito(List<Map<String, dynamic>> carrito) {
    this.carrito = carrito;
  }

  void cargarDatos() {
    id = widget.id;
    nombrePerfil = widget.nombre;
    correoPerfil = widget.correo;
    contrasenaPerfil = widget.contrasena;
    telefonPerfil = widget.celular;
    direccionPerfil = widget.direccion;
    fotoPerfil = widget.foto;
    profesionPerfil = widget.profesion;
    productos = widget.productos;
    productosAux = productos;
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

  void _mostrarNotificaciones() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Mis Notificaciones',
                style: TextStyle(color: Colors.black),
              ),
              content: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Lógica para guardar los cambios realizados en el perfil
                    Navigator.of(context).pop();
                  },
                  child: Text('Marcar como leidas',
                      style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Borrar', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  @override
  void dispose() {
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
    double displayWidth = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;

    final List<Widget> _widgetOptions = <Widget>[
      HomeScreen(
        productos: productos,
        onProductosSeleccionados: obtenerCantidadProductosSeleccionados,
        onCarrito: obtenerCarrito,
      ),
      BookMarksScreen(),
      PurchasesScreen(),
      SettingsScreen(),
    ];
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(isDrawerOpen ? 0.85 : 1.00)
        ..rotateZ(isDrawerOpen ? 0 : 0),
      // ..rotateZ(isDrawerOpen ? -50 : 0),
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius:
            isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: SizedBox(
            width: 20, // Ajusta el ancho según sea necesario
            child: isDrawerOpen
                ? GestureDetector(
                    child: CircleAvatarOpen(img: fotoPerfil, text: ''),
                    onTap: () {
                      setState(() {
                        xOffset = 0;
                        yOffset = 0;
                        isDrawerOpen = false;
                      });
                    },
                  )
                : GestureDetector(
                    child: CircleAvatarClose(img: fotoPerfil, text: ''),
                    onTap: () {
                      setState(() {
                        FocusScope.of(context).unfocus(); // Cierra el teclado
                        xOffset = 290;
                        yOffset = 80;
                        isDrawerOpen = true;
                      });
                    },
                  ),
          ),
          //IconButton(
          //     icon: CircleAvatar(
          //       backgroundImage: fotoPerfil != ""
          //           ? NetworkImage(fotoPerfil)
          //           : NetworkImage(
          //               "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
          //       radius: 18,
          //     ),
          //     onPressed: () {
          //       setState(() {
          //         FocusScope.of(context).unfocus(); // Cierra el teclado
          //         xOffset = 290;
          //         yOffset = 80;
          //         isDrawerOpen = true;
          //       });
          //     }
          //() => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => DrawerScreen(
          //               uid: id,
          //               nombre: nombrePerfil,
          //               correo: correoPerfil,
          //               // contrasena: contrasenaPerfil,
          //               celular: telefonPerfil,
          //               direccion: direccionPerfil,
          //               catalogo: fotoPerfil,
          //               profesion: profesionPerfil,
          //             ))),
          // builder: (context) => Aside(
          //       id: id,
          //       nombre: nombrePerfil,
          //       correo: correoPerfil,
          //       contrasena: contrasenaPerfil,
          //       telefono: telefonPerfil,
          //       direccion: direccionPerfil,
          //       catalogo: fotoPerfil,
          //       profesion: profesionPerfil,
          //     ))),
          //),
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: isSearchOpen != true
              ? Container()
              : Row(children: [
                  SizedBox(
                    width: size.width * 0.12,
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Buscar",
                        suffix: IconButton(
                          hoverColor: Colors.white,
                          splashColor: Colors.white,
                          alignment: Alignment.centerRight,
                          iconSize: 20,
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isSearchOpen = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ]),
          actions: [
            isSearchOpen != false
                ? Container()
                : Row(
                    children: [
                      badges.Badge(
                        badgeContent: Text(
                          '3',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.notifications_none,
                              color: Colors.black),
                          onPressed: () {
                            _mostrarNotificaciones();
                          },
                        ),
                      ),
                      itemCount > 0
                          ? badges.Badge(
                              badgeContent: Obx(
                                () => Text(
                                  itemCount.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.shopping_cart_outlined,
                                    color: Colors.black),
                                onPressed: () async {
                                  print('itemCount: ${itemCount.value}');
                                  final result = await Navigator.push<int>(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShopScreen(
                                        compra: carrito,
                                        itemCount: itemCount,
                                      ),
                                    ),
                                  );
                                  if (result != null) {
                                    setState(() {
                                      itemCount.value = result;
                                    });
                                  }
                                },
                              ),
                            )
                          : IconButton(
                              onPressed: () async {
                                final result = await Navigator.push<int>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopScreen(
                                      compra: carrito,
                                      itemCount: itemCount,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  setState(() {
                                    itemCount.value = result;
                                  });
                                }
                              },
                              icon: Icon(Icons.shopping_cart_outlined,
                                  color: Colors.black)),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isSearchOpen = true;
                            });
                          },
                          icon: Icon(Icons.search, color: Colors.black)),
                    ],
                  ),
          ],
        ),
        body: Container(
          child: Center(
            child: _widgetOptions[_page],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(displayWidth * .05),
          height: displayWidth * .155,
          decoration: BoxDecoration(
            color: Color.fromRGBO(247, 232, 253, 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.1),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                setState(() {
                  _page = index;
                  //HapticFeedback.lightImpact();
                });
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == _page
                        ? displayWidth * .32
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == _page ? displayWidth * .12 : 0,
                      width: index == _page ? displayWidth * .32 : 0,
                      decoration: BoxDecoration(
                        color: index == _page
                            ? MyColors.myPurple
                            : Colors.black.withOpacity(.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == _page
                        ? displayWidth * .31
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == _page ? displayWidth * .13 : 0,
                            ),
                            AnimatedOpacity(
                              opacity: index == _page ? 1 : 0,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Text(
                                index == _page ? '${listOfStrings[index]}' : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: index == _page ? displayWidth * .03 : 20,
                            ),
                            Icon(
                              listOfIcons[index],
                              size: displayWidth * .076,
                              color: index == _page
                                  ? Colors.white
                                  : Colors.black26,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.shopping_bag_rounded,
    Icons.settings_rounded,
  ];

  List<String> listOfStrings = [
    'Inicio',
    'Favoritos',
    'Almacen',
    'Ajustes',
  ];
}

class CircleAvatarOpen extends StatelessWidget {
  final dynamic img;
  final String text;

  CircleAvatarOpen({
    Key? key,
    required this.text,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (img != null && Uri.parse(img).isAbsolute) {
      // Si img es una URL válida, carga la imagen desde la URL
      imageWidget = CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(img),
        child: Container(
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      );
    } else {
      // Si img no es una URL válida, carga la imagen desde el recurso local
      imageWidget = CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('assets/images/user.png'),
        child: Container(
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(child: imageWidget),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}

//Clase para el avatar del panel superior de la aplicacion
class CircleAvatarClose extends StatelessWidget {
  final dynamic img;
  final String text;

  CircleAvatarClose({
    Key? key,
    required this.text,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (img != null && Uri.parse(img).isAbsolute) {
      // Si img es una URL válida, carga la imagen desde la URL
      imageWidget = CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(img),
      );
    } else {
      // Si img no es una URL válida, carga la imagen desde el recurso local
      imageWidget = CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage('assets/images/user.png'),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(child: imageWidget),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
