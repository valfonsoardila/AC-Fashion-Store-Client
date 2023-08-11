import 'package:acfashion_store/data/services/peticionesCompra.dart';
import 'package:acfashion_store/data/services/peticionesPago.dart';
import 'package:acfashion_store/domain/controller/controllerUserAuth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';

class PeticionesPedido {
  static final ControlUserAuth controlua = Get.find();
  static final SupabaseClient _client = Supabase.instance.client;

  static Future<dynamic> crearPedido(pedido, carrito, perfil, total) async {
    try {
      var horaCompra = pedido['horaCompra'];
      final tableNamePedido = 'pedido';
      await _client.from(tableNamePedido).insert([pedido]);
      var pedidoRegistrado = await _client
          .from(tableNamePedido)
          .select('*')
          .eq('horaCompra', horaCompra);
      var pago = {
        'idpedido': pedidoRegistrado[0]['uid'],
        'iduser': perfil['uid'],
        'nombre': perfil['nombre'],
        'pago': total,
        'mes': DateTime.now().month,
      };
      carrito.forEach((element) {
        element['idpedido'] = pedidoRegistrado[0]['uid'];
      });
      print("CARRITO ANTES DE GUARDAR: $carrito");
      PeticionesPago.crearPago([pago]);
      PeticionesCompra.crearCompra(carrito);
      return true;
    } catch (error) {
      print('Error en la operación de creación de pedido: $error');
      throw error;
    }
  }
}
