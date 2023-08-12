import 'package:acfashion_store/data/services/peticionNotificacion.dart';
import 'package:get/get.dart';

class ControlNotificacion extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<void> agregarNotificacion(Map<String, dynamic> notificacion) async {
    _response.value =
        await PeticionesNotificacion.crearNotificacion(notificacion);
    await controlNotificacion(_response.value);
    return _response.value;
  }

  Future<void> actualizarNotificacion(Map<String, dynamic> notificacion) async {
    _response.value =
        await PeticionesNotificacion.actualizarNotificacion(notificacion);
    await controlNotificacion(_response.value);
    return _response.value;
  }

  Future<void> eliminarNotificacion(Map<String, dynamic> notificacion) async {
    _response.value =
        await PeticionesNotificacion.eliminarNotificacion(notificacion);
    await controlNotificacion(_response.value);
    return _response.value;
  }

  Future<List<Map<String, dynamic>>> filtrarNotificacion(String uid) async {
    print("uid en el controlador: $uid");
    _response.value = await PeticionesNotificacion.filtrarNotificacion(uid);
    await controlNotificacion(_response.value);
    return _response.value;
  }

  Future<List<Map<String, dynamic>>> obtenerNotificaciones() async {
    _response.value = await PeticionesNotificacion.obtenerNotificaciones();
    await controlNotificacion(_response.value);
    return _response.value;
  }

  Future<void> controlNotificacion(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      _Datos.value = respuesta;
      print("datos de notificaciones en el controlador: $_Datos");
    }
  }

  List<Map<String, dynamic>> get datosNotificaciones => _Datos?.value ?? [];
  dynamic get estadoNotificacion => _response.value;
  String get mensajesNotificacion => _mensaje.value;
}
