import 'dart:convert';

import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/categoria.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CategoriasProvider {

  String _url = Environment.BURGER_STONE;
  String _api = '/BurgerStone/categorias';
  BuildContext context;
  Usuario sessionUser;

  Future init(BuildContext context, Usuario sessionUser)
  {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //metodo para obtener las categorias
  Future<List<Categoria>> getAll() async {
    try {
      Uri url = Uri.http(_url, '$_api/getAll'); //obtiene todos los datos
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers,);
      if (res.statusCode == 401) {//401 respuesta no autorizada
        MySnackbar.show(context, 'Sesión Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);//se obtiene las categorias
      Categoria categoria = Categoria.fromJsonList(data);
      return categoria.toList;//retornamos la lista de categorias
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi> create(Categoria categoria) async {
    // Si hay error
    try {
      // Si ejecuta bien
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(categoria);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        MySnackbar.show(context, 'Sesión Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}