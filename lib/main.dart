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
        'https://your-supabase-url.com', // Reemplaza con la URL de tu proyecto de Supabase
    anonKey:
        'your-anon-key', // Reemplaza con tu clave de acceso anónimo de Supabase
  );
  Get.put(
      ControlUserAuth()); // Reemplaza ControlUserAuth con tu controlador de autenticación de Supabase
  Get.put(ControlUserPerfil());
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(App());
}
