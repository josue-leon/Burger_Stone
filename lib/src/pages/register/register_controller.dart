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

    Usuario usuario = new Usuario(
      cedula: cedula,
      email: email,
      nombre: nombre,
      apellido: apellido,
      telefono: telefono,
      password: password,
    );
    
    ResponseApi responseApi = await usersProvider.create(usuario);

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