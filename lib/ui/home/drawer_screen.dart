import 'dart:async';
import 'dart:io';

import 'package:acfashion_store/domain/controller/controllerConectivity.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  final String uid;
  final String correo;
  final String contrasena;
  final String nombre;
  final String profesion;
  final String direccion;
  final String celular;
  final String foto;
  DrawerScreen({
    Key? key,
    required this.uid,
    required this.correo,
    required this.contrasena,
    required this.nombre,
    required this.profesion,
    required this.direccion,
    required this.celular,
    required this.foto,
  }) : super(key: key);
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  ControlConectividad controlconect = ControlConectividad();
  bool _controllerconectivity = false;
  ControlUserAuth controlua = Get.find();
  ControlUserPerfil controlPerfil = Get.find();
  TextEditingController controlId = TextEditingController();
  TextEditingController controlcorreo = TextEditingController();
  TextEditingController controlContrasena = TextEditingController();
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlProfesion = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  TextEditingController controlTelefono = TextEditingController();
  TextEditingController controlURL = TextEditingController();
  ImagePicker picker = ImagePicker();
  var _showPassword = false;
  var _image;
  var correo = "";
  var contrasena = "";
  var nombre = "";
  var profesion = "";
  var ciudad = "";
  var direccion = "";
  var celular = "";
  var foto = "";
  var uid = '';

  bool _isDarkMode = false;
  //FUNCIONES
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

  void _mostrarGestionPerfil() {
    controlId.text = uid;
    controlcorreo.text = correo;
    controlContrasena.text = contrasena;
    controlNombre.text = nombre;
    controlProfesion.text = profesion;
    controlDireccion.text = direccion;
    controlTelefono.text = celular;
    controlURL.text = foto;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                'Datos de Perfil',
                style: TextStyle(color: Colors.black),
              ),
              content: Container(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(5.0),
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _opcioncamara(context);
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                height: 220,
                                width: double.maxFinite,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0),
                                  ),
                                  child: _image != null
                                      ? Image.file(
                                          _image,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        )
                                      : CircleAvatar(
                                          radius: 60,
                                          backgroundImage: foto.isEmpty
                                              ? NetworkImage(
                                                  'https://cdn-icons-png.flaticon.com/512/149/149071.png')
                                              : NetworkImage(foto),
                                        ),
                                )),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Datos de acceso',
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 29, 29)),
                          ),
                          SizedBox(height: 12.0),
                          TextFormField(
                            controller: controlcorreo,
                            style: TextStyle(
                              color: Color.fromARGB(255, 29, 29, 29),
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: MyColors.myPurple),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 29, 29, 29)),
                              ),
                              labelText: 'correo electrónico',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 29, 29, 29),
                              ),
                              prefixIcon:
                                  Icon(Icons.email, color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: controlContrasena,
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 29, 29)),
                            obscureText: !_showPassword,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: MyColors.myPurple),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 29, 29, 29)),
                              ),
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 29, 29, 29)),
                              prefixIcon: Icon(Icons.lock, color: Colors.black),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese su contraseña';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            'Datos personales',
                            style: TextStyle(
                                color: Color.fromARGB(255, 29, 29, 29)),
                          ),
                          SizedBox(height: 12.0),
                          TextFormField(
                            controller: controlNombre,
                            style: TextStyle(
                              color: Color.fromARGB(255, 29, 29, 29),
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: MyColors.myPurple),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 29, 29, 29)),
                              ),
                              labelText: 'Nombre',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 29, 29, 29),
                              ),
                              prefixIcon: Icon(Icons.accessibility_new,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: controlProfesion,
                            style: TextStyle(
                              color: Color.fromARGB(255, 29, 29, 29),
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: MyColors.myPurple),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 29, 29, 29)),
                              ),
                              labelText: 'Profesión',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 29, 29, 29),
                              ),
                              prefixIcon: Icon(Icons.psychology_rounded,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: controlDireccion,
                            style: TextStyle(
                              color: Color.fromARGB(255, 29, 29, 29),
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: MyColors.myPurple),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 29, 29, 29)),
                              ),
                              labelText: 'Direccion',
                              labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 29, 29, 29)),
                              prefixIcon: Icon(
                                Icons.add_home_work,
                                color: Color.fromARGB(255, 29, 29, 29),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: controlTelefono,
                            style: TextStyle(
                              color: Color.fromARGB(255, 29, 29, 29),
                            ),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: MyColors.myPurple),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 29, 29, 29)),
                              ),
                              labelText: 'Celular',
                              labelStyle: TextStyle(
                                color: Color.fromARGB(255, 29, 29, 29),
                              ),
                              prefixIcon: Icon(Icons.phone_android,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 8.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Lógica para guardar los cambios realizados en el perfil
                    Navigator.of(context).pop();
                    var perfil = <String, dynamic>{
                      'id': controlId.text,
                      'foto': foto,
                      'correo': controlcorreo.text,
                      'contrasena': controlContrasena.text,
                      'nombre': controlNombre.text,
                      'profesion': controlProfesion.text,
                      'direccion': controlDireccion.text,
                      'celular': controlTelefono.text,
                    };
                    print("esta es la foto consultada desde el aside: $foto");
                    controlPerfil
                        .actualizarperfil(perfil, _image)
                        .then((value) {
                      if (controlPerfil.mensajesPerfil == "Proceso exitoso" &&
                          controlContrasena.text != "" &&
                          controlContrasena.text != contrasena) {
                        controlua.restablecercontrasena(controlContrasena.text);
                        Get.snackbar("Perfil Guardado Correctamente",
                            controlPerfil.mensajesPerfil,
                            duration: const Duration(seconds: 4),
                            backgroundColor:
                                const Color.fromARGB(255, 73, 73, 73));
                        Get.toNamed("/login");
                      } else {
                        if (controlPerfil.mensajesPerfil == "Proceso exitoso") {
                          Get.snackbar("Perfil Guardado Correctamente",
                              controlPerfil.mensajesPerfil,
                              duration: const Duration(seconds: 4),
                              backgroundColor:
                                  const Color.fromARGB(255, 73, 73, 73));
                          Get.offAllNamed("/principal",
                              arguments: controlId.text);
                        } else {
                          Get.snackbar("Error al guardar el perfil",
                              controlPerfil.mensajesPerfil,
                              duration: const Duration(seconds: 4),
                              backgroundColor:
                                  const Color.fromARGB(255, 73, 73, 73));
                          Navigator.of(context).pop();
                        }
                      }
                    });
                  },
                  child: Text('Guardar', style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      Text('Cancelar', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
        );
      },
    );
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

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    uid = widget.uid;
    correo = widget.correo;
    contrasena = widget.contrasena;
    nombre = widget.nombre;
    profesion = widget.profesion;
    direccion = widget.direccion;
    celular = widget.celular;
    foto = widget.foto;
  }

  @override
  void dispose() {
    super.dispose();
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
    return Container(
      color: _isDarkMode != false
          ? Colors.grey[900]
          : Color.fromARGB(255, 247, 241, 241),
      child: Padding(
        padding: EdgeInsets.only(top: 50, left: 40, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/icons/icon.png',
                  width:
                      60, // Ajusta el ancho de la imagen según tus necesidades
                  height:
                      60, // Ajusta la altura de la imagen según tus necesidades
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  'AC Fashion Store',
                  style: TextStyle(
                      color: MyColors.myPurple,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            NewImage(controller: _controllerconectivity, img: foto, text: ''),
            NewRow(
              mode: _isDarkMode,
              textOne: 'Coreo electronico',
              icon: Icons.person_pin_rounded,
              textTwo: correo,
            ),
            NewRow(
              mode: _isDarkMode,
              textOne: 'Nombre de usuario',
              icon: Icons.person_outline,
              textTwo: nombre,
            ),
            SizedBox(
              height: 20,
            ),
            NewRow(
              mode: _isDarkMode,
              textOne: 'Profesion',
              icon: Icons.work_outline,
              textTwo: profesion,
            ),
            SizedBox(
              height: 20,
            ),
            NewRow(
              mode: _isDarkMode,
              textOne: 'Direccion',
              icon: Icons.home_outlined,
              textTwo: direccion,
            ),
            SizedBox(
              height: 20,
            ),
            NewRow(
              mode: _isDarkMode,
              textOne: 'Celular',
              icon: Icons.phone_outlined,
              textTwo: celular,
            ),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                _mostrarGestionPerfil();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 219, 54, 88),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Cambiar mis Datos',
                    style: TextStyle(color: Color.fromARGB(255, 219, 54, 88)),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  controlua.cerrarSesion();
                  // Get.snackbar(
                  //     "Abandonaste la sesion", controlua.mensajesUser,
                  //     duration:  Duration(seconds: 4),
                  //     backgroundColor:
                  //          Color.fromARGB(255, 73, 73, 73));
                  controlua.userValido == null && controlua.estadoUser == null
                      ? Get.offAllNamed("/home")
                      : Get.offAllNamed("/login");
                  controlua.userValido.val("");
                });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Color.fromARGB(255, 219, 54, 88).withOpacity(0.5),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Log out',
                    style: TextStyle(
                        color:
                            Color.fromARGB(255, 219, 54, 88).withOpacity(0.5)),
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

class NewRow extends StatelessWidget {
  final bool mode;
  final IconData icon;
  final String textOne;
  final String textTwo;

  bool _isDarkMode = false;

  NewRow({
    Key? key,
    required this.mode,
    required this.icon,
    required this.textOne,
    required this.textTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  // Lógica a ejecutar al presionar el botón
                },
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            icon,
                            color: _isDarkMode != false
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              textOne,
                              style: TextStyle(
                                color: Color.fromARGB(255, 219, 54, 88),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              textTwo,
                              style: TextStyle(
                                color: _isDarkMode != false
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
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
