import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  @override
  Widget build(BuildContext context) {
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
            Column(
              children: [
               //_imageBanner(),
                _lottieAnimation(),
                _textFieldEmail(),
                _textFieldPassword(),
                _buttonLogin(),
                _textDontHaveAccount()
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _imageBanner(){
    return Container(
      margin: EdgeInsets.only(
          top: 120,
          bottom: MediaQuery.of(context).size.height * 0.22
      ),
      child: Image.asset('assets/img/delivery.png',
        width: 200,
        height: 200,
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
        decoration: InputDecoration(
            hintText: 'Correo electrónico',
            hintStyle: TextStyle(
              color: MyColors.primaryColorDark
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

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        decoration: InputDecoration(
            hintText: 'Contraseña',
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
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
          onPressed: (){},
          child: Text('Ingresar'),
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

  Widget _textDontHaveAccount(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes una cuenta?',
          style: TextStyle(
              color: MyColors.primaryColor

          ),
        ),
        SizedBox(width: 10,),
        Text('Regístrate',
          style:
          TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColor
          ),
        )
      ],
    );
  }

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
