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
      final instance = _client.storage; // Instancia de Supabase Storage
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
        var catalogo = ''; // Foto catalogo del producto
        var modelo = ''; // Foto modelo del producto
        var imageCatalogo = null; // Imagen del producto
        var imageModelo = null; // Imagen del producto
        response = await _client.from(folderPath).select('*').eq('id', uid);
        catalogo =
            '${response[0]['categoria']}/Catalogo/${response[0]['catalogo']}'
                .toString(); // Obtiene la foto catalogo del producto
        modelo = '${response[0]['categoria']}/Modelo/${response[0]['modelo']}'
            .toString(); // Obtiene la foto modelo
        print("esta es la catalogo de la base de datos: $catalogo");
        if (catalogo.isNotEmpty && modelo.isNotEmpty) {
          //Si la respuesta no es una url vacia
          imageCatalogo = await instance
              .from(folderPath)
              .getPublicUrl(catalogo); //Obtiene la url de la imagen
          print("esta es la imagen: $imageCatalogo");
          response[0]['catalogo'] =
              imageCatalogo; //Agrega la url de la imagen al perfil
          imageModelo = await instance
              .from(folderPath)
              .getPublicUrl(modelo); //Obtiene la url de la imagen
          print("esta es la imagen: $imageModelo");
          response[0]['modelo'] = imageModelo;
        }
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
    final instance = _client.storage; // Instancia de SupabaseStorage
    final tableName = 'producto'; // Carpeta donde deseas almacenar las fotos
    final folderName = 'producto';
    Map<String, dynamic> producto = {}; // Lista de productoes
    String fileName = '$id.png'; // Nombre del archivo
    try {
      //Intenta obtener el producto
      final response = await _client
          .from(tableName)
          .select('*')
          .eq('id', id); //Filtra el producto por id
      print("esta es la respuesta del filtro: $response");
      if (response != null) {
        // Si la respuesta no es nula
        var catalogo = ''; // Foto del producto
        var image = null; // Imagen del producto
        catalogo = response[0]['catalogo']
            .toString(); // Obtiene la catalogo del producto
        if (catalogo.isNotEmpty) {
          //Si la respuesta no es una url vacia
          image = await instance
              .from(folderName)
              .getPublicUrl(fileName); //Obtiene la url de la imagen
          response[0]['catalogo'] =
              image; //Agrega la url de la imagen al perfil
        }
      }
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
