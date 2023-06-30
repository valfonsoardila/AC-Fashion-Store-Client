import 'dart:async';
import 'package:acfashion_store/domain/controller/controllerUserControlUserAuthSupabase.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Peticiones {
  static final ControlUserAuth controlua = Get.find();
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearcatalogo(
      Map<String, dynamic> catalogo, foto) async {
    try {
      var url = '';
      if (foto != null) {
        url = await Peticiones.cargarfoto(foto, controlua.userValido!.id);
      }
      print(url);
      catalogo['foto'] = url.toString();
      await _client.from('perfil').insert([catalogo]);
      return true;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error;
    }
  }

  static Future<dynamic> actualizarcatalogo(
      Map<String, dynamic> catalogo, foto) async {
    var url = '';
    if (foto != null) {
      url = await Peticiones.cargarfoto(
          foto, catalogo['nombre'] + catalogo['apellido']);
    }
    print(url);
    catalogo['foto'] = url.toString();
    await _client.from('perfil').update(catalogo).eq('id', catalogo['id']);
    return true;
  }

  static Future<dynamic> eliminarcatalogo(Map<String, dynamic> catalogo) async {
    await _client.from('perfil').delete().eq('id', catalogo['id']);
    return true;
  }

  static Future<Map<String, dynamic>> obtenercatalogo(id) async {
    final response =
        await _client.from('perfil').select().eq('id', id).single();
    if (response.error == null && response.data != null) {
      return response.data!;
    } else {
      return {};
    }
  }

  static Future<dynamic> cargarfoto(var foto, var idArt) async {
    final storage = _client.storage;
    final folderPath = 'fotos'; // Carpeta donde deseas almacenar las fotos
    final fileName = '$idArt.png'; // Nombre del archivo
    try {
      final response = await storage
          .from(folderPath)
          .uploadBinary(fileName, foto.readAsBytesSync());
    } catch (e) {
      print('Error en la operación de carga de foto: $e');
    }
  }
}
