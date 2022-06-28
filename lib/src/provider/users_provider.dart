import 'dart:convert';
import 'dart:io';

import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class UsersProvider {
  String _url = Environment.BURGER_STONE;
  // Petición de los usuarios
  String _api = '/BurgerStone/usuario';

  BuildContext context;

  Future init(BuildContext context) {
    this.context = context;
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
