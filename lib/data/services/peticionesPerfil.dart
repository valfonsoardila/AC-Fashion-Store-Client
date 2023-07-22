import 'dart:async';
import 'dart:io';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeticionesPerfil {
  static final ControlUserAuth controlua = Get.find();
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<Map<String, dynamic>> buscarcorreo(String email) async {
    try {
      Map<String, dynamic> perfil = {};
      final correo = email.toLowerCase();
      final tableName = 'perfil';
      final response =
          await _client.from(tableName).select('*').eq('correo', correo);
      print("esta es la respuesta: $response");
      if (response.isEmpty) {
        print("esta vacio");
        perfil = {};
      } else {
        print("no esta vacio");
        perfil = response[0];
      }
      return perfil;
    } catch (error) {
      print('Error en la operación buscar correo: $error');
      throw error;
    }
  }

  static Future<dynamic> crearperfil(Map<String, dynamic> perfil, foto) async {
    try {
      var url = '';
      if (foto != null) {
        url = await PeticionesPerfil.cargarfoto(foto, controlua.userValido!.id);
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
      var id = perfil['id'];
      String fileName = '$id/profile.png'; // Nombre del archivo
      var url = '';
      if (foto != null) {
        if (perfil['foto'] != '') {
          final prueba = await PeticionesPerfil.actualizarfoto(foto, id);
          print("esta es la respuesta de la actualizacion de foto: $prueba");
        } else {
          url = await PeticionesPerfil.cargarfoto(foto, id);
          print("esta es la url de la foto guardad: $url");
          perfil['foto'] = url.toString();
        }
        perfil['foto'] = fileName;
      }
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
      final file = File(foto.path);
      String fileName = 'profile.png';
      final String path = await storage.from(bucketName).update(
            '$idArt/$fileName',
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      print("este es el path: $path");
      final response = path;
      print("esta es la respuesta de la actualizacion de foto: $response");
      return response;
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
      String fileName = '$id/profile.png'; // Nombre del archivo
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
    final bucketName = 'perfil'; // Carpeta donde deseas almacenar las fotos
    String fileName = 'profile.png';
    final file = File(foto.path);
    try {
      final String path = await instance.from(bucketName).upload(
            '$idArt/$fileName',
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
