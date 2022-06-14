import 'package:app_burger_stone/src/login/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App Burger Stone',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      // Rutas
      routes: {
        'login' : (BuildContext context) => Login_page()
      },
    );
  }
}
