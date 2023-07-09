import 'package:acfashion_store/data/services/peticionesUserSupabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa el paquete supabase_flutter
import 'package:get/get.dart';

class ControlUserAuth extends GetxController {
  final _response = Rxn();
  final _mensaje = "".obs;
  final Rxn<User> _usuario = Rxn<User>();
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

  Future<void> restablecercontrasena(String password) async {
    _response.value = await Peticioneslogin.restablecerContrasena(password);
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
      _mensaje.value = "Por favor intente de nuevo";
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
    } else {
      _mensaje.value = "Proceso exitoso";
      if (respuesta is User) {
        _usuario.value = respuesta;
        _sesion.value = null;
      } else if (respuesta is Session) {
        _sesion.value = respuesta;
      }
    }
  }

  dynamic get estadoUser => _response.value;
  String get mensajesUser => _mensaje.value;
  User? get userValido => _usuario.value; // Usa User en lugar de UserCredential
  Session? get sesionValida =>
      _sesion.value; // Usa Session en lugar de UserCredential
}
