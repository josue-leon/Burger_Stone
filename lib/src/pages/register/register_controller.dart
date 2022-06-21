import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/provider/users_provider.dart';
import 'package:app_burger_stone/src/models/response_api.dart';

class RegisterController{

  BuildContext context;
  TextEditingController cedulaController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController nombreController = new TextEditingController();
  TextEditingController apellidoController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  UsersProvider usersProvider = new UsersProvider();

  Future init (BuildContext context)
  {
    this.context = context;
    usersProvider.init(context);
  }

  void register() async
  {
    String cedula = cedulaController.text;
    String email = emailController.text.trim();
    String nombre = nombreController.text;
    String apellido = apellidoController.text;
    String telefono = telefonoController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (cedula.isEmpty || email.isEmpty || nombre.isEmpty || apellido.isEmpty || telefono.isEmpty || password.isEmpty || confirmPassword.isEmpty){
        MySnackbar.show(context, 'Debes llenar todos los campos para registrarte');
        return;
    }

    if (confirmPassword != password){
        MySnackbar.show(context, 'Las contraseñas no son iguales');
        return;
    }

    if (password.length<6){
      MySnackbar.show(context, 'La contraseña debe contener al menos 6 caracteres');
      return;
    }

    Usuario usuario = new Usuario(
      cedula: cedula,
      email: email,
      nombre: nombre,
      apellido: apellido,
      telefono: telefono,
      password: password,
    );
    
    ResponseApi responseApi = await usersProvider.create(usuario);
    MySnackbar.show(context, responseApi.message);

    if(responseApi.success){
      Future.delayed(Duration(seconds: 3), (){
        Navigator.pushReplacementNamed(context, 'login');
      });
    }

    print ('RESPUESTA: ${responseApi.toJson()}');
    print(cedula);
    print(email);
    print(nombre);
    print(apellido);
    print(telefono);
    print(password);
    print(confirmPassword);

  }
}