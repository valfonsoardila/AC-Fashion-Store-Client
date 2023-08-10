import 'dart:async';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeticionesProducto {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearProducto(
      Map<String, dynamic> producto, catalogo, modelo) async {
    try {
      var urlCatalogo = '';
      var urlModelo = '';
      if (catalogo != null) {
        urlCatalogo = await PeticionesProducto.cargarImagen(
            "Catalogo", catalogo, producto['categoria']);
      }
      if (modelo != null) {
        urlModelo = await PeticionesProducto.cargarImagen(
            "Modelo", modelo, producto['modelo']);
      }
      producto['catalogo'] = urlCatalogo.toString();
      producto['modelo'] = urlModelo.toString();
      await _client.from('productos').insert([producto]);
      return true;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error;
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerProductos() async {
    try {
      final folderPath =
          'producto'; // Carpeta donde estan almacenadas las fotos
      List<Map<String, dynamic>> productos = []; // Lista de productos
      var uids = await PeticionesProducto
          .obtenerListaUids(); // Lista de uids de los productos
      for (int i = 0; i < uids.length; i++) {
        Map<String, dynamic> producto = {}; // Lista de productos
        var uid = ""; // Uid del producto
        var response = null; // Respuesta de la peticion
        uid = uids[i]['id'].toString(); // Obtiene el uid del producto
        response = await _client.from(folderPath).select('*').eq('id', uid);
        producto = Map<String, dynamic>.from(response[0]);
        productos.add(producto);
      }
      print("esta es la lista de productos: $productos");
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
    print("este es el id del producto: $id");
    final tableName = 'producto'; // Carpeta donde deseas almacenar las fotos
    Map<String, dynamic> producto = {}; // Lista de productoes
    try {
      //Intenta obtener el producto
      final response = await _client
          .from(tableName)
          .select('*')
          .eq('id', id); //Filtra el producto por id
      print("esta es la respuesta del filtro: $response");
      producto = Map<String, dynamic>.from(response[0]);
      return producto; //Retorna el producto
    } catch (e) {
      print("Error en la peticion:$e");
      return {};
    }
  }

  static Future<dynamic> cargarImagen(
      var carpeta, var imagen, var categoria) async {
    final instance = _client.storage;
    final folderPath = 'productos'; // Carpeta donde deseas almacenar las fotos
    final fileName = '$categoria/$carpeta/${imagen.path.split('/').last}';
    final file = File(imagen.path);
    try {
      final String path = await instance.from(folderPath).upload(
            fileName,
            file,
            fileOptions: FileOptions(cacheControl: '3600', upsert: false),
          );
      final response = path;
      return response;
    } catch (e) {
      print('Error en la operación de carga de catalogo: $e');
    }
  }
}
