import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
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
        child: ListView(
          children: [
            Container(
              color: MyColors.myPurple,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
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
            ),
          ],
        ),
      ),
    );
  }
}
