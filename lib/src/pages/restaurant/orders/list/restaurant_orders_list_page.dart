import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/pages/restaurant/orders/list/restaurant_orders_list_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:app_burger_stone/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RestaurantOrdersListPage extends StatefulWidget {
  const RestaurantOrdersListPage({Key key}) : super(key: key);

  @override
  State<RestaurantOrdersListPage> createState() => _RestaurantOrdersListPage();
}

class _RestaurantOrdersListPage extends State<RestaurantOrdersListPage> {
  RestaurantOrdersListController _con = new RestaurantOrdersListController();//instancio
  //sobreescribir el metodo initState
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
    return DefaultTabController(
      length: _con.status?.length,
      child: Scaffold(
        key: _con.key,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              children: [
                SizedBox(height: 40),
                _menuDrawer(),
              ],
            ),
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey[400],
              isScrollable: true,
              tabs: List<Widget>.generate(_con.status.length, (index) {
                return Tab(
                  child: Text(_con.status[index] ?? ''),
                );
              }),
            ),
          ),
        ),
        drawer: _drawer(),
        body: TabBarView(
          children: _con.status.map((String status) {
            return FutureBuilder(
                future: _con.getOrders(status),
                builder: (context, AsyncSnapshot<List<Orden>> snapshot) {

                  if (snapshot.hasData){
                    if (snapshot.data.length > 0){
                      return ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (_, index) {
                            return _cardOrder(snapshot.data[index]);
                          }
                      );
                    }
                    else {
                      return NoDataWidget(text: 'No hay órdenes');
                    }
                  }
                  else {
                    return NoDataWidget(text: 'No hay órdenes');
                  }
                }
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _cardOrder(Orden orden) {
    return Container(
      height: 160,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
        ),
        child: Stack(
          children: [
            Positioned(
                child: Container(
                  height: 30,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.88,
                  decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)
                      )
                  ),
                  child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text('Orden #0',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontFamily: 'NimbusSans',
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Text(
                      'Pedido: 2022-08-07',
                      style: TextStyle(
                          fontSize: 13
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Text(
                      'Cliente: Michelle',
                      style: TextStyle(
                          fontSize: 13
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(vertical: 5),
                    width: double.infinity,
                    child: Text(
                      'Entregar en: Avenida siempre Viva 123',
                      style: TextStyle(
                          fontSize: 13
                      ),
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _menuDrawer(){
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
            onTap: _con.goToCategoryCreate,
            title: Text('Crear categoría'),
            trailing: Icon(Icons.list_alt),
          ),
          ListTile(
            onTap: _con.goToProductCreate,
            title: Text('Crear producto'),
            trailing: Icon(Icons.local_pizza),
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
