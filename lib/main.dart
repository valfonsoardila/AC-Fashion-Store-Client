import 'package:acfashion_store/domain/controller/controllerPerfilUser.dart';
import 'package:acfashion_store/domain/controller/controllerUserControlUserAuthSupabase.dart';
import 'package:acfashion_store/ui/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa el paquete supabase_flutter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    // Inicializa Supabase con tus credenciales
    url:
        'https://ilhxudokfcjgwqpegnfk.supabase.co', // Reemplaza con la URL de tu proyecto de Supabase
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlsaHh1ZG9rZmNqZ3dxcGVnbmZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODgwOTQ3NDQsImV4cCI6MjAwMzY3MDc0NH0.x5K8D3KAQDuuoEpfz9Rx47OHJ0QY6Bj-iYSyrrJ8nOY', // Reemplaza con tu clave de acceso anónimo de Supabase
  );
  Get.put(
      ControlUserAuth()); // Reemplaza ControlUserAuth con tu controlador de autenticación de Supabase
  Get.put(ControlUserPerfil());
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(App());
}
