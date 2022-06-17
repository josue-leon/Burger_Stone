/*este es el controlador para manejar toda la parte
logica de la pantallas */

import 'package:flutter/material.dart';//paquete de matirial

class LoginController {

  BuildContext context; //variable de tipo buildcontex
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();


  Future init(BuildContext context) {
    //metodo  constructor de nuestra clase
    this.context = context;
  }

  void goToRegisterPage(){//metodo que lleva a la pantalla de registro
    Navigator.pushNamed(context, 'register');//ruta a donde vamos a navegar en este caso al register
  }

  void login(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print ('Email: $email');
    print ('Password: $password');
  }
}