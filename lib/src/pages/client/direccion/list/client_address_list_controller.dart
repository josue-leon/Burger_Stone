import 'package:app_burger_stone/src/models/direccion.dart';
import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/provider/direccion_provider.dart';
import 'package:app_burger_stone/src/provider/orden_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';

class ClientAddressListController {
  BuildContext context;
  Function refresh;

  List<Direccion> direccion = [];
  DireccionProvider _direccionProvider = new DireccionProvider();
  Usuario usuario;
  SharedPref _sharedPref = new SharedPref();

  int radioValue = 0;
  bool isCreated;

  Map<String, dynamic> dataIsCreated;

  OrdenProvider _ordenProvider = new OrdenProvider();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));

    _direccionProvider.init(context, usuario);
    _ordenProvider.init(context, usuario);
    refresh();
  }

  void createOrder() async
  {
    Direccion a = Direccion.fromJson(await _sharedPref.read('direccion') ?? {});
    List<Producto> selectedProductos = Producto.fromJsonList(await _sharedPref.read('orden')).toList;
    Orden orden = new Orden(
      idCliente: usuario.id,
      idDireccion: a.id,
      producto: selectedProductos
    );
    ResponseApi responseApi = await _ordenProvider.create(orden);

    print('Respuesta de la orden: ${responseApi.message}');
  }

  void handleRadioValueChange(int value) async{
    radioValue = value;
    _sharedPref.save('direccion', direccion[value]);

    refresh();
    print('Valor seleccionado: ${radioValue}');
  }

  Future<List<Direccion>> getAddress() async
  {
    direccion = await _direccionProvider.getByUser(usuario.id);

    Direccion a = Direccion.fromJson(await _sharedPref.read('direccion') ?? {});
    int index = direccion.indexWhere((ad) => ad.id == a.id);

    if (index != -1) {
      radioValue = index;
    }
    print('SE GUARDÓ LA DIRECCIÓN: ${a.toJson()}');

    return direccion;
  }

  void goToNewAddress() async{
    var result = await Navigator.pushNamed(context, 'client/direccion/create');
    if (result != null) {
      if (result == true) {
        refresh();
      }
    }
  }
}
