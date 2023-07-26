import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class PeticionesColor {
  static final ControlUserAuth controlua = Get.find();
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearColor(color) async {
    final response = await _client.from('colores').insert(color);
    if (response.error == null) {
      return response.data;
    } else {
      return response.error.message;
    }
  }

  static Future<dynamic> obtenerColores(uid) async {
    final response =
        await _client.from('colores').select().order('id', ascending: false);
    if (response.error == null) {
      return response.data;
    } else {
      return response.error.message;
    }
  }

  static Future<dynamic> eliminarColor(String id) async {
    final response = await _client.from('colores').delete().eq('id', id);
    if (response.error == null) {
      return response.data;
    } else {
      return response.error.message;
    }
  }
}
