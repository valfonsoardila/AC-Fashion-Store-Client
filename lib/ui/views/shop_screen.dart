import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/payment_gateway.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  final compra;
  final itemCount;
  const ShopScreen({
    Key? key,
    this.compra,
    this.itemCount,
  }) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<Map<String, dynamic>> compra = [];
  var count;
  double total() {
    double total = 0;
    for (var i = 0; i < compra.length; i++) {
      total = total + compra[i]['precio'];
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    compra = widget.compra;
    count = widget.itemCount;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.shopping_cart),
              SizedBox(
                width: 10,
              ),
              Text(
                'Tu carrito de compras',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        child: compra.isEmpty
            ? Container(
                child: Column(children: [
                  Text(
                    'No hay artículos seleccionados',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 100,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Agrega artículos a tu carrito de compras',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'para poder comprarlos',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '¡Es muy fácil!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '1. Selecciona el artículo que deseas comprar',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '2. Presiona el botón "Agregar al carrito"',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 30,
                        color: Colors.black,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '3. ¡Listo! Ya puedes comprar tus artículos',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ]),
              )
            : Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 30,
                        color: MyColors.myPurple,
                        alignment: Alignment.center,
                        child: Text(
                          'Artículos seleccionados',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Container(
                      child: Expanded(
                    child: ListView.builder(
                      itemCount: compra.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                alignment: Alignment.center,
                                child: Text('${index + 1}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(compra[index]['imagen']),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      compra[index]['titulo'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      compra[index]['descripcion'],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '\$' + compra[index]['precio'].toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: IconButton(
                                  hoverColor: Colors.red,
                                  splashRadius: 20,
                                  splashColor: Colors.red,
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      compra.removeAt(index);
                                      count = count - 1;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                  alignment: Alignment.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    color: MyColors.myPurple,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          'Total: \$' + total().toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentGateway(
                                        compra: compra,
                                      )),
                            );
                          },
                          child: Text('Pagar'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
