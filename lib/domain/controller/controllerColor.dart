import 'package:acfashion_store/data/services/peticionesColor.dart';
import 'package:get/get.dart';

class ControlColor extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<void> agregarColor(Map<String, dynamic> color) async {
    _response.value = await PeticionesColor.crearColor(color);
    await controlColor(_response.value);
    return _response.value;
  }

  Future<List<Map<String, dynamic>>> obtenerColores(String uid) async {
    _response.value = await PeticionesColor.obtenerColores(uid);
    await controlColor(_response.value);
    return _response.value;
  }

  Future<void> eliminarColor(String id) async {
    _response.value = await PeticionesColor.eliminarColor(id);
    await controlColor(_response.value);
    return _response.value;
  }

  Future<void> controlColor(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      _Datos.value = respuesta;
      print("datos del color en el controlador: $_Datos");
    }
  }

  List<Map<String, dynamic>> get datosColores => _Datos?.value ?? [];
  dynamic get estadoColor => _response.value;
  String get mensajesColor => _mensaje.value;
}
