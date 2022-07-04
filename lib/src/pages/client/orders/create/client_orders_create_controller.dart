import 'dart:io';

import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientOrdersCreateController{

  BuildContext context;
  Function refresh;

  Producto producto;

  int counter = 1;
  double productoPrecio;
  SharedPref _sharedPref = new SharedPref();
  List<Producto> selectedProductos = [];
  double total =0;

  Future init(BuildContext context, Function refresh) async
  {
    this.context = context;
    this.refresh = refresh;

    selectedProductos = Producto.fromJsonList(await _sharedPref.read('orden')).toList;
    getTotal();
    refresh();
  }

  void getTotal()
  {
    total = 0;
    selectedProductos.forEach((producto)
    {
      total = total + (producto.cantidad * producto.precio);
    });
    refresh();
  }

  void addItem(Producto producto) {
    int index = selectedProductos.indexWhere((p) => p.id == producto.id);
    selectedProductos[index].cantidad = selectedProductos[index].cantidad + 1;
    _sharedPref.save('orden', selectedProductos);
    getTotal();
  }

  void removeItem(Producto producto) {
    if (producto.cantidad > 1) {
      int index = selectedProductos.indexWhere((p) => p.id == producto.id);
      selectedProductos[index].cantidad = selectedProductos[index].cantidad - 1;
      _sharedPref.save('orden', selectedProductos);
      getTotal();
    }
  }

  void deleteItem(Producto producto) {
    selectedProductos.removeWhere((p) => p.id == producto.id);
    _sharedPref.save('orden', selectedProductos);
    getTotal();
  }
}