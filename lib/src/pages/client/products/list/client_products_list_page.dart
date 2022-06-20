import 'package:app_burger_stone/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientProductsListPage extends StatefulWidget {
  const ClientProductsListPage({Key key}) : super(key: key);

  @override
  State<ClientProductsListPage> createState() => _ClientProductsListPageState();
}

class _ClientProductsListPageState extends State<ClientProductsListPage> {

  ClientProductsListController _con = new ClientProductsListController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);//inicializar nuestro controlador
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( //esqueleto de la aplicacion
      body: Center(
        //child: Text('LISTA DE PRODUCTOS'),
        //Parte de Cerrar sesión
        child: ElevatedButton(
          onPressed: _con.logout,
          child: Text('Cerrar sesion'),
        ),
      ),
    );
  }
}
