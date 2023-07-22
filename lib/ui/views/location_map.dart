import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocationMap extends StatefulWidget {
  final compra;
  LocationMap({super.key, this.compra});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  var direccion = '';
  bool _isDarkMode = false;
  String _locationMessage = "";

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          child: Stack(children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: _isDarkMode ? Colors.white : Colors.black),
                    onPressed: () {
                      Navigator.pop(context, widget.compra);
                    },
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 60),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Selecciona la ubicacion de entrega',
                            style: TextStyle(
                                color:
                                    _isDarkMode ? Colors.white : Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Aqui seleccionará la ubicacion donde se hará entrega',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                        'de la compra. recuerde que la informacion de ubicacion',
                        style: TextStyle(fontSize: 16)),
                    Text('debe ser correcta para evitar inconvenientes.',
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 50),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: TextField(
                        controller: TextEditingController(text: direccion),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          labelText: 'Direccion de entrega',
                          hintText: 'Ej: Calle 1 # 1 - 1, Valledupar',
                          suffixIcon: Icon(Icons.location_on),
                        ),
                        onChanged: (value) {
                          setState(() {
                            direccion = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.location_on),
                              label: Text('Usar ubicacion actual')),
                          TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.search),
                              label: Text('Buscar ubicacion')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
