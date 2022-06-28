import 'package:app_burger_stone/src/pages/client/update/client_update_controller.dart';
import 'package:app_burger_stone/src/pages/register/register_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';

class ClientUpdatePage extends StatefulWidget {
  const ClientUpdatePage({Key key}) : super(key: key);

  @override
  State<ClientUpdatePage> createState() => _ClientUpdatePageState();
}

class _ClientUpdatePageState extends State<ClientUpdatePage> {

  ClientUpdateController _con = new ClientUpdateController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(//por lo general todos los page scaffold etiqueta principal esquelo de nuestra pantalla
     appBar: AppBar(
       title: Text('Editar Perfil'),
       backgroundColor: MyColors.primaryColor,
     ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 60,),
              _imagenUsuario(),
              SizedBox(height: 30,),
              _textFieldNombre(),
              _textFieldApellido(),
              _textFieldTelefono(),
            ],
          ),
        ),
      ),
      bottomNavigationBar:  _buttonRegister(),
    );
  }

  Widget _imagenUsuario(){
    return GestureDetector(
      onTap: _con.showAlertDialog,
      child: CircleAvatar(
        backgroundImage: _con.imageFile != null
            ? FileImage(_con.imageFile)
            : _con.usuario?.imagen != null ? NetworkImage(_con.usuario?.imagen)
            : AssetImage('assets/img/user_profile_2.png'),
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Widget _CircleRegister(){
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColor
      ),
    );
  }

  Widget _iconBack(){
    return IconButton(
        onPressed: (){},
        color: Colors.white,
        icon: Icon(Icons.arrow_back_ios));
  }

  Widget _textRegister(){
    return Text('REGISTRO',
      style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          fontFamily: 'NimbusSans'
      ),
    );
  }

  Widget _buttonRegister(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.isEnable ? _con.register : null,
        child: Text('ACTUALIZAR CAMBIOS'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  Widget _textFieldCedula(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        inputFormatters: [
          BlacklistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s")),
        ],
        //controller: _con.cedulaController,
        onChanged: (text) {
          if(text.length > 10){
            MySnackbar.show(context, 'La cédula debe tener 10 digitos');
          }
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Cédula',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.assignment_ind_rounded,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        //controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo Electrónico',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  Widget _textFieldNombre(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s")),
        ],
        controller: _con.nombreController,
        decoration: InputDecoration(
            hintText: 'Nombre',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  Widget _textFieldApellido(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s")),
        ],
        controller: _con.apellidoController,
        decoration: InputDecoration(
            hintText: 'Apellido',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.person_outline,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  Widget _textFieldTelefono(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        inputFormatters: [
          BlacklistingTextInputFormatter(RegExp(r"[a-zA-Z]+|\s")),
        ],
        controller: _con.telefonoController,
        onChanged: (text) {
          if(text.length > 10){
            MySnackbar.show(context, 'El teléfono debe tener 10 digitos');
          }
        },
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Teléfono',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.phone,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        //controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  Widget _textFieldConfirmPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        //controller: _con.confirmPasswordController,
        obscureText: true,
        decoration: InputDecoration(
            hintText: 'Confirmar contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  // Refrescar la pantalla
  void refresh(){
    setState(() {

    });
  }

}
