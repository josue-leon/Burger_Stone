import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/provider/orden_provider.dart';
import 'package:app_burger_stone/src/provider/users_provider.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeliveryOrdersDetailController {
  BuildContext context;
  Function refresh;

  Producto producto;

  int counter = 1;
  double productoPrecio;
  SharedPref _sharedPref = new SharedPref();

  double total = 0;
  Orden orden;

  Usuario usuario;
  List<Usuario> usuarios = [];
  UsersProvider _usersProvider = new UsersProvider();
  OrdenProvider _ordenProvider = new OrdenProvider();
  String idRepartidor;

  Future init(BuildContext context, Function refresh, Orden orden) async {
    this.context = context;
    this.refresh = refresh;
    this.orden = orden;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));
    _usersProvider.init(context, sessionUser: usuario);
    _ordenProvider.init(context, usuario);

    getTotal();
    getUsuarios();
    refresh();
  }

  void updateOrden() async
  {
    if (orden.status == 'DESPACHADO') {
      ResponseApi responseApi = await _ordenProvider.updateToOnTheWay(orden);
      Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
      if (responseApi.success) {
        Navigator.pushNamed(context, 'delivery/orders/map', arguments: orden.toJson());
      }
    }
    else {
      Navigator.pushNamed(context, 'delivery/orders/map', arguments: orden.toJson());
    }
  }

  void getUsuarios() async {
    usuarios = await _usersProvider.getDelivery();
    refresh();
  }

  void getTotal() {
    total = 0;
    orden.producto.forEach((producto) {
      total = total + (producto.precio * producto.cantidad);
    });
    refresh();
  }
}
