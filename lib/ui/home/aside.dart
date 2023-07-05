import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Aside extends StatefulWidget {
  final String nombre;
  final String correo;
  final String telefono;
  final String direccion;
  final String foto;
  final String profesion;
  const Aside(
      {Key? key,
      required this.nombre,
      required this.correo,
      required this.telefono,
      required this.direccion,
      required this.foto,
      required this.profesion})
      : super(key: key);

  @override
  State<Aside> createState() => _AsideState();
}

class _AsideState extends State<Aside> {
  ControlUserAuth controlua = ControlUserAuth();
  ControlUserPerfil controlup = ControlUserPerfil();
  var nombre = '';
  var correo = '';
  var telefono = '';
  var direccion = '';
  var foto = '';
  var profesion = '';

  void initState() {
    super.initState();
    nombre = widget.nombre;
    correo = widget.correo;
    telefono = widget.telefono;
    direccion = widget.direccion;
    foto = widget.foto;
    profesion = widget.profesion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menú',
            style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 5.0),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0),
                  NewImage(img: foto, text: ''),
                  SizedBox(height: 5.0),
                  //Contenedor de datos de sesión
                  // DropdownButton(
                  //   hint: Text('Seleccione un usuario'),
                  //   items: [],
                  //   onChanged: (value) {},
                  // ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        NewRow(
                            icon: Icons.work,
                            textOne: 'Profesion',
                            textTwo: profesion),
                        SizedBox(height: 5.0),
                        NewRow(
                          icon: Icons.person,
                          textOne: 'Nombre',
                          textTwo: nombre,
                        ),
                        SizedBox(height: 5.0),
                        NewRow(
                          icon: Icons.email,
                          textOne: 'Correo',
                          textTwo: correo,
                        ),
                        SizedBox(height: 5.0),
                        NewRow(
                          icon: Icons.phone,
                          textOne: 'Teléfono',
                          textTwo: telefono,
                        ),
                        SizedBox(height: 5.0),
                        NewRow(
                          icon: Icons.location_on,
                          textOne: 'Dirección',
                          textTwo: direccion,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Container(
                      child: Column(
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.black),
                                      Text(
                                        'Cambiar mis datos',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 5.0),
                      TextButton(
                          onPressed: () {
                            Get.find<ControlUserAuth>().cerrarSesion();
                            Get.offAllNamed('/login');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Icon(Icons.exit_to_app,
                                          color: Colors.black),
                                      Text(
                                        'Cerrar sesión',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
                ],
              ),
            ),
            SizedBox(height: 35.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.fill,
                  // width: 200,
                  height: 100,
                  alignment: Alignment.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String textOne;
  final String textTwo;

  NewRow({
    Key? key,
    required this.icon,
    required this.textOne,
    required this.textTwo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      icon: Icon(icon),
      alignment: Alignment.center,
      hint: Text(textOne,
          style: TextStyle(
            fontSize: 16.0,
          )),
      items: [
        DropdownMenuItem(
          child: Row(
            children: [
              SizedBox(width: 10.0),
              Text(textTwo,
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
      onChanged: (value) {
        print(value);
      },
    );
  }
}

class NewImage extends StatelessWidget {
  final dynamic img;
  final String text;

  NewImage({
    Key? key,
    required this.text,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (img != null && Uri.parse(img).isAbsolute) {
      // Si img es una URL válida, carga la imagen desde la URL
      imageWidget = CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(img),
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
