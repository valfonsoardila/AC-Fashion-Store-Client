import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMapsScreen extends StatefulWidget {
  final categoriaPago;
  final total;
  final compra;
  final perfil;
  GoogleMapsScreen(
      {super.key, this.categoriaPago, this.total, this.compra, this.perfil});

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  GoogleMapController? _mapController;
  List<Placemark> placemarks = [];
  TextEditingController controlId = TextEditingController();
  TextEditingController controlCorreo = TextEditingController();
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlTelefono = TextEditingController();
  TextEditingController controlURL = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  bool _isDarkMode = false;
  bool _searchLocation = false;
  bool _controllerconectivity = false;
  String _locationMessage = "";
  String latitude = '';
  String longitude = '';
  String selectedCategoryName = '';
  ImagePicker picker = ImagePicker();
  List<Map<String, dynamic>> carrito = [];
  Map<String, dynamic> perfil = {};
  var idUser;
  var correo;
  var nombre;
  var telefono;
  var url;
  var direccion;
  var _image;
  var _myLocation = LatLng(0, 0);
  var _myLocationInit = LatLng(0, 0);
  var currentlocation = [];
  List<Location> locations = [];
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
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    currentlocation = placemarks;
    return position;
  }

  String getFormattedTime() {
    var now = DateTime.now();
    var formattedTime = DateFormat('h:mm a').format(now);
    return formattedTime;
  }

  void cargarDatos() {
    _determinePosition().then((value) {
      setState(() {
        double latitude = value.latitude;
        double longitude = value.longitude;
        _myLocationInit = LatLng(latitude, longitude);
        _myLocation = _myLocationInit;
        _locationMessage = "${value.latitude}, ${value.longitude}";
        print("mi poosicion es: $_locationMessage");
      });
    });
    selectedCategoryName = widget.categoriaPago;
    carrito = widget.compra;
    perfil = widget.perfil;
    print(perfil);
    if (perfil != {}) {
      idUser = perfil['id'];
      correo = perfil['correo'];
      nombre = perfil['nombre'];
      telefono = perfil['celular'];
      url = perfil['foto'];
    }
  }

  void _facturar() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Factura de compra',
                style: TextStyle(color: Colors.black),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width *
                    0.8, // El 80% del ancho de la pantalla
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Esta factura se enviará como comprobante de compra a su correo y telefono movil.',
                            style: TextStyle(
                              color: _isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 10),
                          Card(
                            borderOnForeground: false,
                            color: _isDarkMode
                                ? Colors.grey.shade800
                                : Color.fromARGB(255, 247, 245, 245),
                            clipBehavior: Clip.antiAlias,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              height: 250,
                              width: 450,
                              padding: EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  Text('Datos de comprador',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  SizedBox(height: 10),
                                  NewImage(
                                      controller: _controllerconectivity,
                                      img: url,
                                      text: ''),
                                  Row(
                                    children: [
                                      Text('Nombre: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text(nombre ?? 'No registrado',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Correo: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text(correo ?? 'No registrado',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Telefono: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text(telefono ?? 'No registrado',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Card(
                            borderOnForeground: false,
                            color: _isDarkMode
                                ? Colors.grey.shade800
                                : Color.fromARGB(255, 247, 245, 245),
                            clipBehavior: Clip.antiAlias,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              height: 250,
                              width: 450,
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text('Datos de compra',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Row(
                                    children: [
                                      Text('Productos a pagar: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text('${carrito.length}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Total a pagar: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text('${widget.total}',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Metodo de pago: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text('$selectedCategoryName',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Fecha de compra: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text(
                                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Hora de compra: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text('${getFormattedTime()}',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Estado de entrega: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text('Pendiente',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Tiempo de entrega: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Text('4 a 10 horas',
                                          style: TextStyle(
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Direccion: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Expanded(
                                        child:
                                            Text(direccion ?? "No registrado",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () {
                    // Lógica para guardar los cambios realizados en el perfil
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.attach_money_sharp,
                      color: Colors.green.shade900),
                  label: Text('Pagar',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
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
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              children: [
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
                                    color: _isDarkMode
                                        ? Colors.white
                                        : Colors.black,
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
                            controller: controlDireccion,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              labelText: 'Direccion de entrega',
                              hintText:
                                  'Ej: Calle 1 # 1 - 1, Barrio Cortijos, Valledupar',
                              suffixIcon: Icon(Icons.location_on),
                            ),
                            onChanged: (value) async {
                              locations = await locationFromAddress(value);
                              placemarks = await placemarkFromCoordinates(
                                  locations[0].latitude,
                                  locations[0].longitude);
                              print(placemarks);
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
                                    setState(() {
                                      _searchLocation = true;
                                      _myLocation = _myLocationInit;
                                      direccion = controlDireccion.text;
                                      _mapController?.animateCamera(
                                          CameraUpdate.newLatLng(_myLocation));
                                      currentlocation = placemarks;
                                      print(currentlocation);
                                    });
                                  },
                                  icon: Icon(Icons.location_on),
                                  label: Text('Usar ubicacion actual')),
                              TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _searchLocation = true;
                                      direccion = controlDireccion.text;
                                      print(direccion);
                                      if (direccion != '') {
                                        _myLocation = LatLng(
                                            locations[0].latitude,
                                            locations[0].longitude);
                                        _mapController?.animateCamera(
                                            CameraUpdate.newLatLng(
                                                _myLocation));
                                        currentlocation = placemarks;
                                      }
                                      print(currentlocation);
                                    });
                                  },
                                  icon: Icon(Icons.search),
                                  label: Text('Buscar ubicacion')),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height:
                              450, // Establecer una altura específica para el mapa
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                _locationMessage != ''
                                    ? placemarks != []
                                        ? GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                                    target: _myLocation,
                                                    zoom: 15),
                                            mapType: MapType.normal,
                                            onMapCreated: (GoogleMapController
                                                googleMapController) {
                                              _mapController =
                                                  googleMapController;
                                            },
                                            markers: {
                                              Marker(
                                                markerId: MarkerId('1'),
                                                position: _myLocation,
                                                infoWindow: InfoWindow(
                                                  title: 'Mi ubicacion',
                                                  snippet:
                                                      'Aqui se hará la entrega',
                                                ),
                                                flat: true,
                                                icon: BitmapDescriptor
                                                    .defaultMarker,
                                              ),
                                            },
                                          )
                                        : Container()
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _facturar();
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white,
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                MyColors.myPurple,
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            child: Text(
                              'Pagar',
                              style: TextStyle(fontSize: 18),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewImage extends StatelessWidget {
  final dynamic img;
  final String text;
  final bool controller;
  NewImage({
    Key? key,
    required this.text,
    required this.img,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    bool _controllerconectivity = controller;
    if (img != null && Uri.parse(img).isAbsolute) {
      // Si img es una URL válida, carga la imagen desde la URL
      imageWidget = _controllerconectivity != false
          ? CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(img),
            )
          : CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/user.png"),
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
        radius: 30,
        backgroundImage: AssetImage('assets/images/user.png'),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        imageWidget,
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}