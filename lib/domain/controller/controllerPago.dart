import 'package:acfashion_store/data/services/peticionesPago.dart';
import 'package:get/get.dart';

class ControlPago extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<void> agregarPago(Map<String, dynamic> pago) async {
    _response.value = await PeticionesPago.crearPago(pago);
    await controlPago(_response.value);
    return _response.value;
  }

  Future<List<Map<String, dynamic>>> obtenerPagos(String uid) async {
    _response.value = await PeticionesPago.obtenerPagos(uid);
    await controlPago(_response.value);
    return _response.value;
  }

  Future<void> eliminarPago(String id) async {
    _response.value = await PeticionesPago.eliminarPago(id);
    await controlPago(_response.value);
    return _response.value;
  }

  Future<void> controlPago(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      _Datos.value = respuesta;
      print("datos del pago en el controlador: $_Datos");
    }
  }

  List<Map<String, dynamic>> get datosPagos => _Datos?.value ?? [];
  dynamic get estadoPago => _response.value;
  String get mensajesPago => _mensaje.value;
}
