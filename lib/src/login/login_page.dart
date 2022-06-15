import 'package:flutter/material.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('APP BURGUER STONE ♥'),
      ),
      body: Stack(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              color: Colors.green
            ),
          ),
          Container(
            margin: EdgeInsets.only(top:60, left: 60),
            child: Text('LOGIN'),
          )
        ],
      )
    );
  }
}
