/*este es el controlador para manejar toda la parte
lógica de la pantallas */

import 'package:app_burger_stone/src/provider/users_provider.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';//paquete de matirial

class LoginController {

  BuildContext context; //variable de tipo buildcontex
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();

  Future init(BuildContext context) async
  {
    //Método  constructor de nuestra clase
    this.context = context;
    await usersProvider.init(context);
  }

  void goToRegisterPage(){//metodo que lleva a la pantalla de registro
    Navigator.pushNamed(context, 'register');//ruta a donde vamos a navegar en este caso al register
  }

  void login() async
  {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    ResponseApi responseApi = await usersProvider.login(email, password);
    print('Respuesta object: ${responseApi}');
    print('Respuesta: ${responseApi.toJson()}');
    MySnackbar.show(context, responseApi.message);
  }
}