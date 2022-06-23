import 'package:app_burger_stone/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
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
      _con.init(context, refresh); //inicializar nuestro controlador
    });
  }


  @override
  Widget build(BuildContext context)
  {
    return Scaffold( //esqueleto de la aplicación
      key: _con.key,
      appBar: AppBar(
        leading: _menuDrawer(),
      ),
      drawer: _drawer(),
      body: Center(
        //child: Text('LISTA DE PRODUCTOS'),
        //Parte de Cerrar sesión
        child: ElevatedButton(
          onPressed: _con.logout,
          child: Text('Cerrar Sesión'),
        ),
      ),
    );
  }
  Widget _menuDrawer()
  {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png',width: 20,height: 20,),
      ),
    );
  }
  Widget _drawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primaryColor
            ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // Si no tiene un nombre de usuario se muestra ''
                    '${_con.usuario?.nombre ?? ''} ${_con.usuario?.apellido ?? ''}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                    maxLines: 1,//este nombre no puede ocupar mas de una linea el texto
                  ),

                  Text(
                    _con.usuario?.email ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,//este nombre no puede ocupar mas de una linea el texto
                  ),

                  Text(
                    _con.usuario?.telefono ?? '',
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[200],
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                    ),
                    maxLines: 1,//este nombre no puede ocupar mas de una linea el texto
                  ),

                  // Imagen del usuario
                  Container(
                    height: 60,
                    margin: EdgeInsets.only(top:10),
                    child: FadeInImage(
                      image: _con.usuario?.imagen != null
                          ? NetworkImage(_con.usuario?.imagen)
                          : AssetImage('assets/img/no-image.png'),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 50),
                      placeholder:AssetImage('assets/img/no-image.png') ,//carga imagen x defecto
                    ),
                  )

                ],
              )
          ),
          ListTile(
            title: Text('Editar perfil'),
            trailing: Icon(Icons.edit_outlined),

          ),
          ListTile(
            title: Text('Mis pedidos'),
            trailing: Icon(Icons.shopping_cart_outlined),

          ),

          _con.usuario != null ?
          _con.usuario.roles.length > 1 ?
          ListTile(
            onTap: _con.goToRoles,
            title: Text('Seleccionar Rol'),
            trailing: Icon(Icons.person_outline),
          ) : Container() : Container(),
          ListTile(
            onTap: _con.logout,
            title: Text('Cerrar sesión'),
            trailing: Icon(Icons.power_settings_new),

          ),
        ],
      ),
    );
  }

  // Refresh para que carguen los datos
  void refresh() {
    setState(() {}); // CTRL+S
  }
}
