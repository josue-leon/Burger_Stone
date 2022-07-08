import 'dart:convert';

import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/direccion.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DireccionProvider {

  String _url = Environment.BURGER_STONE;
  String _api = '/BurgerStone/direccion';
  BuildContext context;
  Usuario sessionUser;

  Future init(BuildContext context, Usuario sessionUser)
  {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //metodo para obtener las direcciones
  Future<List<Direccion>> getByUser(String idUsuario) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByUser/${idUsuario}'); //obtiene todos los datos
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers,);
      if (res.statusCode == 401) {//401 respuesta no autorizada
        Fluttertoast.showToast(msg: 'Sesión Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      Direccion direccion = Direccion.fromJsonList(data);
      return direccion.toList;//retornamos la lista de direcciones
    }
    catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi> create(Direccion direccion) async {
    // Si hay error
    try {
      // Si ejecuta bien
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(direccion);
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