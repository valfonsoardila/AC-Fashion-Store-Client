import 'package:acfashion_store/domain/controller/controllerNotificacion.dart';
import 'package:acfashion_store/domain/controller/controllerPedido.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:background_sms/background_sms.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceScreen extends StatefulWidget {
  final bool controllerconectivity;
  final bool themeMode;
  final List<Map<String, dynamic>> carrito;
  final Map<String, dynamic> perfil;
  final url;
  final nombre;
  final correo;
  final telefono;
  final total;
  final selectedCategoryName;
  final direccion;

  InvoiceScreen(
      {super.key,
      required this.themeMode,
      required this.controllerconectivity,
      required this.carrito,
      required this.perfil,
      this.url,
      this.nombre,
      this.correo,
      this.telefono,
      this.total,
      this.selectedCategoryName,
      this.direccion});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  ControlNotificacion controln = ControlNotificacion();
  ControlPedido controlpd = ControlPedido();
  String idUser = '';
  bool isDarkMode = false;
  bool _controllerconectivity = false;
  List<Map<String, dynamic>> carrito = [];
  Map<String, dynamic> perfil = {};
  var url;
  var nombre;
  var correo;
  var telefono;
  var total;
  var selectedCategoryName;
  var direccion;

  Future<void> _showProcessingDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: MyColors.myPurple,
              ),
              Text('Procesando compra...',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      decoration: TextDecoration.none,
                      fontSize: 18)),
            ],
          ),
        ));
      },
    );

    // Espera 2 segundos antes de cerrar el AlertDialog
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop(); // Cierra el AlertDialog
    Navigator.of(context).pop(); // Cierra el InvoiceScreen
    Navigator.of(context).pop(); // Cierra el GoogletMapScreen
    Navigator.of(context).pop(); // Cierra el PaymentScreen
    Navigator.of(context).pop(); // Cierra el ShopScreen
  }

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

  //envia el comprobante de compra
  Future<void> enviarComprobanteCompra(telefono, mensaje) async {
    print("Enviando codigo");
    print(telefono);
    print(mensaje);
    SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: telefono,
      message: mensaje,
    );
    if (result == SmsStatus.sent) {
      print("Sent");
    } else {
      print("Failed");
    }
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    isDarkMode = widget.themeMode;
    _controllerconectivity = widget.controllerconectivity;
    carrito = widget.carrito;
    perfil = widget.perfil;
    print("PERFIL DESDE GOOGLE MAPS: $perfil");
    idUser = perfil['uid'];
    url = widget.url;
    nombre = widget.nombre;
    correo = widget.correo;
    telefono = widget.telefono;
    total = widget.total;
    selectedCategoryName = widget.selectedCategoryName;
    direccion = widget.direccion;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Factura de compra',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
            SizedBox(height: 20),
            Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text('Datos de comprador',
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(height: 10),
                      NewImage(
                          controller: _controllerconectivity,
                          img: url,
                          text: ''),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Nombre: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(nombre ?? 'No registrado',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Correo: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(correo ?? 'No registrado',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Telefono: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(telefono ?? 'No registrado',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  child: Column(
                    children: [
                      Text('Datos de compra',
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Productos a pagar: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          carrito.length > 1
                              ? Text('${carrito.length}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ))
                              : Text('${carrito.length}',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Total a pagar: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('${total}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Metodo de pago: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('$selectedCategoryName',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Fecha de compra: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text(
                              '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Hora de compra: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('${getFormattedTime()}',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Estado de entrega: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('Pendiente',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Tiempo de entrega: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('4 a 10 horas',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Direccion: ',
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Expanded(
                            child: Text(direccion ?? "No registrado",
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    var pedido = {
                      'iduser': idUser,
                      'nombre': nombre,
                      'correo': correo,
                      'celular': telefono,
                      'foto': url,
                      'direccion': direccion,
                      'cantidad': carrito.length,
                      'total': total,
                      'metodoPago': selectedCategoryName,
                      'fechaCompra':
                          '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      'horaCompra': '${getFormattedTime()}',
                      'estadoEntrega': 'Pendiente',
                      'tiempoEntrega': '4 a 10 horas',
                    };
                    controlpd
                        .agregarPedido(pedido, carrito, perfil, widget.total)
                        .then((value) {
                      var notificacion = {
                        'iduser': idUser,
                        'titulo': "Pedido realizado",
                        'descripcion':
                            "Su pedido se ha hecho con exito, pronto le notificaremos cuando su pedido este listo",
                        'tiempoEntrega': '4 a 10 horas',
                        'estado': "Pendiente",
                        'hora': '${getFormattedTime()}',
                        'fecha':
                            '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                      };
                      controln.agregarNotificacion(notificacion);
                    });
                    enviarComprobanteCompra(telefono,
                        "¡Gracias por comprar en AC Fashion Store!. Su pedido se ha hecho con exito, pronto le notificaremos cuando su pedido este listo");
                    _showProcessingDialog();
                  },
                  child: Text('Aceptar'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 40),
                    backgroundColor: MyColors.myPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
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
              radius: 60,
              backgroundImage: NetworkImage(img),
            )
          : CircleAvatar(
              radius: 60,
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
        radius: 60,
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
