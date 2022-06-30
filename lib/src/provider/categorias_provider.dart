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