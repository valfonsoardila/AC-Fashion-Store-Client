import 'dart:async';
import 'dart:io';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class Peticiones {
  static final ControlUserAuth controlua = Get.find();
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearperfil(Map<String, dynamic> perfil, foto) async {
    try {
      var url = '';
      if (foto != null) {
        url = await Peticiones.cargarfoto(foto, controlua.userValido!.id);
        print('esta es la url de la foto: $url');
      }
      perfil['foto'] = url.toString();
      await _client.from('perfil').insert([perfil]);
      return true;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error;
    }
  }

  static Future<Map<String, dynamic>> actualizarperfil(
      Map<String, dynamic> perfil, foto) async {
    try {
      final tableName = 'perfil';
      final id = perfil['id'];
      var url = '';
      if (foto != null) {
        print("esta es la foto que llego a peticiones: $foto");
        if (perfil['foto'] != null) {
          url = await Peticiones.actualizarfoto(foto, id);
        } else {
          url = await Peticiones.cargarfoto(foto, id);
        }
      }
      perfil['foto'] = url.toString();
      await _client.from(tableName).update(perfil).eq('id', id);
      final perfilNuevo =
          await _client.from(tableName).select('*').eq('id', id);
      print("esta es la respuesta de la actualizacion: ${perfilNuevo[0]}");
      return perfilNuevo[0];
    } catch (error) {
      print('Error en la operación de actualización de perfil: $error');
      throw error;
    }
  }

  static Future<dynamic> actualizarfoto(var foto, var idArt) async {
    try {
      final storage = _client.storage;
      final bucketName = 'perfil';
      final fileName = '$idArt.png';
      final fotoPerfil = File(foto);
      final String path = await storage.from(bucketName).update(
            fileName,
            fotoPerfil,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      return path;
    } catch (e) {
      print('Error en la operación de actualización de foto: $e');
    }
  }

  static Future<dynamic> eliminarperfil(Map<String, dynamic> perfil) async {
    await _client.from('perfil').delete().eq('id', perfil['id']);
    return true;
  }

  static Future<Map<String, dynamic>> obtenerperfil(id) async {
    try {
      print("Esta es la uid a consultar: $id");
      var response = null;
      final instance = _client.storage; // Instancia de SupabaseStorage
      final folderPath = 'perfil'; // Carpeta donde deseas almacenar las fotos
      Map<String, dynamic> perfil = {}; // Lista de perfiles
      String fileName = '$id.png'; // Nombre del archivo
      if (id.isNotEmpty) {
        //Intenta obtener el perfil
        response = await _client
            .from(folderPath)
            .select('*')
            .eq('id', id); //Filtra el perfil por id
        print("esta es la consulta: ${response[0]}");
        var foto = response[0]["foto"].toString();
        if (foto.isNotEmpty) {
          print("si hay foto: ${response[0]["foto"]}");
          //Si la respuesta no es una url vacia
          final image = await instance
              .from(folderPath)
              .getPublicUrl(fileName); //Obtiene la url de la imagen
          response![0]['foto'] =
              image; //Agrega la url de la imagen al perfil //Convierte la respuesta en una lista de mapas
        } else {
          print("no hay foto");
        }
      }
      perfil = response[0]; //Agrega el perfil a la lista de perfiles
      return perfil; //Retorna el perfil
    } catch (e) {
      print("error en la peticion desde consulta de perfil:$e");
      return {};
    }
  }

  static Future<dynamic> cargarfoto(var foto, var idArt) async {
    final instance = _client.storage;
    final folderPath = 'perfil'; // Carpeta donde deseas almacenar las fotos
    String fileName = '$idArt.png';
    final file = File(foto.path);
    try {
      final String path = await instance.from(folderPath).upload(
            fileName,
            file,
            fileOptions: FileOptions(cacheControl: '3600', upsert: false),
          );
      final response = path;
      return response;
    } catch (e) {
      print('Error en la operación de carga de foto: $e');
    }
  }
}