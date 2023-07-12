import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:acfashion_store/domain/controller/controllerProductos.dart';

class Peticiones {
  static final ControlProducto controlp = Get.find();
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearProducto(
      Map<String, dynamic> producto, foto) async {
    try {
      var url = '';
      if (foto != null) {
        url = await Peticiones.cargarImagen(foto);
      }
      producto['foto'] = url.toString();
      await _client.from('productos').insert([producto]);
      return true;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error;
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerProductos() async {
    try {
      final instance = _client.storage; // Instancia de Supabase Storage
      final folderPath =
          'producto'; // Carpeta donde estan almacenadas las fotos
      List<Map<String, dynamic>> productos = []; // Lista de productos
      var uids =
          await Peticiones.obtenerListaUids(); // Lista de uids de los productos
      for (int i = 0; i < uids.length; i++) {
        Map<String, dynamic> producto = {}; // Lista de productos
        var uid = ""; // Uid del producto
        var response = null; // Respuesta de la peticion
        uid = uids[i]['id'].toString(); // Obtiene el uid del producto
        var foto = ''; // Foto del producto
        var image = null; // Imagen del producto
        response = await _client
            .from(folderPath)
            .select('*')
            .eq('id', uid); // Filtra el producto por id
        foto = response[0]['foto'].toString(); // Obtiene la foto del producto
        print("esta es la foto de la base de datos: $foto");
        if (foto.isNotEmpty) {
          //Si la respuesta no es una url vacia
          image = await instance
              .from(folderPath)
              .getPublicUrl(foto); //Obtiene la url de la imagen
          print("esta es la imagen: $image");
          response[0]['foto'] = image; //Agrega la url de la imagen al perfil
        }
        producto = Map<String, dynamic>.from(response[0]);
        productos.add(producto);
      }
      return productos;
    } catch (e) {
      print("Error en la peticion:$e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerListaUids() async {
    List<Map<String, dynamic>> uids = [];
    try {
      final response = await _client.from('producto').select('id');
      uids = List<Map<String, dynamic>>.from(response);
      return uids;
    } catch (e) {
      print("Error en la peticion:$e");
      return [];
    }
  }

  static Future<dynamic> filtrarproducto(id) async {
    final instance = _client.storage; // Instancia de SupabaseStorage
    final folderPath = 'producto'; // Carpeta donde deseas almacenar las fotos
    Map<String, dynamic> producto = {}; // Lista de productoes
    String fileName = '$id.png'; // Nombre del archivo
    try {
      //Intenta obtener el producto
      final response = await _client
          .from('productos')
          .select('*')
          .eq('id', id); //Filtra el producto por id
      if (response != null) {
        // Si la respuesta no es nula
        var foto = ''; // Foto del producto
        var image = null; // Imagen del producto
        foto = response[0]['foto'].toString(); // Obtiene la foto del producto
        if (foto.isNotEmpty) {
          //Si la respuesta no es una url vacia
          image = await instance
              .from(folderPath)
              .getPublicUrl(fileName); //Obtiene la url de la imagen
          response[0]['foto'] = image; //Agrega la url de la imagen al perfil
        }
      }
      producto = Map<String, dynamic>.from(response[0]);
      return producto; //Retorna el producto
    } catch (e) {
      print("Error en la peticion:$e");
      return {};
    }
  }

  static Future<dynamic> cargarImagen(var foto) async {
    final instance = _client.storage;
    final folderPath = 'productos'; // Carpeta donde deseas almacenar las fotos
    final fileName = '${foto.path.split('/').last}/fotoCatalogo.png';
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
