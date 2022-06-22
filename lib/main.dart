import 'package:app_burger_stone/src/pages/client/products/list/client_products_list_page.dart';
import 'package:app_burger_stone/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:app_burger_stone/src/pages/login/login_page.dart';
import 'package:app_burger_stone/src/pages/register/register_page.dart';
import 'package:app_burger_stone/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:app_burger_stone/src/pages/roles/roles_page.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:flutter/material.dart';

void main() {//metodo principal
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}
//stf widget
class _MyAppState extends State<MyApp> {
  @override
  //metodo principal que se ejecuta cuando corremos la aplicacion
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App Burger Stone',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',//la ruta que se va a iniciar primero
      // Rutas
      routes: {//colocamos todas las rutas que vamos creando
        'login' : (BuildContext context) => Login_page(),
        'register' : (BuildContext context) =>   RegisterPage(),//ruta a la pantalla de registro
        'roles' : (BuildContext context) =>   RolesPage(),//ruta para la pantalla de roles
        'client/products/list' : (BuildContext context) =>   ClientProductsListPage(),//ruta para listar productos
        'restaurant/orders/list' : (BuildContext context) =>   RestaurantOrdersListPage(),//ruta para listar productos
        'delivery/orders/list' : (BuildContext context) =>   DeliveryOrdersListPage()//ruta para listar productos

      },
      //para establecer el color
      theme: ThemeData(
          fontFamily: 'Roboto',
          primaryColor: MyColors.primaryColor
      ),
    );
  }
}
