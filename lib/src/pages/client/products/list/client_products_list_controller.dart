import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/provider/categorias_provider.dart';
import 'package:app_burger_stone/src/provider/products_provider.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/pages/client/products/detail/client_product_detail_page.dart';
import 'package:app_burger_stone/src/models/categoria.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController {
  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Function refresh;
  Usuario usuario;

  List<Categoria> categories = [];
  CategoriasProvider _categoriesProvider = new CategoriasProvider();
  ProductsProvider _productProvider = new ProductsProvider();


  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));
    _categoriesProvider.init(context, usuario);
    _productProvider.init(context, usuario); //quitar el token
    getCategories();
    refresh();
  }

  //Lista de productos va a devolver
  Future<List<Producto>> getProducto(String idCategory) async{
    return await _productProvider.getByCategory(idCategory);
  }

  void getCategories() async {
    categories = await _categoriesProvider.getAll();
    refresh();
  }

  //Modal Bottom Sheet
  void openBottomSheet(Producto producto){
    showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientProductsDetailPage(producto: producto)
    );
  }
  void logout() {
    _sharedPref.logout(context, usuario.id);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }

  void goToPageUpdate() {
    Navigator.pushNamed(context, 'client/update');
  }

  void goToPageCreatePage() {
    Navigator.pushNamed(context, 'client/orders/create');
  }

  // Para que muestre los roles
  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }
}
