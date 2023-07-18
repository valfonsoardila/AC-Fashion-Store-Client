import 'package:acfashion_store/data/services/peticioonesConectividad.dart';
import 'package:get/get.dart';

class ControlConectividad {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<bool> verificarConexion() async {
    _response.value = await PeticionesConectividad.verficarConectividad();
    await controlConectividad(_response.value);
    return _response.value;
  }

  Future<void> controlConectividad(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      _Datos.value = respuesta;
      print("datos del productos en el controlador: $_Datos");
    }
  }

  bool get conexion => _Datos.value;
  dynamic get estadoConexiuion => _response.value;
  String get mensajesDeConexion => _mensaje.value;
}
