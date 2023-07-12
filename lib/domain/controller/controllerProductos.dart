import 'package:acfashion_store/data/services/peticionProductos.dart';
import 'package:get/get.dart';

class ControlProducto extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<void> agregarproducto(Map<String, dynamic> perfil, foto) async {
    _response.value = await Peticiones.crearProducto(perfil, foto);
    await controlProducto(_response.value);
    return _response.value;
  }

  Future<void> obtenerproductos() async {
    _response.value = await Peticiones.obtenerProductos();
    await controlProducto(_response.value);
    return _response.value;
  }

  Future<void> controlProducto(dynamic respuesta) async {
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

  List<Map<String, dynamic>> get datosProductos => _Datos?.value ?? [];
  dynamic get estadoProducto => _response.value;
  String get mensajesProducto => _mensaje.value;
}
