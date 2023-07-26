import 'package:acfashion_store/data/services/peticionesCompra.dart';
import 'package:get/get.dart';

class ControlCompra extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<void> agregarCompra(Map<String, dynamic> compra) async {
    _response.value = await PeticionesCompra.crearCompra(compra);
    await controlCompra(_response.value);
    return _response.value;
  }

  Future<List<Map<String, dynamic>>> obtenerCompras() async {
    _response.value = await PeticionesCompra.obtenerCompras();
    await controlCompra(_response.value);
    return _response.value;
  }

  Future<void> eliminarCompra(String id) async {
    _response.value = await PeticionesCompra.eliminarCompra(id);
    await controlCompra(_response.value);
    return _response.value;
  }

  Future<void> controlCompra(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      _Datos.value = respuesta;
      print("datos de compras en el controlador: $_Datos");
    }
  }

  List<Map<String, dynamic>> get datosCompras => _Datos?.value ?? [];
  dynamic get estadoCompra => _response.value;
  String get mensajesCompra => _mensaje.value;
}
