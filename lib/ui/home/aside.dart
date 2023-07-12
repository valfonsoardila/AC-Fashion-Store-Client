import 'package:acfashion_store/domain/controller/controllerUserPerfil.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:acfashion_store/ui/styles/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

class Aside extends StatefulWidget {
  final String id;
  final String nombre;
  final String correo;
  final String contrasena;
  final String telefono;
  final String direccion;
  final String foto;
  final String profesion;
  const Aside(
      {Key? key,
      required this.id,
      required this.nombre,
      required this.correo,
      required this.contrasena,
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
  var id = '';
  var nombre = '';
  var correo = '';
  var contrasena = '';
  var telefono = '';
  var direccion = '';
  var foto = '';
  var profesion = '';
  void initState() {
    super.initState();
    id = widget.id;
    nombre = widget.nombre;
    correo = widget.correo;
    contrasena = widget.contrasena;
    telefono = widget.telefono;
    direccion = widget.direccion;
    foto = widget.foto;
    profesion = widget.profesion;
  }

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
    controlId.text = id;
    controlcorreo.text = correo;
    controlContrasena.text = contrasena;
    controlNombre.text = nombre;
    controlProfesion.text = profesion;
    controlDireccion.text = direccion;
    controlTelefono.text = telefono;
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
                    controlup.actualizarperfil(perfil, _image).then((value) {
                      if (controlup.mensajesPerfil == "Proceso exitoso" &&
                          controlContrasena.text != "" &&
                          controlContrasena.text != contrasena) {
                        controlua.restablecercontrasena(controlContrasena.text);
                        Get.snackbar("Perfil Guardado Correctamente",
                            controlup.mensajesPerfil,
                            duration: const Duration(seconds: 4),
                            backgroundColor:
                                const Color.fromARGB(255, 73, 73, 73));
                        Get.toNamed("/login");
                      } else {
                        if (controlup.mensajesPerfil == "Proceso exitoso") {
                          Get.snackbar("Perfil Guardado Correctamente",
                              controlup.mensajesPerfil,
                              duration: const Duration(seconds: 4),
                              backgroundColor:
                                  const Color.fromARGB(255, 73, 73, 73));
                          Get.offAllNamed("/principal",
                              arguments: controlId.text);
                        } else {
                          Get.snackbar("Error al guardar el perfil",
                              controlup.mensajesPerfil,
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
      body: SingleChildScrollView(
        child: Container(
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
                            textOne: 'correo',
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
                            onPressed: () {
                              _mostrarGestionPerfil();
                            },
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
