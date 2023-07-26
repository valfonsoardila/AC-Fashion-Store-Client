import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class PeticionesPago {
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearPago(pago) async {
    try {
      final tableNamePago = 'pago';
      final response = await _client.from(tableNamePago).insert(pago);
      return response;
    } catch (error) {
      print('Error en la operación de creación de pago: $error');
      throw error;
    }
  }

  static Future<dynamic> obtenerPagos(String uid) async {
    final response = await _client
        .from('pagos')
        .select()
        .eq('uid', uid)
        .order('id', ascending: false);
    if (response.error == null) {
      return response.data;
    } else {
      return response.error.message;
    }
  }

  static Future<dynamic> eliminarPago(String id) async {
    final response = await _client.from('pagos').delete().eq('id', id);
    if (response.error == null) {
      return response.data;
    } else {
      return response.error.message;
    }
  }
}
