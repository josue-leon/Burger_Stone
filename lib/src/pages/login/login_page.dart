import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:app_burger_stone/src/pages/login/login_controller.dart';//importamos el controlador
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie/lottie.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {

  //llamamos a nuestro archivo controller

  LoginController _con = new LoginController();//instanciamos la clase del controlador login

  @override
  void initState() {//se ejecuta cuando abrimos el page
    // TODO: implement initState
    super.initState();
    //metodo para inicializar los controladores
    SchedulerBinding.instance.addPostFrameCallback((timeStamp){
      _con.init(context);
    });
  }
  @override
  Widget build(BuildContext context) {//metodo que ejecuta todas las vistas codigo q se muestra en la pantalla
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                top: -80,
                left: -100,
                child: _CircleLogin()
            ),
            Positioned(
                top: 55,
                left: 25,
                child: _textLogin()
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                 //_imageBanner(),
                  _lottieAnimation(),
                  _textFieldEmail(),
                  _textFieldPassword(),
                  _buttonLogin(),
                  _textDontHaveAccount()
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  //elementos de lainterfaz

  //Imagen - Logo
  Widget _imageBanner(){
    return Container(
      margin: EdgeInsets.only(
          top: 110,
          bottom: MediaQuery.of(context).size.height * 0.2
      ),
      child: Image.asset('assets/img/delivery.png',
        width: 200,
        height: 180,
      ),
    );
  }

 //Cuadro de texto "input" Email
  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo electrónico',
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

  //Cuadro de texto "Input" Contrseña
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        controller: _con.passwordController,
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

  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
          onPressed: _con.login,
          child: Text('Ingresar'),
        style: ElevatedButton.styleFrom(
          primary: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)
          ),
          padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),//crea botones
    );
  }

  //texto No tienes una cuenta
  Widget _textDontHaveAccount(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes una cuenta?',
          style: TextStyle(
              color: MyColors.primaryColor,
<<<<<<< HEAD
              fontSize:17

=======
              fontSize: 17
>>>>>>> e4b992255bd12f069c9a022010a9a0e7cc687772

          ),
        ),
        SizedBox(width: 10,),
        GestureDetector(//envuelve a la etiqueta
          onTap:_con.goToRegisterPage,//similar al evento onclick cuando el usuario de click llamamos al controlador
          child: Text(
            'Regístrese',
            style:
            TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor,
<<<<<<< HEAD
                fontSize:17
=======
                fontSize: 17
>>>>>>> e4b992255bd12f069c9a022010a9a0e7cc687772
            ),
          ),
        )
      ],
    );
  }

  //forma circular parte superior
  Widget _CircleLogin(){
    return Container(
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primaryColor
      ),
    );
  }

  //Animacion
  Widget _lottieAnimation(){
    return Container (
        margin: EdgeInsets.only(
            top: 150,
            bottom: MediaQuery.of(context).size.height * 0.10
        ),
        child: Lottie.asset(
        'assets/json/hamburguer.json',
        width: 250,
        height: 300,
        fit: BoxFit.fill
        )
    );
  }

  //texto "login"
  Widget _textLogin(){
    return Text('LOGIN',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        fontFamily: 'NimbusSans'
    ),
    );
  }

}
