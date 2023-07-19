import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class PeticionesFavorito {
  static final SupabaseClient _client = Supabase.instance.client;
  static Future<dynamic> crearFavorito(Map<String, dynamic> producto) async {
    final tableName = "favorito";
    try {
      await _client.from(tableName).insert([producto]);
      return true;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error;
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerFavoritos(String id) async {
    final tableName = "favorito";
    List<Map<String, dynamic>> favoritos = [];
    try {
      final response = await _client.from(tableName).select('*').eq('id', id);
      if (response.isNotEmpty) {
        favoritos = List<Map<String, dynamic>>.from(response);
        print("favoritos: $favoritos");
      } else {
        favoritos = [];
      }
      return favoritos;
    } catch (error) {
      print('Error en la operación de creación de favorito: $error');
      throw error;
    }
  }

  static Future<List<Map<String, dynamic>>> filtrarfavorito(String id) async {
    final tableName = "favorito";
    List<Map<String, dynamic>> favoritos = [];
    Map<String, dynamic> producto = {};
    try {
      final response = await _client.from(tableName).select('*').eq('id', id);
      if (response.isNotEmpty) {
        producto = Map<String, dynamic>.from(response[0]);
        favoritos.add(producto);
        print("favoritos: $favoritos");
      } else {
        favoritos = [];
      }
      return favoritos;
    } catch (error) {
      print('Error en la operación de creación de favorito: $error');
      throw error;
    }
  }

  static Future<dynamic> eliminarFavorito(String id) async {
    print("id del producto a eliminar: $id");
    final tableName = "favorito";
    try {
      final List<Map<String, dynamic>> data =
          await _client.from(tableName).delete().match({'uid': id}).select();
      return data;
    } catch (error) {
      print('Error en la operación de creación de catálogo: $error');
      throw error;
    }
  }
}
