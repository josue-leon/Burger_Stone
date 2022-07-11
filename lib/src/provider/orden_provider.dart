import 'dart:convert';

import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class OrdenProvider {

  String _url = Environment.BURGER_STONE;
  String _api = '/BurgerStone/orden';
  BuildContext context;
  Usuario sessionUser;

  Future init(BuildContext context, Usuario sessionUser)
  {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Orden>> getByStatus(String status) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByStatus/$status');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers,);
      if (res.statusCode == 401) {//401 respuesta no autorizada
        Fluttertoast.showToast(msg: 'Sesión Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);//se obtiene las categorias
      Orden orden = Orden.fromJsonList(data);
      return orden.toList;//retornamos la lista de categorias
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<Orden>> getByDeliveryAndStatus(String idRepartidor, String status) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByDeliveryAndStatus/$idRepartidor/$status'); //obtiene todos los datos
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers,);
      if (res.statusCode == 401) {//401 respuesta no autorizada
        Fluttertoast.showToast(msg: 'Sesión Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);//se obtiene las categorias
      Orden orden = Orden.fromJsonList(data);
      return orden.toList;//retornamos la lista de categorias
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<Orden>> getByClientAndStatus(String idCliente, String status) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByClientAndStatus/$idCliente/$status'); //obtiene todos los datos
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers,);
      if (res.statusCode == 401) {//401 respuesta no autorizada
        Fluttertoast.showToast(msg: 'Sesión Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);//se obtiene las categorias
      Orden orden = Orden.fromJsonList(data);
      return orden.toList;//retornamos la lista de categorias
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<ResponseApi> create(Orden orden) async {
    // Si hay error
    try {
      // Si ejecuta bien
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(orden);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión Expirada');
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

  Future<ResponseApi> updateToDispatched(Orden orden) async {
    // Si hay error
    try {
      // Si ejecuta bien
      Uri url = Uri.http(_url, '$_api/updateToDispatched');
      String bodyParams = json.encode(orden);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión Expirada');
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

  Future<ResponseApi> updateToOnTheWay(Orden orden) async
  {
    try {
      Uri url = Uri.http(_url, '$_api/updateToOnTheWay');
      String bodyParams = json.encode(orden);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión Expirada');
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

  Future<ResponseApi> updateToDelivery(Orden orden) async
  {
    try {
      Uri url = Uri.http(_url, '$_api/updateToDelivery');
      String bodyParams = json.encode(orden);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión Expirada');
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

  Future<ResponseApi> updateLatLng(Orden orden) async
  {
    try {
      Uri url = Uri.http(_url, '$_api/updateLatLng');
      String bodyParams = json.encode(orden);
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.put(url, headers: headers, body: bodyParams);
      if (res.statusCode == 401) {
        Fluttertoast.showToast(msg: 'Sesión Expirada');
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