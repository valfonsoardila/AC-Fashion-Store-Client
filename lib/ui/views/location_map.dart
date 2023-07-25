import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/views/payment_screen.dart';
// import 'package:acfashion_store/ui/views/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationMap extends StatefulWidget {
  final perfil;
  final compra;
  final total;
  LocationMap({super.key, this.compra, this.total, this.perfil});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  var direccion = '';
  bool _isDarkMode = false;
  bool _searchLocation = false;
  String _locationMessage = "";
  String latitude = '';
  String longitude = '';
  final ApiKey = dotenv.env['MY_MAPPI_API_KEY'];
  var _myLocation = LatLng(0, 0);
  Placemark place = Placemark();
  // void _launchMapUrl(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri)) {
  //     throw Exception('Could not launch $uri');
  //   }
  // }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final Position position = await Geolocator.getCurrentPosition();
    // print(position);
    return position;
  }

  void obtenerDatoDeUbicacion() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _myLocation.latitude, _myLocation.longitude);
    place = placemarks[0];
    print(place);
  }

  @override
  void initState() {
    super.initState();
    _searchLocation = false;
    _determinePosition().then((value) {
      setState(() {
        double latitude = value.latitude;
        double longitude = value.longitude;
        _myLocation = LatLng(latitude, longitude);
        _locationMessage = "${value.latitude}, ${value.longitude}";
        print(_locationMessage);
        obtenerDatoDeUbicacion();
      });
    });
  }

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
                      Navigator.of(context).pop();
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
                              onPressed: () {
                                _determinePosition().then((value) {
                                  setState(() {
                                    _searchLocation = true;
                                    latitude = value.latitude.toString();
                                    longitude = value.longitude.toString();
                                    _locationMessage =
                                        "${value.latitude}, ${value.longitude}";
                                  });
                                });
                              },
                              icon: Icon(Icons.location_on),
                              label: Text('Usar ubicacion actual')),
                          TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  _searchLocation = true;
                                });
                              },
                              icon: Icon(Icons.search),
                              label: Text('Buscar ubicacion')),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _searchLocation != false
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: (Text(
                              'Codigo de ubicacion: $_locationMessage',
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.start,
                            )),
                          )
                        : Container(),
                    SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                FlutterMap(
                                  options: MapOptions(
                                    minZoom: 10,
                                    maxZoom: 16,
                                    zoom: 13,
                                  ),
                                  nonRotatedChildren: [
                                    TileLayer(
                                      urlTemplate:
                                          'https://api.mymappi.com/maps/raster/{z}/{x}/{y}.png?key={accessToken}',
                                      additionalOptions: {
                                        'accessToken': ApiKey?.toString() ?? '',
                                        'id': '',
                                      },
                                    ),
                                    MarkerLayer(
                                      markers: [
                                        Marker(
                                          width: 80.0,
                                          height: 80.0,
                                          point: _myLocation,
                                          builder: (ctx) => Container(
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentScreen(
                                        perfil: widget.perfil,
                                        compra: widget.compra,
                                        total: widget.total,
                                      )));
                        },
                        child: Text('Continuar'))
                    // _searchLocation != false
                    //     ? Expanded(
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Container(
                    //             alignment: Alignment.center,
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(20),
                    //                 image: DecorationImage(
                    //                     image: AssetImage(
                    //                         'assets/images/Map1.jpg'),
                    //                     fit: BoxFit.cover)),
                    //             child: Container(
                    //                 alignment: Alignment.center,
                    //                 decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(20),
                    //                   color: Colors.white.withOpacity(0.3),
                    //                 ),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.center,
                    //                   children: [
                    //                     TextButton.icon(
                    //                       onPressed: () {
                    //                         // Reemplaza 'latitude' y 'longitude' con las variables que contienen las coordenadas
                    //                         final url =
                    //                             'https://www.google.com/maps?q=$latitude,$longitude';
                    //                         _launchMapUrl(url);
                    //                       },
                    //                       icon: Icon(
                    //                         Icons.location_on,
                    //                         color: Colors.red,
                    //                       ),
                    //                       label: Text(
                    //                         'Confirmar ubicación',
                    //                         style: TextStyle(
                    //                             color: _isDarkMode
                    //                                 ? Colors.white
                    //                                 : Colors.black,
                    //                             fontSize: 18,
                    //                             decoration:
                    //                                 TextDecoration.underline),
                    //                       ),
                    //                     )
                    //                   ],
                    //                 )),
                    //           ),
                    //         ),
                    //       ) //Espacio donde se mostrara el mapa
                    //     : Container(),
                    // SizedBox(height: 5),
                    // _searchLocation != false
                    //     ? ElevatedButton(
                    //         onPressed: () {
                    //           Navigator.push(
                    //               context,
                    //               MaterialPageRoute(
                    //                   builder: (context) => PaymentScreen(
                    //                         compra: widget.compra,
                    //                         total: widget.total,
                    //                       )));
                    //         },
                    //         child: Text('Continuar'))
                    //     : Container(),
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
