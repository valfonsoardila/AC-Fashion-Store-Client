import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key? key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ControlUserAuth controlua = Get.find();
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
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
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/icons/icon.png',
                      width:
                          130, // Ajusta el ancho de la imagen según tus necesidades
                      height:
                          130, // Ajusta la altura de la imagen según tus necesidades
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'AC Fashion Store',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 124, 12, 131),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.0),
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
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: pass,
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
                      obscureText: true,
                    ),
                    SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        //Proceso de validación de usuario
                        controlua.estadoUser == null;
                        controlua.userValido == null;
                        _initConnectivity();
                        if (_controllerconectivity == true) {
                          if (user.text == "" && pass.text == "") {
                            Get.snackbar(
                                "No ha ingresado su correo electronico, ni su contraseña",
                                "Por favor ingrese su correo y contraseña");
                          } else if (user.text == "") {
                            Get.snackbar(
                                "No ha ingresado su correo electronico",
                                "Por favor ingrese su correo");
                          } else if (pass.text == "") {
                            Get.snackbar("No ha ingreado su contraseña",
                                "por favor ingrese una contraseña");
                          } else {
                            controlua
                                .ingresarUser(user.text, pass.text)
                                .then((value) {
                              if (controlua.userValido == null) {
                                Get.snackbar("Este usuario no esta registrado",
                                    controlua.mensajesUser,
                                    duration: Duration(seconds: 2));
                              } else {
                                if (controlua.sesionValida != null) {
                                  // Get.snackbar("Ha iniciado sesión correctamente",
                                  //     controlua.mensajesUser,
                                  //     duration:  Duration(seconds: 4),
                                  //     backgroundColor:
                                  //          Color.fromARGB(255, 73, 73, 73));
                                  // controlua.userValido!.user?.uid;
                                  String uid = controlua.sesionValida!.user.id;
                                  Get.toNamed("/principal", arguments: uid);
                                  // Get.to(Home(uid: uid));
                                }
                              }
                            });
                          }
                        } else {
                          Get.snackbar("No hay conexión a internet",
                              "Por favor conectese a una red");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 124, 12, 131),
                        textStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      child: Text(
                        'Iniciar sesión',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed("/register");
                            },
                            child: Text(
                              'Registrarse',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: _isDarkMode != false
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed("/restaurar");
                            },
                            child: Text(
                              'Restaurar contraseña',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
