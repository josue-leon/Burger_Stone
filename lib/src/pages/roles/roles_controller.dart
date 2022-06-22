import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';

class RolesController{
  BuildContext context;
  Usuario usuario;
  SharedPref sharedPref = new SharedPref();
  Function refresh;

  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;

    //OBTIENE LOS DATOS EL USUARIO AL INCIAR SESION
    usuario = Usuario.fromJson( await sharedPref.read('usuario'));
    refresh(); //recarga la pagina para mostrar las imagees de los roles
  }

  void goToPage(String ruta){
    Navigator.pushNamedAndRemoveUntil(context, ruta, (route) => false);
  }
}