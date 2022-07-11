import 'dart:convert';
import 'dart:io';

import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider {
  String _url = Environment.BURGER_STONE;
  // Petición de los usuarios
  String _api = '/BurgerStone/usuario';
  BuildContext context;
  String token;
  Usuario sessionUser;

  Future init(BuildContext context, {Usuario sessionUser}) {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  Future<List<Usuario>> getDelivery() async {
    try {
      print('SESSION TOKEN DSDASD: ${sessionUser.sessionToken}');
      Uri url = Uri.http(_url, '$_api/findDelivery');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        // NO AUTORIZADO
        // Fluttertoast.showToast(msg: 'Tu sesion expiro');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      Usuario usuario = Usuario.fromJsonList(data);
      return usuario.toList;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Obtener el id
  Future<Usuario> getById(String id) async {
    try {
      Uri url = Uri.http(_url, '$_api/findById/$id');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 401) {
        // NO AUTORIZADO
        // Fluttertoast.showToast(msg: 'Tu sesion expiro');
        new SharedPref().logout(context, sessionUser.id);
      }

      final data = json.decode(res.body);
      Usuario usuario = Usuario.fromJson(data);
      return usuario;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

//Creación de usuario con imagen
  Future<Stream> createWithImage(Usuario usuario, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);

      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['usuario'] = json.encode(usuario);
      final response = await request.send(); // Donde se envía la petición
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  //Actualización de datos del usuario
  Future<Stream> update(Usuario usuario, File image) async {
    try {
      Uri url = Uri.http(_url, '$_api/update');
      final request = http.MultipartRequest('PUT', url);
      request.headers['Authorization'] = sessionUser.sessionToken;

      if (image != null) {
        request.files.add(http.MultipartFile('image',
            http.ByteStream(image.openRead().cast()), await image.length(),
            filename: basename(image.path)));
      }

      request.fields['usuario'] = json.encode(usuario);

      final response = await request.send(); // Donde se envía la petición

      if (response.statusCode == 401) {
        //Fluttertoast.showToast(msg: 'Tu sesion expiro');
        new SharedPref().logout(context, sessionUser.id);
      }

      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Para registrar un usuario
  Future<ResponseApi> create(Usuario usuario) async {
    // Si hay error
    try {
      // Si ejecuta bien
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(usuario);
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<ResponseApi> logout(String idUser) async {
    try {
      Uri url = Uri.http(_url, '$_api/logout');
      String bodyParams = json.encode({'id': idUser});
      Map<String, String> headers = {'Content-type': 'application/json'};
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Para el inicio de sesión
  Future<ResponseApi> login(String email, String password) async {
    try {
      Uri url = Uri.http(_url, '$_api/login');
      String bodyParams = json.encode({'email': email, 'password': password});
      Map<String, String> headers = {
        'Content-type': 'application/json',
      };
      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
/*
  Future <ResponseApi> validarCI (String cedula) async{
    try
    {
      Uri url = Uri.http(_url, '$_api/validateCI');
      String bodyParams = json.encode({
        'cedula': cedula,
      });

      Map<String, String> headers = {
        'Content-type': 'application/json',
      };

      final res = await http.post(url, headers: headers, body: bodyParams);
      final data = json.decode(res.body);
      ResponseApi responseApi = ResponseApi.fromJson(data);
      return responseApi;
    }
    catch (e)
    {
      print ('Error: $e');
      return null;
    }

  }
*/
}
