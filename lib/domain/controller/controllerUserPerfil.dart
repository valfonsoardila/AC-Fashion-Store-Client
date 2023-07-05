import 'package:acfashion_store/data/services/peticionesPerfil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa el paquete supabase_flutter

class ControlUserPerfil extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;
  final Rxn<Session> _perfil =
      Rxn<Session>(); // Usa Session en lugar de UserCredential

  Future<void> crearperfil(Map<String, dynamic> perfil, foto) async {
    try {
      print("llego al controlador");
      _response.value = await Peticiones.crearperfil(perfil, foto);
      await controlPerfil(_response.value);
    } catch (error) {
      print('Error en la operación de registro: $error');
      await Future.delayed(Duration(seconds: 2)); // Esperar 2 segundos
      await crearperfil(perfil, foto); // Reintentar el registro
    }
  }

  Future<void> actualizarperfil(Map<String, dynamic> perfil, foto) async {
    _response.value = await Peticiones.actualizarperfil(perfil, foto);
    await controlPerfil(_response.value);
  }

  Future<void> eliminarperfil(Map<String, dynamic> perfil) async {
    _response.value = await Peticiones.eliminarperfil(perfil);
    await controlPerfil(_response.value);
  }

  Future<Map<String, dynamic>> obtenerperfil(String id) async {
    _response.value = await Peticiones.obtenerperfil(id);
    await controlPerfil(_response.value);
    return _response.value;
  }

  Future<void> controlPerfil(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      if (respuesta is Session) {
        // Usa Session en lugar de UserCredential
        _perfil.value = respuesta;
      } else {
        _Datos.value = respuesta;
      }
    }
  }

  Map<String, dynamic> get datosPerfil => _Datos.value;
  dynamic get estadoPerfil => _response.value;
  String get mensajesPerfil => _mensaje.value;
  Session? get perfilValido =>
      _perfil.value; // Usa Session en lugar de UserCredential
}
