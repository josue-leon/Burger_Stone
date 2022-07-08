import 'package:app_burger_stone/src/models/direccion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app_burger_stone/src/pages/client/direccion/list/client_address_list_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:app_burger_stone/src/widgets/no_data_widget.dart';

class ClientAddressListPage extends StatefulWidget {
  const ClientAddressListPage({Key key}) : super(key: key);

  @override
  _ClientAddressListPageState createState() => _ClientAddressListPageState();
}

class _ClientAddressListPageState extends State<ClientAddressListPage> {
  ClientAddressListController _con = new ClientAddressListController();

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
    return Scaffold(
      appBar: AppBar(
          title: Text('Direcciones'),
          actions: [_iconAdd()]
      ),
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: _textSelectAddress()
          ),
          Container(
              margin: EdgeInsets.only(top: 50),
              child: _listAddress()
          )
        ],
      ),
      bottomNavigationBar: _buttonAccept(),
    );
  }

  Widget _noAddress() {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 30),
            child: NoDataWidget(
                text: 'No tiene ninguna dirección, agregar una nueva'),
        ),
        _buttonNewAddress()
      ],
    );
  }

  Widget _buttonNewAddress() {
    return Container(
      height: 40,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ElevatedButton(
        onPressed: _con.goToNewAddress,
        child: Text(
            'Nueva dirección'
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.blue),
      ),
    );
  }

  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: _con.createOrder,
        child: Text(
            'ACEPTAR'
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
            ),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _listAddress()
  {
    return FutureBuilder(
        future: _con.getAddress(),
        builder: (context, AsyncSnapshot<List<Direccion>> snapshot) {

          if (snapshot.hasData){
            if (snapshot.data.length > 0){
              return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (_, index) {
                    return _radioSelectorAddress(snapshot.data[index], index);
                  }
              );
            }
            else {
              return _noAddress();
            }
          }
          else {
            return _noAddress();
          }
        }
    );
  }

  Widget _radioSelectorAddress(Direccion direccion, int index)
  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: _con.radioValue,
                onChanged: _con.handleRadioValueChange,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    direccion?.direccion ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    direccion?.vecindario ?? '',
                    style: TextStyle(
                        fontSize: 12,
                    ),
                  )
                ],
              ),
            ],
          ),
          Divider(
            color: Colors.grey[400],
          )
        ],
      ),
    );
  }

  Widget _textSelectAddress() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Elija donde recibir sus compras',
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _iconAdd() {
    return IconButton(
      onPressed: _con.goToNewAddress,
        icon: Icon(Icons.add, color: Colors.white)
    );
  }

  void refresh() {
    setState(() {});
  }
}
