import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app_burger_stone/src/pages/client/direccion/create/client_address_create_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';

class ClientAddressCreatePage extends StatefulWidget {
  const ClientAddressCreatePage({Key key}) : super(key: key);

  @override
  _ClientAddressCreatePageState createState() => _ClientAddressCreatePageState();
}

class _ClientAddressCreatePageState extends State<ClientAddressCreatePage> {
  ClientAddressCreateController _con = new ClientAddressCreateController();

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
        title: Text('Nueva dirección'),
      ),
      bottomNavigationBar: _buttonAccept(),
      body: Column(
        children: [
          _textCompleteData(),
          _textFieldDireccion(),
          _textFieldVecindario(),
          _textFieldRefPoint()
        ],
      ),
    );
  }

  Widget _textFieldDireccion() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.direccionController,
        decoration: InputDecoration(
            labelText: 'Dirección',
            suffixIcon: Icon(
              Icons.location_on,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldRefPoint() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.refPointController,
        onTap: _con.openMap,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        decoration: InputDecoration(
            labelText: 'Punto de referencia',
            suffixIcon: Icon(
              Icons.map,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textFieldVecindario() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.vecindarioController,
        decoration: InputDecoration(
            labelText: 'Vecindario',
            suffixIcon: Icon(
              Icons.location_city,
              color: MyColors.primaryColor,
            )),
      ),
    );
  }

  Widget _textCompleteData() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Text(
        'Complete los datos',
        style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: ElevatedButton(
        onPressed: _con.createAddress,
        child: Text('CREAR DIRECCIÓN'),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: MyColors.primaryColor),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
