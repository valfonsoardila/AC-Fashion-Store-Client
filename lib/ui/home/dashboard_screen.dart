import 'package:acfashion_store/ui/home/aside.dart';
import 'package:acfashion_store/ui/views/detail_screen.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/utilities/data.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class DashboardScreen extends StatefulWidget {
  final String nombre;
  final String correo;
  final String celular;
  final String direccion;
  final String foto;
  final String profesion;
  DashboardScreen({
    Key? key,
    required this.nombre,
    required this.correo,
    required this.celular,
    required this.direccion,
    required this.foto,
    required this.profesion,
  }) : super(key: key);
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String nombrePerfil = 'Nombre de usuario';
  String correoPerfil = 'Correo electrónico';
  String telefonPerfil = 'Teléfono';
  String direccionPerfil = 'Dirección';
  String fotoPerfil = 'Foto de perfil';
  String profesionPerfil = 'Profesión';
  @override
  void initState() {
    super.initState();
    nombrePerfil = widget.nombre;
    correoPerfil = widget.correo;
    telefonPerfil = widget.celular;
    direccionPerfil = widget.direccion;
    fotoPerfil = widget.foto;
    profesionPerfil = widget.profesion;
  }

  List<Widget> buildCategories() {
    return Data.generateCategories()
        .map(
          (e) => Container(
            padding: const EdgeInsets.only(left: 15, bottom: 10),
            child: ElevatedButton(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        color: MyColors.grayBackground,
                        child: Image.asset(
                          e.image,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(e.title, style: const TextStyle(fontSize: 14)),
                  ],
                ),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        e.id == 1 ? Colors.white : Colors.black38),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        e.id == 1 ? MyColors.myPurple : Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)))),
                onPressed: () {}),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:
                Image.asset("assets/icons/ic_menu.png", width: 18, height: 18),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Aside(
                          nombre: nombrePerfil,
                          correo: correoPerfil,
                          telefono: telefonPerfil,
                          direccion: direccionPerfil,
                          foto: fotoPerfil,
                          profesion: profesionPerfil,
                        ))),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
            IconButton(
              icon: Image.asset(
                "assets/icons/ic_search.png",
                width: 18,
                height: 18,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset("assets/images/img_banner.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.center,
                          text: const TextSpan(
                            text: "Nuevo lanzamiento",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: const TextSpan(
                            text: "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 28),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        ElevatedButton(
                            child: Text("  Comprar Ahora  ".toUpperCase(),
                                style: const TextStyle(fontSize: 14)),
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: RichText(
                textAlign: TextAlign.start,
                text: const TextSpan(
                    text: "Nuevos diseños",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GridView.count(
              childAspectRatio: 0.9,
              crossAxisCount: 2,
              padding: const EdgeInsets.all(5.0),
              children: Data.generateProducts()
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
                          margin: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                e.image,
                                height: 90,
                                width: double.infinity,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: e.type,
                                    style: const TextStyle(
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
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 18.0)),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                        text: "\$ ${e.price}",
                                        style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                      child: const Icon(
                                        Icons.add,
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
              physics: const ClampingScrollPhysics(),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .startDocked, //specify the location of the FAB
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColors.myPurple,
          onPressed: () {
            print('OK');
          },
          tooltip: "start FAB",
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
                icon: Image.asset("assets/icons/ic_shop.png"),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset("assets/icons/ic_wishlist.png"),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset("assets/icons/ic_notif.png"),
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
