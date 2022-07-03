import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/categoria.dart';
import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductsProvider {

  String _url = Environment.BURGER_STONE;
  String _api = '/BurgerStone/producto';
  BuildContext context;
  Usuario sessionUser;

  Future init(BuildContext context, Usuario sessionUser)
  {
    this.context = context;
    this.sessionUser = sessionUser;
  }

  //Listar Productos por Categoria para el cliente

  Future<List<Producto>> getByCategory(String idCategory) async {
    try {
      Uri url = Uri.http(_url, '$_api/findByCategory/$idCategory'); //obtiene todos los datos
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Authorization': sessionUser.sessionToken
      };
      final res = await http.get(url, headers: headers,);

      if (res.statusCode == 401) {//401 respuesta no autorizada
        MySnackbar.show(context, 'Sesión Expirada');
        new SharedPref().logout(context, sessionUser.id);
      }
      final data = json.decode(res.body);//se obtiene las productos
      Producto producto = Producto.fromJsonList(data);
      return producto.toList;//retornamos la lista de productos
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
  
  Future<Stream> create(Producto producto, List<File> images) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization']=sessionUser.sessionToken;

      for(int i=0; i<images.length;i++){
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path)
        ));
      }
      request.fields['producto'] = json.encode(producto);
      final response = await request.send(); // Donde se envía la petición
      return response.stream.transform(utf8.decoder);
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }


}