import 'package:app_burger_stone/src/models/categoria.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/provider/categorias_provider.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';

class RestaurantCategoriasCreateController {
  BuildContext context;
  Function refresh;

  TextEditingController nombreController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();

  CategoriasProvider _categoriasProvider = new CategoriasProvider();
  Usuario usuario;
  SharedPref sharedPref = new SharedPref();
  
  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    usuario = Usuario.fromJson(await sharedPref.read('usuario'));
    _categoriasProvider.init(context, usuario);
  }

  void createCategory() async{
    String nombre = nombreController.text;
    String descripcion = descripcionController.text;

    if (nombre.isEmpty || descripcion.isEmpty) {
      MySnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }

    Categoria categoria = new Categoria(
      nombre: nombre,
      descripcion: descripcion
    );

    ResponseApi responseApi = await _categoriasProvider.create(categoria);

    if (responseApi.success == true) {
      nombreController.text = '';
      descripcionController.text = '';
    }

    MySnackbar.show(context, responseApi.message);
  }
}