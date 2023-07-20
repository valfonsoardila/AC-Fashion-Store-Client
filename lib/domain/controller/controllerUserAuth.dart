import 'package:acfashion_store/data/services/peticionesUserSupabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa el paquete supabase_flutter
import 'package:get/get.dart';

class ControlUserAuth extends GetxController {
  final _response = Rxn();
  final _mensaje = "".obs;
  final Rxn<User> _usuario = Rxn<User>();
  final Rxn<String> _uid = Rxn<String>();
  final Rxn<Session> _sesion =
      Rxn<Session>(); // Usa Session en lugar de UserCredential

  Future<void> crearUser(String email, String pass) async {
    _response.value = await Peticioneslogin.register(email,
        pass); // Reemplaza Peticioneslogin con tu servicio de peticiones para Supabase
    await controlUser(_response.value);
  }

  Future<void> consultarUser() async {
    _response.value = await Peticioneslogin
        .obtenerUsurioLogueado(); // Reemplaza Peticioneslogin con tu servicio de peticiones para Supabase
    await controlUser(_response.value);
    return _response.value;
  }

  Future<void> consultarSesion() async {
    _response.value = await Peticioneslogin
        .obtenerDatosSesion(); // Reemplaza Peticioneslogin con tu servicio de peticiones para Supabase
    print(_response.value);
    await controlUser(_response.value);
  }

  Future<dynamic> ingresarUser(String email, String pass) async {
    _response.value = await Peticioneslogin.login(email,
        pass); // Reemplaza Peticioneslogin con tu servicio de peticiones para Supabase
    print(_response.value);
    await controlUser(_response.value);
  }

  Future<void> restablecercontrasena(String correo) async {
    _response.value = await Peticioneslogin.restablecerContrasena(correo);
    await controlUser(_response.value);
    return _response.value;
  }

  Future<void> cerrarSesion() async {
    _response.value = await Peticioneslogin
        .cerrarSesion(); // Reemplaza Peticioneslogin con tu servicio de peticiones para Supabase
    print(_response.value);
    await controlUser(_response.value);
  }

  Future<void> controlUser(dynamic respuesta) async {
    if (respuesta == null) {
      _sesion.value = null;
      _mensaje.value = "Por favor intente de nuevo";
    } else if (respuesta == "existe") {
      _response.value = null;
      _mensaje.value = "Por favor intente de nuevo";
    } else {
      if (respuesta == {}) {
        _usuario.value = null;
        _mensaje.value = "Por favor intente de nuevo";
      } else {
        _mensaje.value = "Proceso exitoso";
        if (respuesta is User) {
          print("Si es un usuario");
          _usuario.value = respuesta;
          _uid.value = _usuario.value!.id;
          _sesion.value = null;
          print("Este es el uid: ${_usuario.value!.id}");
        } else if (respuesta is Session) {
          _sesion.value = respuesta;
        }
      }
    }
  }

  dynamic get estadoUser => _response.value;
  String get mensajesUser => _mensaje.value;
  String? get uidValido => _uid.value; // Usa User en lugar de UserCredential
  User? get userValido => _usuario.value; // Usa User en lugar de UserCredential
  Session? get sesionValida =>
      _sesion.value; // Usa Session en lugar de UserCredential
}
