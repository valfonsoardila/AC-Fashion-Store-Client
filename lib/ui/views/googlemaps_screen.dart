import 'package:acfashion_store/domain/controller/controllerPedido.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/views/Invoice/Invoice_screen.dart';
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
  ControlPedido controlpd = ControlPedido();
  GoogleMapController? _mapController;
  List<Placemark> placemarks = [];
  TextEditingController controlId = TextEditingController();
  TextEditingController controlCorreo = TextEditingController();
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlTelefono = TextEditingController();
  TextEditingController controlURL = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  bool isDarkMode = false;
  bool _searchLocation = false;
  bool _controllerconectivity = false;
  String _locationMessage = "";
  String latitude = '';
  String longitude = '';
  String selectedCategoryName = '';
  ImagePicker picker = ImagePicker();
  List<Map<String, dynamic>> carrito = [];
  List<Location> locations = [];
  Map<String, dynamic> perfil = {};
  int total = 0;
  //VARIABLES PERFIL
  var idUser;
  var correo;
  var nombre;
  var telefono;
  var url;
  var direccion;
  //VARIABLES UBICACION
  var _myLocation = LatLng(0, 0);
  var _myLocationInit = LatLng(0, 0);
  var currentlocation = [];
  //determina ubicacion actual
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final Position position = await Geolocator.getCurrentPosition();
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    currentlocation = placemarks;
    if (currentlocation[0].subLocality != '' &&
        currentlocation[0].locality != '') {
      print('entro 1');
      direccion =
          '${currentlocation[0].street}, ${currentlocation[0].subLocality}, ${currentlocation[0].locality}';
      print(direccion);
    } else {
      print('entro 2');
      direccion =
          '${currentlocation[0].street}, ${currentlocation[0].subAdministrativeArea}, ${currentlocation[0].administrativeArea}, ${currentlocation[0].country}';
      print(direccion);
    }
    print("DIRECCION: $direccion");
    return position;
  }

  //obtiene la hora actual
  String getFormattedTime() {
    var now = DateTime.now();
    var formattedTime = DateFormat('h:mm a').format(now);
    return formattedTime;
  }

  //muestra la factura
  void _showInvoiceSheet(BuildContext context) {
    print("Perfil en google maps: $perfil");
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return InvoiceScreen(
          themeMode: isDarkMode,
          controllerconectivity: _controllerconectivity,
          carrito: carrito,
          perfil: perfil,
          url: url,
          nombre: nombre,
          correo: correo,
          telefono: telefono,
          total: total,
          selectedCategoryName: selectedCategoryName,
          direccion: direccion,
        );
      },
    );
  }

  //carga los datos
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
    total = widget.total;
    print(perfil);
    if (perfil != {}) {
      print("entro al if perfil no es vacio");
      idUser = perfil['uid'];
      correo = perfil['correo'];
      nombre = perfil['nombre'];
      telefono = perfil['celular'];
      url = perfil['foto'];
      print("Prueba id usuario: $idUser");
    }
    print("Esta foto es la foto de perfil: $url");
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
      isDarkMode = true;
    } else {
      isDarkMode = false;
    }

    return Scaffold(
      body: Container(
        color: isDarkMode ? Colors.black : Colors.white,
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
                            color: isDarkMode ? Colors.white : Colors.black),
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
                                    color: isDarkMode
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
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 124, 12, 131)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: isDarkMode != false
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              labelText: 'Direccion de entrega',
                              labelStyle: TextStyle(
                                  color: isDarkMode != false
                                      ? Colors.white
                                      : Colors.black),
                              hintText:
                                  'Ej: Calle 1 # 1 - 1, Barrio Cortijos, Valledupar',
                              suffixIcon: Icon(Icons.location_on,
                                  color: Color.fromARGB(255, 124, 12, 131)),
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
                                      _determinePosition();
                                      if (currentlocation[0].subLocality !=
                                              '' &&
                                          currentlocation[0].locality != '') {
                                        print('entro 1');
                                        controlDireccion.text =
                                            '${currentlocation[0].street}, ${currentlocation[0].subLocality}, ${currentlocation[0].locality}';
                                        print(controlDireccion.text);
                                      } else {
                                        print('entro 2');
                                        controlDireccion.text =
                                            '${currentlocation[0].street}, ${currentlocation[0].subAdministrativeArea}, ${currentlocation[0].administrativeArea}, ${currentlocation[0].country}';
                                        print(controlDireccion.text);
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.location_on,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Color.fromARGB(255, 124, 12, 131)),
                                  label: Text(
                                    'Usar ubicacion actual',
                                    style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Color.fromARGB(
                                                255, 124, 12, 131)),
                                  )),
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
                                  icon: Icon(Icons.search,
                                      color: isDarkMode
                                          ? Colors.white
                                          : Color.fromARGB(255, 124, 12, 131)),
                                  label: Text('Buscar ubicacion',
                                      style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Color.fromARGB(
                                                  255, 124, 12, 131)))),
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
                        InkWell(
                          onTap: () {
                            _showInvoiceSheet(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromARGB(255, 124, 12, 131),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Facturar compra',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                SizedBox(width: 10),
                                Icon(Icons.attach_money_sharp,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
