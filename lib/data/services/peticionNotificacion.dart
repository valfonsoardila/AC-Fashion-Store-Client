import 'package:supabase_flutter/supabase_flutter.dart';

class PeticionesNotificacion {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearNotificacion(
      Map<String, dynamic> notificacion) async {
    try {
      final tableName = 'notificacion';
      await _client.from(tableName).insert([notificacion]);
      return true;
    } catch (error) {
      print('Error en la operación de creación de notificacion: $error');
      throw error;
    }
  }

  static Future<dynamic> actualizarNotificacion(
      Map<String, dynamic> notificacion) async {
    try {
      final tableName = 'notificacion';
      await _client
          .from(tableName)
          .update(notificacion)
          .eq('uid', notificacion['uid']);
      return true;
    } catch (error) {
      print('Error en la operación de creación de notificacion: $error');
      throw error;
    }
  }

  static Future<dynamic> eliminarNotificacion(
      Map<String, dynamic> notificacion) async {
    try {
      final tableName = 'notificacion';
      await _client.from(tableName).delete().eq('uid', notificacion['uid']);
      return true;
    } catch (error) {
      print('Error en la operación de creación de notificacion: $error');
      throw error;
    }
  }

  static Future<List<dynamic>> filtrarNotificacion(String iduser) async {
    try {
      print("XD");
      List<Map<String, dynamic>> notificaciones = [];
      final tableName = 'notificacion';
      final response =
          await _client.from(tableName).select('*').eq('iduser', iduser);
      print("esta es la respuesta XD: $response");
      if (response.isNotEmpty) {
        print("no esta vacio XD");
        notificaciones = List<Map<String, dynamic>>.from(response);
      } else {
        print("esta vacio XD");
        notificaciones = [];
      }
      return notificaciones;
    } catch (error) {
      print('Error en la operación buscar notificacion: $error');
      throw error;
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerNotificaciones() async {
    try {
      final tableName = 'notificacion';
      final response = await _client.from(tableName).select('*');
      print("esta es la respuesta: $response");
      if (response.isEmpty) {
        print("esta vacio");
        return [];
      } else {
        print("no esta vacio");
        return response;
      }
    } catch (error) {
      print('Error en la operación buscar notificacion: $error');
      throw error;
    }
  }
}
