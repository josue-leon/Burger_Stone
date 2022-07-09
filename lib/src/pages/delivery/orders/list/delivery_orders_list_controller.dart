import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:app_burger_stone/src/provider/orden_provider.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DeliveryOrdersListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  Usuario usuario;

  List<String> status = ['DESPACHADO', 'EN CAMINO', 'ENTREGADO'];
  OrdenProvider _ordenProvider = new OrdenProvider();

  bool isUpdated;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));

    _ordenProvider.init(context, usuario);
    refresh();
  }

  Future<List<Orden>> getOrders(String status) async{
    return await _ordenProvider.getByDeliveryAndStatus(usuario.id, status);
  }

  void openBottomSheet(Orden orden) async
  {
    isUpdated = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => DeliveryOrdersDetailPage(orden: orden)
    );

    if (isUpdated)
    {
      refresh();
    }
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
