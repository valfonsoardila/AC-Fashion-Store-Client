import 'package:acfashion_store/domain/controller/controllerProductos.dart';
import 'package:acfashion_store/ui/models/product_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/shop_screen.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final int cantidad;
  final String image;
  final String title;
  final String color;
  final String talla;
  final String category;
  final String description;
  final String valoration;
  final double price;

  DetailScreen({
    Key? key,
    required this.id,
    required this.cantidad,
    required this.image,
    required this.title,
    required this.color,
    required this.talla,
    required this.category,
    required this.description,
    required this.valoration,
    required this.price,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DetailScreen> {
  ControlProducto controlp = new ControlProducto();
  List<Map<String, dynamic>> carrito = [];
  bool _isFavorited = false;
  bool autoRotate = false;
  int rotationCount = 22;
  int swipeSensitivity = 2;
  bool allowSwipeToRotate = true;
  bool imagePrecached = true;
  List<ProductModel> productos = [];
  var itemCount;
  var idProducto = "";
  var cantidad = 0;
  var imagen = "";
  var titulo = "";
  var color = "";
  var talla = "";
  var categoria = "";
  var descripcion = "";
  var valoracion = "";
  var precio = 0.0;

  @override
  void initState() {
    super.initState();
    idProducto = widget.id;
    imagen = widget.image;
    titulo = widget.title;
    color = widget.color;
    talla = widget.talla;
    categoria = widget.category;
    descripcion = widget.description;
    valoracion = widget.valoration;
    precio = widget.price;
    cantidad = widget.cantidad;
    //updateImageList(context);
  }

  List<ProductModel> colorCategories() {
    return productos;
  }

  List<Widget> buildColorWidgets() {
    return colorCategories()
        .map(
          (e) => Container(
            padding: const EdgeInsets.only(left: 5, bottom: 10, top: 15),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: e.id == 1 ? MyColors.myPurple : Colors.white),
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  e.modelo,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
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
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          categoria,
          style: TextStyle(color: MyColors.myPurple),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: MyColors.myBlack),
        elevation: 0,
        actions: [
          _isFavorited != false
              ? IconButton(
                  icon: Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _isFavorited = !_isFavorited;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.black),
                  onPressed: () {
                    setState(() {
                      _isFavorited = !_isFavorited;
                    });
                  },
                ),
          IconButton(
            icon: Icon(Icons.add_shopping_cart_outlined),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            color: Colors.black,
            onPressed: () async {
              if (cantidad >= 1) {
                carrito.add({
                  "id": idProducto,
                  "cantidad": cantidad,
                  "imagen": imagen,
                  "titulo": titulo,
                  "color": color,
                  "talla": talla,
                  "categoria": categoria,
                  "descripcion": descripcion,
                  "valoracion": valoracion,
                  "precio": precio,
                });
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShopScreen(
                              compra: carrito,
                              itemCount: 1,
                            )));
                if (result != null) {
                  setState(() {
                    itemCount = result;
                  });
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                height: size.width - 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: size.width * 0.2,
                            width: size.width * 0.9,
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/ring.png"),
                                fit: BoxFit.fill,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: size.width * 0.8,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(imagen),
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  width: size.width,
                  decoration: new BoxDecoration(
                      color: MyColors.grayBackground,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: titulo,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                  text: valoracion,
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 16.0,
                                  )),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            RichText(
                              textAlign: TextAlign.start,
                              text: const TextSpan(
                                  text: "(1125 Review)",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 16.0,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: TextSpan(
                              text: descripcion,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 16.0,
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          textAlign: TextAlign.start,
                          text: const TextSpan(
                              text: "Selecciona el color :",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20.0,
                              )),
                        ),
                        SizedBox(
                          height: 80,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: buildColorWidgets(),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
