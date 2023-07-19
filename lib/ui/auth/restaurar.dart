import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/ui/models/theme_model.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Restaurar extends StatefulWidget {
  Restaurar({super.key});

  @override
  State<Restaurar> createState() => _RestaurarState();
}

class _RestaurarState extends State<Restaurar> {
  ControlUserPerfil controlp = ControlUserPerfil();
  ControlUserAuth controlua = ControlUserAuth();
  TextEditingController controlId = TextEditingController();
  TextEditingController controlContrasena = TextEditingController();
  Map<String, dynamic> datos = {};
  bool _showPassword = false;

  bool _isDarkMode = false;

  // void _cambiarContrasena(Map<String, dynamic> data) async {
  //   controlContrasena.text = datos['contrasena'] ?? '';
  //   controlId.text = datos['id'] ?? '';
  //   var contrasena = datos['contrasena'] ?? '';
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return AlertDialog(
  //             backgroundColor: Colors.white,
  //             title: Text(
  //               'Datos de Perfil',
  //               style: TextStyle(color: Colors.black),
  //             ),
  //             content: Container(
  //               color: Colors.white,
  //               padding: EdgeInsets.all(10.0),
  //               child: SingleChildScrollView(
  //                 child: Container(
  //                   color: Colors.white,
  //                   padding: EdgeInsets.all(5.0),
  //                   child: Center(
  //                     child: Column(
  //                       children: [
  //                         Text(
  //                           'Datos de acceso',
  //                           style: TextStyle(
  //                               color: Color.fromARGB(255, 29, 29, 29)),
  //                         ),
  //                         SizedBox(height: 12.0),
  //                         SizedBox(height: 8.0),
  //                         TextFormField(
  //                           controller: controlContrasena,
  //                           style: TextStyle(
  //                               color: Color.fromARGB(255, 29, 29, 29)),
  //                           obscureText: !_showPassword,
  //                           decoration: InputDecoration(
  //                             focusedBorder: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(10),
  //                               borderSide:
  //                                   BorderSide(color: MyColors.myPurple),
  //                             ),
  //                             enabledBorder: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(10),
  //                               borderSide: BorderSide(
  //                                   color: Color.fromARGB(255, 29, 29, 29)),
  //                             ),
  //                             labelText: 'Contraseña',
  //                             labelStyle: TextStyle(
  //                                 color: Color.fromARGB(255, 29, 29, 29)),
  //                             prefixIcon: Icon(Icons.lock, color: Colors.black),
  //                             suffixIcon: IconButton(
  //                               icon: Icon(
  //                                 _showPassword
  //                                     ? Icons.visibility
  //                                     : Icons.visibility_off,
  //                                 color: Colors.black,
  //                               ),
  //                               onPressed: () {
  //                                 setState(() {
  //                                   _showPassword = !_showPassword;
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                           validator: (value) {
  //                             if (value == null || value.isEmpty) {
  //                               return 'Por favor ingrese su contraseña';
  //                             }
  //                             return null;
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   // Lógica para guardar los cambios realizados en el perfil
  //                   Navigator.of(context).pop();
  //                   var perfil = <String, dynamic>{
  //                     'id': datos['id'] ?? '',
  //                     'foto': datos['foto'] ?? '',
  //                     'correo': datos['correo'] ?? '',
  //                     'contrasena': controlContrasena.text,
  //                     'nombre': datos['nombre'] ?? '',
  //                     'profesion': datos['profesion'] ?? '',
  //                     'direccion': datos['direccion'] ?? '',
  //                     'celular': datos['celular'] ?? '',
  //                   };
  //                   controlp.actualizarperfil(perfil, null).then((value) {
  //                     if (controlp.mensajesPerfil == "Proceso exitoso" &&
  //                         controlContrasena.text != "" &&
  //                         controlContrasena.text != contrasena) {
  //                       controlua.restablecercontrasena(controlContrasena.text);
  //                       Get.snackbar("Perfil Guardado Correctamente",
  //                           controlp.mensajesPerfil,
  //                           duration: Duration(seconds: 4),
  //                           backgroundColor: Color.fromARGB(255, 73, 73, 73));
  //                       Get.toNamed("/login");
  //                     } else {
  //                       if (controlp.mensajesPerfil == "Proceso exitoso") {
  //                         Get.snackbar("Perfil Guardado Correctamente",
  //                             controlp.mensajesPerfil,
  //                             duration: Duration(seconds: 4),
  //                             backgroundColor: Color.fromARGB(255, 73, 73, 73));
  //                         Get.offAllNamed("/principal",
  //                             arguments: controlId.text);
  //                       } else {
  //                         Get.snackbar("Error al guardar el perfil",
  //                             controlp.mensajesPerfil,
  //                             duration: Duration(seconds: 4),
  //                             backgroundColor: Color.fromARGB(255, 73, 73, 73));
  //                         Navigator.of(context).pop();
  //                       }
  //                     }
  //                   });
  //                 },
  //                 child: Text('Guardar', style: TextStyle(color: Colors.black)),
  //               ),
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //                 child:
  //                     Text('Cancelar', style: TextStyle(color: Colors.black)),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController user = TextEditingController();
    final theme = Provider.of<ThemeChanger>(context);
    var temaActual = theme.getTheme();
    if (temaActual == ThemeData.dark()) {
      _isDarkMode = true;
    } else {
      _isDarkMode = false;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: _isDarkMode ? Colors.white : Colors.black,
            )),
        backgroundColor: _isDarkMode ? Colors.black : Colors.white,
        elevation: 0, // Eliminar la sombra del AppBar
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Container(
                color: _isDarkMode ? Colors.black : Colors.white,
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 40.0),
                      child: Text(
                        '¿Has olvidado tu contraseña?',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: _isDarkMode != false
                              ? Colors.white
                              : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        'Introduce el correo electronico asociado\na tu cuenta y te enviaremos un codigo de verificacion',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
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
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (user.text.isNotEmpty) {
                          controlua
                              .restablecercontrasena(user.text)
                              .then((value) {
                            if (controlua.mensajesUser == "Proceso exitoso") {
                              // datos = controlp.datosPerfil;
                              //_cambiarContrasena(datos);
                              Get.snackbar(
                                "Correo enviado",
                                "Se ha enviado un correo a su cuenta",
                                duration: Duration(seconds: 4),
                              );
                            } else {
                              Get.snackbar(
                                "Correo no registrado",
                                "Por favor intente de nuevo",
                                duration: Duration(seconds: 4),
                              );
                            }
                          });
                        } else {
                          Get.snackbar(
                            "No ha ingresado un correo",
                            "Por favor intente de nuevo",
                            duration: Duration(seconds: 4),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 124, 12, 131),
                        textStyle: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      child: Text(
                        'Enviar enlace',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
