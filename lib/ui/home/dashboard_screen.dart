import 'package:acfashion_store/ui/models/notification_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:acfashion_store/ui/models/data.dart';
import 'package:acfashion_store/ui/views/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
  var currentIndex = 0;
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

  void cargarDatos() {
    print("Cargando datos");
    print("Productos: " + widget.productos.toString());
    productos = widget.productos;
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
    id = widget.id;
    nombrePerfil = widget.nombre;
    correoPerfil = widget.correo;
    contrasenaPerfil = widget.contrasena;
    telefonPerfil = widget.celular;
    direccionPerfil = widget.direccion;
    fotoPerfil = widget.foto;
    profesionPerfil = widget.profesion;
    cargarDatos();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String selectedCategoryId = "Damas"; // ID de la categoría seleccionada

  List<Widget> buildCategories() {
    return Data.generateCategories().map((e) {
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
                  child: Image.asset(
                    e.catalogo,
                    height: 45,
                    width: 45,
                  ),
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
              print("Categoría seleccionada: " + e.id);
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ShopScreen(
                                                compra: carrito,
                                              )));
                                },
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShopScreen(
                                              compra: carrito,
                                            )));
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
                                          right: 18,
                                          left: 18,
                                          top: 10,
                                          bottom: 10),
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
                                              child: Text("  Comprar Ahora  ".toUpperCase(),
                                                  style:
                                                      TextStyle(fontSize: 12)),
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
                childAspectRatio: 0.9,
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
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.leftToRight,
                                    child: DetailScreen(
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
                          },
                          child: Container(
                            height: 250,
                            width: 200,
                            margin: EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.network(
                                    e.catalogo,
                                    height: 250,
                                    width: double.infinity,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: e.category,
                                      style: TextStyle(
                                          color: MyColors.myPurple,
                                          fontSize: 16.0)),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                      text: e.title,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 18.0)),
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
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black87),
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
                  currentIndex = index;
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
                    width: index == currentIndex
                        ? displayWidth * .32
                        : displayWidth * .18,
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      duration: Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == currentIndex ? displayWidth * .12 : 0,
                      width: index == currentIndex ? displayWidth * .32 : 0,
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? MyColors.myPurple
                            : Colors.black.withOpacity(.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: index == currentIndex
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
                              width: index == currentIndex
                                  ? displayWidth * .13
                                  : 0,
                            ),
                            AnimatedOpacity(
                              opacity: index == currentIndex ? 1 : 0,
                              duration: Duration(seconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: Text(
                                index == currentIndex
                                    ? '${listOfStrings[index]}'
                                    : '',
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
                              width: index == currentIndex
                                  ? displayWidth * .03
                                  : 20,
                            ),
                            Icon(
                              listOfIcons[index],
                              size: displayWidth * .076,
                              color: index == currentIndex
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
