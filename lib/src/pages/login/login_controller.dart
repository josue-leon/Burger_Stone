/*este es el controlador para manejar toda la parte
lógica de la pantallas */

import 'package:app_burger_stone/src/models/usuario.dart';//paquete usuario
import 'package:app_burger_stone/src/provider/users_provider.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';//paquete de matirial


class LoginController {

  BuildContext context; //variable de tipo buildcontex
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  UsersProvider usersProvider = new UsersProvider();
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context) async
  {
    //Método  constructor de nuestra clase
    this.context = context;
    await usersProvider.init(context);

   Usuario usuario = Usuario.fromJson(await _sharedPref.read('usuario')??{});

    if (usuario?.sessionToken != null)//si existe el sessionToken en shared preferences
      {
      print('usuario logueado:  ${usuario.toJson()}');
      if(usuario.roles.length > 1){ //IDENTIFICA SI UN USUARIO TIENE MAS DE UN ROL
        Navigator.pushNamedAndRemoveUntil(context, 'roles', (
            route) => false); //NOS LLEVA A LA RUTA DE SELECCION DE ROLES
      } else{
        Navigator.pushNamedAndRemoveUntil(context, usuario.roles[0].ruta, (
            route) => false); //NOS LLEVA A LA RUTA DEL ROL POR DEFECTO DEL USUARIO
      }
      //Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (
          //route) => false); //nos lleva a una ruta
    }
  }
//quitar despues
    void goToRegisterPage() {
      //metodo que lleva a la pantalla de registro
      Navigator.pushNamed(context,
          'register'); //ruta a donde vamos a navegar en este caso al register
    }

    void login() async
    {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      ResponseApi responseApi = await usersProvider.login(email, password);

      // Validar si un correo es válido
      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(email))
      {
        MySnackbar.show(context, 'Ingrese un correo válido');
        return;
      }

      print('Respuesta object: ${responseApi}');
      print('Respuesta: ${responseApi.toJson()}');

      //EL USUARIO INGRESO CORRECTAMENTE
      if (responseApi.success) {
        Usuario usuario = Usuario.fromJson(responseApi.data); //mapa de valores
        _sharedPref.save('usuario', usuario.toJson()); //almacenaria al usuario

          print('usuario logueado:  ${usuario.toJson()}');
          if(usuario.roles.length > 1){ //IDENTIFICA SI UN USUARIO TIENE MAS DE UN ROL
            Navigator.pushNamedAndRemoveUntil(context, 'roles', (
                route) => false); //NOS LLEVA A LA RUTA DE SELECCION DE ROLES
          } else{
            Navigator.pushNamedAndRemoveUntil(context, usuario.roles[0].ruta, (
                route) => false); //NOS LLEVA A LA RUTA DEL ROL POR DEFECTO DEL USUARIO
          }
        //Navigator.pushNamedAndRemoveUntil(context, 'client/products/list', (
            //route) => false); //nos lleva a una ruta
      }
      else {
        MySnackbar.show(context, responseApi.message);
      }






    }
  }

