import 'package:app_burger_stone/src/models/mercado_pago_card_token.dart';
import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/provider/mercado_pago_provider.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class ClientPaymentsCuotasController {

  BuildContext context;
  Function refresh;

  MercadoPagoProvider _mercadoPagoProvider = new MercadoPagoProvider();
  Usuario usuario;
  SharedPref _sharedPref = new SharedPref();

  MercadoPagoCardToken cardToken;
  List<Producto> selectedProductos = [];
  double totalPayment = 0;

  List cuotasList = [];

  String selectedInstallment;

  Future init(BuildContext context, Function refresh) async
  {
    this.context = context;
    this.refresh = refresh;

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    cardToken = MercadoPagoCardToken.fromJsonMap(arguments);
    print('CARD TOKEN ARGUMENT: ${cardToken.toJson()}');
    selectedProductos = Producto.fromJsonList(await _sharedPref.read('orden')).toList;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));

    _mercadoPagoProvider.init(context, usuario);

    getTotalPayment();
    getInstallments();
  }


  void getInstallments() async
  {
    int op = 1;
    List payerCosts = [op];
    cuotasList = payerCosts;
    refresh();
  }

  void getTotalPayment() {
    selectedProductos.forEach((producto)
    {
      //print('PRODUCTO: ${producto.toJson()}');
      totalPayment = totalPayment + (producto.cantidad * producto.precio);
    });
    refresh();
  }
}