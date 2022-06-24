import 'dart:io';

import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/provider/users_provider.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:image_picker/image_picker.dart';

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

  PickedFile pickedFile;
  File imageFile;
  Function refresh;

  Future init (BuildContext context, Function refresh)
  {
    this.context = context;
    this.refresh = refresh;
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
        MySnackbar.show(context, 'Llene todos los campos para registrarse');
        return;
    }

    if(ValidarCI(cedula) == false){
      MySnackbar.show(context, 'La cédula ingresada no es válida');
      return;
    }

    //expresion regular para validar apellido

    if(!RegExp(r"^[a-zA-Z]{3,10}$").hasMatch(apellido))
    {
      MySnackbar.show(context, 'El apellido ingresado no es válido');
      return;
    }

    if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(email))
    {
      MySnackbar.show(context, 'Ingrese un email válido');
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

    //ResponseApi responseApiCI = await usersProvider.validarCI(cedula);
    //MySnackbar.show(context, responseApiCI.message);

    ResponseApi responseApi = await usersProvider.create(usuario);
    MySnackbar.show(context, responseApi.message);

    if(responseApi.success){
      Future.delayed(Duration(seconds: 3), (){
        Navigator.pushReplacementNamed(context, 'login');
      });
    }

    print ('RESPUESTA: ${responseApi.toJson()}');
  }

  Future selectImage(ImageSource imageSource) async{
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null)
    {
      imageFile = File(pickedFile.path);
    }
    Navigator.pop(context);
    refresh();
  }

  void showAlertDialog(){
    Widget galleryButton = ElevatedButton(
      onPressed: () {
        selectImage(ImageSource.gallery);
      },
      child: Text('GALERIA')
    );

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera);
        },
        child: Text('CÁMARA')
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Seleccione su imagen'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context){
        return alertDialog;
      }
    );
  }

  bool ValidarCI(String cedula){
    if(cedula.length == 10){

      //Obtenemos el digito de la region que sonlos dos primeros digitos
      var digito_region = int.parse(cedula.substring(0,2));

      //Pregunto si la region existe ecuador se divide en 24 regiones
      if(  digito_region>= 1 && digito_region <= 24 ){

        // Extraigo el ultimo digito
        var ultimo_digito   = int.parse(cedula.substring(9,10));

        //Agrupo todos los pares y los sumo
        var pares = int.parse(cedula.substring(1,2)) + int.parse(cedula.substring(3,4)) + int.parse(cedula.substring(5,6)) + int.parse(cedula.substring(7,8));

        //Agrupo los impares, los multiplico por un factor de 2, si la resultante es > que 9 le restamos el 9 a la resultante
        var numero1 = int.parse(cedula.substring(0,1));
        numero1 = (numero1 * 2);
        if( numero1 > 9 ){numero1 = (numero1 - 9);}

        var numero3 = int.parse(cedula.substring(2,3));
        numero3 = (numero3 * 2);
        if( numero3 > 9 ){ numero3 = (numero3 - 9); }

        var numero5 = int.parse(cedula.substring(4,5));
        numero5 = (numero5 * 2);
        if( numero5 > 9 ){numero5 = (numero5 - 9); }

        var numero7 = int.parse(cedula.substring(6,7));
        numero7 = (numero7 * 2);
        if( numero7 > 9 ){numero7 = (numero7 - 9); }

        var numero9 = int.parse(cedula.substring(8,9));
        numero9 = (numero9 * 2);
        if( numero9 > 9 ){ numero9 = (numero9 - 9);}

        var impares = numero1 + numero3 + numero5 + numero7 + numero9;

        //Suma total
        var suma_total = (pares + impares);

        //extraemos el primero digito
        var primer_digito_suma = (suma_total).toString().substring(0,1);

        //Obtenemos la decena inmediata
        var decena = (int.parse(primer_digito_suma) + 1)  * 10;

        //Obtenemos la resta de la decena inmediata - la suma_total esto nos da el digito validador
        var digito_validador = decena - suma_total;

        //Si el digito validador es = a 10 toma el valor de 0
        if(digito_validador == 10)
          var digito_validador = 0;

        //Validamos que el digito validador sea igual al de la cedula
        if(digito_validador == ultimo_digito){
          print('la cedula:' + cedula + ' es correcta');
          return true;
        }else{
          print('la cedula:' + cedula + ' es incorrecta');
          return false;
        }
      } else{
        // imprimimos en consola si la region no pertenece
        print('Esta cedula no pertenece a ninguna region');
        return false;
      }

    } else {
      //imprimimos en consola si la cedula tiene mas o menos de 10 digitos
      print('La cedula debe contener 10 digitos');
      return false;
    }
  }

}