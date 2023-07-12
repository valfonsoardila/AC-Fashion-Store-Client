import 'package:acfashion_store/ui/home/aside.dart';
import 'package:acfashion_store/ui/models/notification_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:acfashion_store/ui/models/data.dart';
import 'package:acfashion_store/ui/views/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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

class _DashboardScreenState extends State<DashboardScreen> {
  bool isSearchOpen = false;
  String id = "";
  String nombrePerfil = 'Nombre de usuario';
  String correoPerfil = 'correo electrónico';
  String contrasenaPerfil = 'Contraseña';
  String telefonPerfil = 'Teléfono';
  String direccionPerfil = 'Dirección';
  String fotoPerfil = 'Foto de perfil';
  String profesionPerfil = 'Profesión';

  String idProducto = "";
  String cantidadProducto = "";
  String fotoProducto = "";
  String nombreProducto = "";
  String descripcionProducto = "";
  String colorProducto = "";
  String tallaProducto = "";
  String categoriaProducto = "";
  String valoracionProducto = "";
  String precioProducto = "";
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
                    e.image,
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: CircleAvatar(
              backgroundImage: fotoPerfil != ""
                  ? NetworkImage(fotoPerfil)
                  : NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
              radius: 18,
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Aside(
                          id: id,
                          nombre: nombrePerfil,
                          correo: correoPerfil,
                          contrasena: contrasenaPerfil,
                          telefono: telefonPerfil,
                          direccion: direccionPerfil,
                          foto: fotoPerfil,
                          profesion: profesionPerfil,
                        ))),
          ),
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
                      badges.Badge(
                        badgeContent: Text(
                          '2',
                          style: TextStyle(color: Colors.white),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart_outlined,
                              color: Colors.black),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopScreen()));
                          },
                        ),
                      ),
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
                                    child: DetailScreen()));
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
                                    e.image,
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
                                          Icons.add,
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
                                        onPressed: () {})
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
        floatingActionButtonLocation: FloatingActionButtonLocation
            .startDocked, //specify the location of the FAB
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.myPurple,
          onPressed: () {
            print('OK');
          },
          tooltip: "Principal",
          child: Container(
            margin: EdgeInsets.all(15.0),
            child: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
          ),
          elevation: 4.0,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 30,
              ),
              IconButton(
                icon: Icon(Icons.shopping_bag, color: Colors.black),
                tooltip: "Tus compras",
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.favorite_outline, color: Colors.black),
                tooltip: "Favoritos",
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.black),
                tooltip: "Configuración",
                onPressed: () {},
              ),
              SizedBox(
                width: 2,
              ),
            ],
          ),
        ));
  }
}
