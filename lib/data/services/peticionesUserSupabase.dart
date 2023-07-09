import 'package:supabase_flutter/supabase_flutter.dart';

class Peticioneslogin {
  static Future login(String email, String password) async {
    try {
      final client = Supabase.instance.client;
      final AuthResponse authResponse = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final Session? sesion = authResponse.session;
      final response = sesion;
      return response;
    } catch (e) {
      print('Error al iniciar sesion: $e');
    }
  }

  static Future register(String email, String password) async {
    try {
      final client = Supabase.instance.client;
      final AuthResponse authResponse = await client.auth.signUp(
        email: email,
        password: password,
      );
      final User? user = authResponse.user;
      final response = user;
      return response;
    } catch (e) {
      print('Error al registrar autenticacion: $e');
    }
  }

  static Future update(String email, String password) async {
    try {
      final client = Supabase.instance.client;
      final UserResponse userResponse = await client.auth.updateUser(
        UserAttributes(
          email: email,
          password: password,
        ),
      );
      final User? user = userResponse.user;
      final response = user;
      return response;
    } catch (e) {
      print('Error al actualizar autenticacion: $e');
    }
  }

  static Future obtenerUsurioLogueado() async {
    try {
      final client = Supabase.instance.client;
      final User? user = client.auth.currentUser;
      final response = user;
      return response;
    } catch (e) {
      print('Error al obtener autenticacion: $e');
    }
  }

  static Future obtenerDatosSesion() async {
    try {
      final client = Supabase.instance.client;
      final Session? session = client.auth.currentSession;
      final respouse = session;
      return respouse;
    } catch (e) {
      print('Error al obtener autenticacion: $e');
    }
  }

  static Future restablecerContrasena(String password) async {
    try {
      final client = Supabase.instance.client;
      final UserResponse response = await client.auth.updateUser(
        UserAttributes(
          password: password,
        ),
      );
      final User? updatedUser = response.user;
      print("Respuesta: $updatedUser");
      return updatedUser;
    } catch (e) {
      print('Error al restablecer contraseña: $e');
    }
  }

  static Future cerrarSesion() async {
    try {
      final client = Supabase.instance.client;
      final response = await client.auth.signOut();
      return response;
    } catch (e) {
      print('Error al cerrar sesion: $e');
    }
  }
}
