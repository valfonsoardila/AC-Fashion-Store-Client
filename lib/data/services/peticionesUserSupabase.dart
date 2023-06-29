import 'package:supabase_flutter/supabase_flutter.dart';

class Peticioneslogin {
  static Future login(String email, String password) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password);
    if (response.error != null && response.error.message != '') {
      throw Exception(response.error.message);
    }
    if (response.data == null || response.data.length == 0) {
      throw Exception('Usuario o contraseña incorrectos');
    }
    return response.data;
  }

  static Future register(String email, String password) async {
    final response = await Supabase.instance.client
        .from('users')
        .insert({'email': email, 'password': password});
    if (response.error != null && response.error.message != '') {
      throw Exception(response.error.message);
    }
    return response.data;
  }

  static Future update(String email, String password) async {
    final response = await Supabase.instance.client
        .from('users')
        .update({'email': email, 'password': password})
        .eq('email', email)
        .eq('password', password);
    if (response.error != null && response.error.message != '') {
      throw Exception(response.error.message);
    }
    return response.data;
  }

  static Future delete(String email, String password) async {
    final response = await Supabase.instance.client
        .from('users')
        .delete()
        .eq('email', email)
        .eq('password', password);
    if (response.error != null && response.error.message != '') {
      throw Exception(response.error.message);
    }
    return response.data;
  }

  static Future get(String email, String password) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password);
    if (response.error != null && response.error.message != '') {
      throw Exception(response.error.message);
    }
    if (response.data == null || response.data.length == 0) {
      throw Exception('Usuario o contraseña incorrectos');
    }
    return response.data;
  }

  static Future recuperarContrasena(String email) async {
    final response = await Supabase.instance.client
        .from('users')
        .select()
        .eq('email', email);
    if (response.error != null && response.error.message != '') {
      throw Exception(response.error.message);
    }
    if (response.data == null || response.data.length == 0) {
      throw Exception('Usuario o contraseña incorrectos');
    }
    return response.data;
  }

  static Future abandonarSesion() async {
    final response = await Supabase.instance.client.auth.signOut();
    return response;
  }
}
