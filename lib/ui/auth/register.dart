import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isDarkMode = false;
  bool _controllerconectivity = false;
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
  }

  @override
  Widget build(BuildContext context) {
    //ControlUser controlu = Get.find();
    //ControlUserFirebase controlfb = Get.find();
    ControlUserAuth controlua = Get.find();
    TextEditingController nombre = TextEditingController();
    TextEditingController user = TextEditingController();
    TextEditingController pass = TextEditingController();
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }

    return Container(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: _isDarkMode != false ? Colors.black : Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: _isDarkMode != false ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 30),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.person,
                        color:
                            _isDarkMode != false ? Colors.white : Colors.black,
                        size: 40),
                    SizedBox(height: 10),
                    Text(
                      "Crear una Cuenta",
                      style: TextStyle(
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black,
                          fontSize: 33),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    right: 35,
                    left: 35,
                    top: MediaQuery.of(context).size.height * 0.27),
                child: Column(children: [
                  TextFormField(
                    controller: nombre,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 254, 12, 131)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: _isDarkMode != false
                                ? Colors.white
                                : Colors.black),
                      ),
                      labelText: 'Nombre completo',
                      labelStyle: TextStyle(
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black),
                      prefixIcon: Icon(Icons.supervised_user_circle,
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: user,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 254, 12, 131)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: _isDarkMode != false
                                ? Colors.white
                                : Colors.black),
                      ),
                      labelText: 'Correo electrónico',
                      labelStyle: TextStyle(
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black),
                      prefixIcon: Icon(Icons.email,
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: pass,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 254, 12, 131)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: _isDarkMode != false
                                ? Colors.white
                                : Colors.black),
                      ),
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black),
                      prefixIcon: Icon(Icons.lock,
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Registrarse',
                          style: TextStyle(
                            color: _isDarkMode != false
                                ? Colors.white
                                : Colors.black,
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Color.fromARGB(255, 124, 12, 131),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {
                              _initConnectivity();
                              if (_controllerconectivity == true) {
                                if (nombre.text.isEmpty &&
                                    user.text.isEmpty &&
                                    pass.text.isEmpty) {
                                  Get.snackbar(
                                    "Por favor llene todos los campos",
                                    controlua.mensajesUser,
                                    duration: Duration(seconds: 4),
                                  );
                                } else if (nombre.text.isEmpty) {
                                  Get.snackbar(
                                    "Por favor llene el campo de nombre",
                                    controlua.mensajesUser,
                                    duration: Duration(seconds: 4),
                                  );
                                } else if (user.text.isEmpty) {
                                  Get.snackbar(
                                    "Por favor llene el campo de correo",
                                    controlua.mensajesUser,
                                    duration: Duration(seconds: 4),
                                  );
                                } else if (pass.text.isEmpty) {
                                  Get.snackbar(
                                    "Por favor llene el campo de contraseña",
                                    controlua.mensajesUser,
                                    duration: Duration(seconds: 4),
                                  );
                                } else {
                                  controlua
                                      .crearUser(user.text, pass.text)
                                      .then((value) {
                                    if (controlua.estadoUser == null) {
                                      print('Error al registrar');
                                      Get.snackbar(
                                        "Esta cuenta ya existe",
                                        controlua.mensajesUser,
                                        duration: Duration(seconds: 2),
                                      );
                                    } else {
                                      if (controlua.mensajesUser ==
                                          'Proceso exitoso') {
                                        Get.snackbar(
                                          "¡Registrado Correctamente!",
                                          controlua.mensajesUser,
                                          duration: Duration(seconds: 4),
                                        );
                                        Get.toNamed("/perfil", arguments: [
                                          nombre.text,
                                          user.text,
                                          pass.text
                                        ]);
                                      }
                                    }
                                  });
                                }
                              } else {
                                Get.snackbar("No hay conexión a internet",
                                    "Por favor conectese a una red");
                              }
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ]),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/login');
                          },
                          child: Text(
                            'Inicio',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: _isDarkMode != false
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ]),
                ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
