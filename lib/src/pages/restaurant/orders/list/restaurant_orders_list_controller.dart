import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/provider/orden_provider.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';

class RestaurantOrdersListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  Usuario usuario;

  List<String> status = ['PAGADO', 'DESPACHADO', 'EN CAMINO', 'ENTREGADO'];

  OrdenProvider _ordenProvider = new OrdenProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));

    _ordenProvider.init(context, usuario);
    refresh();
  }

  Future<List<Orden>> getOrders(String status) async{
    return await _ordenProvider.getByStatus(status);
  }

  void logout() {
    _sharedPref.logout(context, usuario.id);
  }

  void goToCategoryCreate() {
    Navigator.pushNamed(context, 'restaurant/categorias/create');
  }

  void goToProductCreate() {
    Navigator.pushNamed(context, 'restaurant/products/create');
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  // Para que muestre los roles
  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
