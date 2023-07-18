import 'dart:async';
import 'package:connectivity/connectivity.dart';

class PeticionesConectividad {
  static Future<dynamic> verficarConectividad() async {
    try {
      bool _controllerconectivity = false;
      final response = await Connectivity().checkConnectivity();
      if (response == ConnectivityResult.none) {
        _controllerconectivity = false;
      } else {
        _controllerconectivity = true;
      }
      return _controllerconectivity;
    } catch (error) {
      print('Error en la operación de verficarconectividad: $error');
      throw error;
    }
  }
}
