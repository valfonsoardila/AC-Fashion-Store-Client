import 'package:acfashion_store/ui/models/assets_model.dart';
import 'package:acfashion_store/ui/models/mcommerce_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:flutter/material.dart';

class PaymentGateway extends StatefulWidget {
  final compra;
  PaymentGateway({super.key, this.compra});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  void seleccionarCategoria(categoria) {}
  String selectedCategoryName =
      "Ahorro a la mano"; // ID de la categoría seleccionada
  List<Widget> buildCategories() {
    return AssetsModel.generateMCommerces().map((e) {
      bool isSelected = selectedCategoryName == e.name;
      return Container(
        padding: EdgeInsets.only(left: 15, bottom: 10),
        child: ElevatedButton(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  color: MyColors.grayBackground,
                  child: e.image.isNotEmpty
                      ? Image.asset(
                          e.image,
                          height: 70,
                          width: 70,
                        )
                      : Container(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                e.name,
                style: TextStyle(
                  fontSize: 20,
                  color: isSelected ? Colors.white : e.color,
                ),
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
              selectedCategoryName = e.name;
              seleccionarCategoria(e.name);
            });
          },
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.payment, color: MyColors.myPurple),
            SizedBox(width: 5),
            Text('Metodos de pago', style: TextStyle(color: MyColors.myPurple)),
          ],
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, widget.compra);
          },
        ),
        iconTheme: IconThemeData(color: MyColors.myPurple),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text(
                '>> Selecciona un metodo de pago <<',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: buildCategories(),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                child: Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.white,
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    MyColors.myPurple,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                onPressed: () {
                  //Navigator.pushNamed(context, '/payment_gateway');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
