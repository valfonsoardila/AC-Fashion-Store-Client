import 'package:acfashion_store/data/services/peticionesFavorito.dart';
import 'package:get/get.dart';

class ControlFavoritos extends GetxController {
  final _response = Rxn();
  final _Datos = Rxn();
  final _mensaje = "".obs;

  Future<void> agregarfavorito(Map<String, dynamic> producto) async {
    _response.value = await PeticionesFavorito.crearFavorito(producto);
    await controlProducto(_response.value);
    return _response.value;
  }

  Future<List<Map<String, dynamic>>> obtenerfavoritos(String uid) async {
    _response.value = await PeticionesFavorito.obtenerFavoritos(uid);
    await controlProducto(_response.value);
    return _response.value;
  }

  Future<void> eliminarfavorito(String id) async {
    _response.value = await PeticionesFavorito.eliminarFavorito(id);
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

  List<Map<String, dynamic>> get datosFavoritos => _Datos?.value ?? [];
  dynamic get estadoFavorito => _response.value;
  String get mensajesFavorio => _mensaje.value;
}
