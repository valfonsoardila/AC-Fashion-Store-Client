import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Peticiones {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearProducto(
      Map<String, dynamic> producto, foto) async {
    try {
      var url = '';
      if (foto != null) {
        url = await Peticiones.cargarImagen(
            foto, producto['nombre'] + producto['apellido']);
      }
      producto['foto'] = url.toString();
      await _client.from('productos').insert([producto]);
      return true;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error;
    }
  }

  static Future<dynamic> obtenerproductos() async {
    final instance = _client.storage; // Instancia de SupabaseStorage
    final folderPath = 'productoes'; // Carpeta donde deseas almacenar las fotos
    List<Map<String, dynamic>> productos = []; // Lista de productoes
    try {
      //Intenta obtener los productos
      final response = await _client
          .from('productos')
          .select('*'); //Filtra el producto por id
      if (response != null) {
        // Si la respuesta no es nula
        for (var i = 0; i < response.length; i++) {
          final image = await instance.from(folderPath).getPublicUrl(
              response[i]['id'].toString() +
                  '.png'); //Obtiene la url de la imagen
          response[i]['foto'] =
              image; //Agrega la url de la imagen a cada producto
        }
        productos = List<Map<String, dynamic>>.from(
            response); //Convierte la respuesta en una lista de mapas
      }
      return productos; //Retorna los productos
    } catch (e) {
      print("error en la peticion:$e");
      return {};
    }
  }

  static Future<dynamic> filtrarproducto(id) async {
    final instance = _client.storage; // Instancia de SupabaseStorage
    final folderPath = 'productoes'; // Carpeta donde deseas almacenar las fotos
    List<Map<String, dynamic>> producto = []; // Lista de productoes
    String fileName = '$id.png'; // Nombre del archivo
    try {
      //Intenta obtener el producto
      final response = await _client
          .from('productos')
          .select('*')
          .eq('id', id); //Filtra el producto por id
      if (response != null) {
        // Si la respuesta no es nula
        final image = await instance
            .from(folderPath)
            .getPublicUrl(fileName); //Obtiene la url de la imagen
        response![0]['foto'] = image; //Agrega la url de la imagen al producto
        producto = List<Map<String, dynamic>>.from(
            response); //Convierte la respuesta en una lista de mapas
      }
      return producto; //Retorna el producto
    } catch (e) {
      print("error en la peticion:$e");
      return {};
    }
  }

  static Future<dynamic> cargarImagen(var foto, var idArt) async {
    final instance = _client.storage;
    final folderPath = 'productos'; // Carpeta donde deseas almacenar las fotos
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
