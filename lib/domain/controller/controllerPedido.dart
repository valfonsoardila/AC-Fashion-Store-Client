import 'package:acfashion_store/data/services/peticionesPedido.dart';
import 'package:get/get.dart';

class ControlPedido extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<void> agregarPedido(
      Map<String, dynamic> pedido,
      List<Map<String, dynamic>> carrito,
      Map<String, dynamic> perfil,
      int total) async {
    _response.value =
        await PeticionesPedido.crearPedido(pedido, carrito, perfil, total);
    await controlPedido(_response.value);
    return _response.value;
  }

  // Future<List<Map<String, dynamic>>> obtenerPedidos(String uid) async {
  //   _response.value = await PeticionesPedido.obtenerPedidos(uid);
  //   await controlPedido(_response.value);
  //   return _response.value;
  // }

  // Future<void> eliminarPedido(String id) async {
  //   _response.value = await PeticionesPedido.eliminarPedido(id);
  //   await controlPedido(_response.value);
  //   return _response.value;
  // }

  Future<void> controlPedido(dynamic respuesta) async {
    if (respuesta == null) {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else if (respuesta == "1" || respuesta == "2") {
      _mensaje.value = "Por favor intente de nuevo";
      print(_mensaje.value);
    } else {
      _mensaje.value = "Proceso exitoso";
      _Datos.value = respuesta;
      print("datos del pedido en el controlador: $_Datos");
    }
  }

  List<Map<String, dynamic>> get datosPedidos => _Datos?.value ?? [];
  dynamic get estadoPedido => _response.value;
  String get mensajesPedido => _mensaje.value;
}
