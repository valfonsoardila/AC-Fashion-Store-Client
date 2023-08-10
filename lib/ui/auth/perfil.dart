// ignore_for_file: prefer__ructors, prefer_null_aware_operators
import 'dart:io';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Perfil extends StatefulWidget {
  Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  ControlUserPerfil controlup = Get.find();
  ControlUserAuth controlua = Get.find();
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlUser = TextEditingController();
  TextEditingController controlPass = TextEditingController();
  TextEditingController controlProfesion = TextEditingController();
  TextEditingController controlCiudad = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  TextEditingController controlCelular = TextEditingController();
  ImagePicker picker = ImagePicker(); // Lista de opciones
  List<String> registroSesion = [];
  String generoSeleccionado =
      'Masculino'; // Variable de estado para almacenar el valor seleccionado del género
  var generos = <String>[
    'Masculino',
    'Femenino',
    'Otro',
  ];
  @override
  var _image;

  bool _isDarkMode = false;

  bool _controllerconectivity = false;
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

  void initState() {
    super.initState();
    _initConnectivity();
    final args =
        Get.arguments; // Obtener los argumentos pasados desde la vista anterior
    registroSesion = args ?? "";
    controlNombre.text = registroSesion[0];
    controlUser.text = registroSesion[1];
    controlPass.text = registroSesion[2];
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
      backgroundColor: _isDarkMode != false ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 124, 12, 131),
        title: Text("Completar Perfil",
            style: TextStyle(
                color: _isDarkMode != false ? Colors.black : Colors.white)),
      ),
      body: Container(
        color: _isDarkMode != false ? Colors.black : Colors.white,
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: ListView(
            children: <Widget>[
              Center(
                child: GestureDetector(
                  onTap: () {
                    _opcioncamara(context);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                          : Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 12, 131)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color:
                            _isDarkMode != false ? Colors.white : Colors.black),
                  ),
                  labelText: controlua.userValido!.email,
                  labelStyle: TextStyle(
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                  prefixIcon: Icon(Icons.email,
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                ),
              ),
              TextFormField(
                controller: controlNombre,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 12, 131)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color:
                            _isDarkMode != false ? Colors.white : Colors.black),
                  ),
                  labelText: "Confirme su nombre",
                  labelStyle: TextStyle(
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                  prefixIcon: Icon(Icons.accessibility_new,
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: controlProfesion,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 12, 131)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color:
                            _isDarkMode != false ? Colors.white : Colors.black),
                  ),
                  labelText: 'Profesion',
                  labelStyle: TextStyle(
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                  prefixIcon: Icon(Icons.psychology_rounded,
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: controlCiudad,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 12, 131)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color:
                            _isDarkMode != false ? Colors.white : Colors.black),
                  ),
                  labelText: 'Ciudad',
                  labelStyle: TextStyle(
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                  prefixIcon: Icon(Icons.add_location,
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: controlDireccion,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 12, 131)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color:
                            _isDarkMode != false ? Colors.white : Colors.black),
                  ),
                  labelText: 'Direccion',
                  labelStyle: TextStyle(
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                  prefixIcon: Icon(Icons.add_home_work,
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                ),
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: controlCelular,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 254, 12, 131)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color:
                            _isDarkMode != false ? Colors.white : Colors.black),
                  ),
                  labelText: 'Celular',
                  labelStyle: TextStyle(
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                  prefixIcon: Icon(Icons.phone_android,
                      color:
                          _isDarkMode != false ? Colors.white : Colors.black),
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isDarkMode
                        ? Colors.white
                        : Colors
                            .black, // Puedes cambiar el color del borde aquí
                    width: 1.0, // Puedes ajustar el grosor del borde aquí
                  ),
                  borderRadius: BorderRadius.circular(
                      8.0), // Puedes ajustar la esquina redondeada aquí
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(
                        Icons.person, // Puedes cambiar el icono aquí
                        color: _isDarkMode != false
                            ? Colors.white
                            : Color.fromARGB(255, 254, 12, 131),
                      ),
                    ),
                    Expanded(
                      child: DropdownButton(
                        hint: Text(
                          'Valoracion',
                          style: TextStyle(
                            color: _isDarkMode != false
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        dropdownColor: _isDarkMode != false
                            ? Colors.grey[800]
                            : Colors.white,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black,
                        ),
                        iconSize: 36,
                        isExpanded: true,
                        underline: SizedBox(),
                        style: TextStyle(
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black,
                        ),
                        value: generoSeleccionado,
                        onChanged: (newValue) {
                          setState(() {
                            generoSeleccionado = newValue
                                .toString(); // Actualiza el valor seleccionado
                          });
                        },
                        items: generos.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  var perfil = <String, dynamic>{
                    'id': controlua.userValido!.id,
                    'foto': _image != null ? _image.path : null,
                    'correo': controlUser.text,
                    'contrasena': controlPass.text,
                    'estado': 'activo',
                    'nombre': controlNombre.text,
                    'genero': generoSeleccionado,
                    'profesion': controlProfesion.text,
                    'ciudad': controlCiudad.text,
                    'direccion': controlDireccion.text,
                    'celular': controlCelular.text,
                  };
                  if (_controllerconectivity == true) {
                    controlup.crearperfil(perfil, _image).then((value) => {
                          if (controlup.mensajesPerfil == "Proceso exitoso")
                            {
                              Get.snackbar(
                                "Perfil Guardado Correctamente",
                                controlup.mensajesPerfil,
                                duration: Duration(seconds: 2),
                              ),
                              Get.toNamed("/login"),
                            }
                          else
                            {
                              Get.snackbar(
                                "No se pudo guardar el perfil",
                                "Por favor, revise su conexion a internet",
                                duration: Duration(seconds: 2),
                              )
                            }
                        });
                  } else {
                    Get.snackbar(
                      "No se pudo guardar el perfil",
                      "Por favor, revise su conexion a internet",
                      duration: Duration(seconds: 2),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromARGB(255, 124, 12, 131),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                child: Text("Crear mi perfil",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

//Seleccionar la camara o la galeria

  void _opcioncamara(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
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
            ),
          );
        });
  }
}
