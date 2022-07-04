import 'dart:io';

import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientProductsDetailController{

  BuildContext context;
  Function refresh;

  Producto producto;

  int counter = 1;
  double productoPrecio;
  SharedPref _sharedPref = new SharedPref();
  List<Producto> selectedProductos = [];

  Future init(BuildContext context, Function refresh, Producto producto) async
  {
    this.context = context;
    this.refresh = refresh;
    this.producto = producto;
    productoPrecio = producto.precio;
    
    //_sharedPref.remove('orden');
    selectedProductos = Producto.fromJsonList(await _sharedPref.read('orden')).toList;

    selectedProductos.forEach((p) {
      print('Producto seleccionado: ${p.toJson()}');
    });

    refresh();
  }

  void addToBag()
  {
    int index = selectedProductos.indexWhere((p) => p.id == producto.id);

    if (index == -1) // Productos seleccionados no existen
    {
      if (producto.cantidad == null) {
        producto.cantidad = 1;
      }
      selectedProductos.add(producto);
    }
    else
    {
      selectedProductos[index].cantidad = counter;
    }
    _sharedPref.save('orden', selectedProductos);
    Fluttertoast.showToast(msg: 'Producto agregado');
  }

  void addItem() {
    counter = counter + 1;
    productoPrecio = producto.precio * counter;
    producto.cantidad = counter;
    refresh();
  }

  void removeItem() {
    if (counter > 1)
    {
      counter = counter -1;
      productoPrecio = producto.precio * counter;
      producto.cantidad = counter;
      refresh();
    }
  }

  void close()
  {
    Navigator.pop(context);
  }

}