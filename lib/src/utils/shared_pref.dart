import 'dart:convert';
import 'package:app_burger_stone/src/provider/users_provider.dart';
import 'package:flutter/material.dart'; //importamos paquete matirial
import 'package:shared_preferences/shared_preferences.dart'; //importamos paquete shared preferences

class SharedPref {
  //metodos para trabajar conn shared preferences nuestro almacenamiento con percistencia de datos

  //metodo para almacenar inf en el storage

  void save(String key, value) async {
    final prefs = await SharedPreferences
        .getInstance(); //obtenemos instancia de shared preferences para utilizar sus metodos
    prefs.setString(key, json.encode(value));
  }

  //metodo para leer la información almacenada

  Future<dynamic> read(String key) async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(key) == null) return null;

    return json.decode(prefs.getString(key));
  }

  //metodo para saber si existe en el shared preferencesalgun dato

  Future<bool> contains(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  //metodo para eliminar dato de shared preferences

  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  //metodo para cerrar sesion
  void logout(BuildContext context, String idUser) async {
    UsersProvider usersProvider = new UsersProvider();
    usersProvider.init(context);
    await usersProvider.logout(idUser);

    await remove('usuario');
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }
}
