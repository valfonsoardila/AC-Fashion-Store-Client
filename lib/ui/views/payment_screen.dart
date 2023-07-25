import 'dart:io';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/ui/models/assets_model.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:acfashion_store/ui/views/googlemaps_screen.dart';
// import 'package:acfashion_store/ui/views/location_map.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final perfil;
  final compra;
  final int total;
  PaymentScreen({
    super.key,
    required this.perfil,
    this.compra,
    required this.total,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  ControlUserPerfil controlup = ControlUserPerfil();
  bool _isDarkMode = false;
  bool _controllerconectivity = false;
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
  //FUNCIONES
  String getFormattedTime() {
    var now = DateTime.now();
    var formattedTime = DateFormat('h:mm a').format(now);
    return formattedTime;
  }

  void _initConnectivity() async {
    // Obtiene el estado de la conectividad al inicio
    final connectivityResult = await Connectivity().checkConnectivity();
    _updateConnectionStatus(connectivityResult);

    // Escucha los cambios en la conectividad y actualiza el estado en consecuencia
    Connectivity().onConnectivityChanged.listen((connectivityResult) {
      _updateConnectionStatus(connectivityResult);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    setState(() {
      _controllerconectivity = connectivityResult != ConnectivityResult.none;
    });
  }

  _galeria() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = (image != null) ? File(image.path) : null;
      //_image = File(image!.path);
    });
  }

  _camara() async {
    XFile? image =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = (image != null) ? File(image.path) : null;
      // _image = File(image!.path);
    });
  } //FUNCIONES

  void _opcioncamara(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Imagen de Galeria'),
                    onTap: () {
                      _galeria();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Capturar Imagen'),
                  onTap: () {
                    _camara();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _cargarDatos() {
    carrito = widget.compra;
    idUser = carrito[0]['uid'];
    correo = perfil['correo'];
    nombre = perfil['nombre'];
    telefono = perfil['celular'];
    url = perfil['foto'];
  }

  // void _facturar() {
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return AlertDialog(
  //             backgroundColor: Colors.white,
  //             title: Text(
  //               'Factura de compra',
  //               style: TextStyle(color: Colors.black),
  //             ),
  //             content: Container(
  //               width: MediaQuery.of(context).size.width *
  //                   0.8, // El 80% del ancho de la pantalla
  //               color: Colors.white,
  //               child: SingleChildScrollView(
  //                 child: Container(
  //                   color: Colors.white,
  //                   child: Center(
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           'Esta factura se enviará como comprobante de compra a su correo y telefono movil.',
  //                           style: TextStyle(
  //                             color: _isDarkMode ? Colors.white : Colors.black,
  //                           ),
  //                         ),
  //                         SizedBox(height: 10),
  //                         Card(
  //                           borderOnForeground: false,
  //                           color: _isDarkMode
  //                               ? Colors.grey.shade800
  //                               : Color.fromARGB(255, 247, 245, 245),
  //                           clipBehavior: Clip.antiAlias,
  //                           shadowColor: Colors.black,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(30.0),
  //                           ),
  //                           child: Container(
  //                             height: 250,
  //                             width: 450,
  //                             padding: EdgeInsets.all(5.0),
  //                             child: Column(
  //                               children: [
  //                                 Text('Datos de comprador',
  //                                     style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 18)),
  //                                 SizedBox(height: 10),
  //                                 NewImage(
  //                                     controller: _controllerconectivity,
  //                                     img: url,
  //                                     text: ''),
  //                                 Row(
  //                                   children: [
  //                                     Text('Nombre: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text(nombre ?? 'No registrado',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontSize: 18)),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Correo: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text(correo ?? 'No registrado',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontSize: 18)),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Telefono: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text(telefono ?? 'No registrado',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontSize: 18)),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         Card(
  //                           borderOnForeground: false,
  //                           color: _isDarkMode
  //                               ? Colors.grey.shade800
  //                               : Color.fromARGB(255, 247, 245, 245),
  //                           clipBehavior: Clip.antiAlias,
  //                           shadowColor: Colors.black,
  //                           shape: RoundedRectangleBorder(
  //                             borderRadius: BorderRadius.circular(30.0),
  //                           ),
  //                           child: Container(
  //                             height: 250,
  //                             width: 450,
  //                             padding: EdgeInsets.all(10.0),
  //                             child: Column(
  //                               children: [
  //                                 Text('Datos de compra',
  //                                     style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.bold,
  //                                         fontSize: 18)),
  //                                 Row(
  //                                   children: [
  //                                     Text('Productos a pagar: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text('${carrito.length}',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontSize: 18)),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Total a pagar: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text('${widget.total}',
  //                                         style: TextStyle(
  //                                           color: Colors.black,
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Metodo de pago: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text('$selectedCategoryName',
  //                                         style: TextStyle(
  //                                           color: Colors.black,
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Fecha de compra: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text(
  //                                         '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
  //                                         style: TextStyle(
  //                                           color: Colors.black,
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Hora de compra: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text('${getFormattedTime()}',
  //                                         style: TextStyle(
  //                                           color: Colors.black,
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Estado de entrega: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text('Pendiente',
  //                                         style: TextStyle(
  //                                           color: Colors.black,
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Tiempo de entrega: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text('4 a 10 horas',
  //                                         style: TextStyle(
  //                                           color: Colors.black,
  //                                         )),
  //                                   ],
  //                                 ),
  //                                 Row(
  //                                   children: [
  //                                     Text('Direccion: ',
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18)),
  //                                     Text(direccion ?? "No registrado",
  //                                         style: TextStyle(
  //                                           color: Colors.black,
  //                                         )),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               TextButton.icon(
  //                 onPressed: () {
  //                   // Lógica para guardar los cambios realizados en el perfil
  //                   Navigator.of(context).pop();
  //                   var perfil = <String, dynamic>{};
  //                 },
  //                 icon: Icon(Icons.attach_money_sharp,
  //                     color: Colors.green.shade900),
  //                 label: Text('Pagar',
  //                     style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18)),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child: Text('Cancelar',
  //                     style: TextStyle(
  //                         color: Colors.black,
  //                         fontWeight: FontWeight.bold,
  //                         fontSize: 18)),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

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
  void initState() {
    perfil = widget.perfil;
    _cargarDatos();
    _initConnectivity();
    super.initState();
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
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.payment,
                color: _isDarkMode ? Colors.white : Colors.black),
            SizedBox(width: 5),
            Text('Metodos de pago',
                style: TextStyle(
                    color: _isDarkMode ? Colors.white : Colors.black)),
          ],
        ),
        backgroundColor: _isDarkMode ? Colors.grey[900] : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: _isDarkMode ? Colors.white : Colors.black),
          onPressed: () {
            Navigator.pop(context, widget.compra);
          },
        ),
        iconTheme:
            IconThemeData(color: _isDarkMode ? Colors.white : Colors.black),
      ),
      body: Container(
        color: _isDarkMode ? Colors.black : Colors.white,
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
                  var perfil = <String, dynamic>{
                    'uid': idUser,
                    'correo': correo,
                    'nombre': nombre,
                    'celular': telefono,
                    'foto': url,
                  };
                  print("Perfil: $perfil");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GoogleMapsScreen(
                                categoriaPago: selectedCategoryName,
                                total: widget.total,
                                compra: carrito,
                                perfil: perfil,
                              )));
                },
              ),
            ),
          ],
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
