import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:app_burger_stone/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'client_orders_list_controller.dart';

class ClientOrdersListPage extends StatefulWidget {
  const ClientOrdersListPage({Key key}) : super(key: key);

  @override
  State<ClientOrdersListPage> createState() => _ClientOrdersListPage();
}

class _ClientOrdersListPage extends State<ClientOrdersListPage> {
  ClientOrdersListController _con = new ClientOrdersListController();
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
            title: Text('Mis pedidos'),
            backgroundColor: MyColors.primaryColor,
            bottom: TabBar(
              indicatorColor: MyColors.primaryColor,
              labelColor: Colors.white,
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
    return GestureDetector(
      onTap: () {
        _con.openBottomSheet(orden);
      },
      child: Container(
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
                        child: Text('Orden # ${orden.id}',
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
                        'Repartidor: ${orden.repartidor?.nombre ?? 'No asignado'} ${orden.repartidor?.apellido ?? ''}',
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
                        'Entregar en: ${orden.direccion?.direccion ?? ''}',
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
      ),
    );
  }

  // Refresh para que carguen los datos
  void refresh() {
    setState(() {}); // CTRL+S
  }
}
