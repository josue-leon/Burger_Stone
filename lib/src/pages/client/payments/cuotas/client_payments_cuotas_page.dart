import 'package:app_burger_stone/src/models/mercado_pago_document_type.dart';
import 'package:app_burger_stone/src/models/mercado_pago_installment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'client_payments_cuotas_controller.dart';

class ClientPaymentsCuotasPage extends StatefulWidget {
  const ClientPaymentsCuotasPage({Key key}) : super(key: key);

  @override
  State<ClientPaymentsCuotasPage> createState() => _ClientPaymentsCuotasPageState();
}

class _ClientPaymentsCuotasPageState extends State<ClientPaymentsCuotasPage>
{
  ClientPaymentsCuotasController _con = new ClientPaymentsCuotasController();

  @override
  void initState()
  {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuotas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textDescription(),
          _dropDownCuotas()
        ],
      ),
      bottomNavigationBar: Container(
        height: 140,
        child: Column(
          children: [
            _textTotalPrice(),
            _buttonNext(),
          ],
        ),
      ),
    );
  }

  Widget _textDescription() {
    return Container(
      margin: EdgeInsets.all(30),
      child: Text(
        '¿En cuántas cuotas?',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _textTotalPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 23),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total a pagar:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            '${_con.totalPayment}',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            primary: Colors.green,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'CONFIRMAR PAGO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 9),
                height: 30,
                child: Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _dropDownCuotas()
  {
    // return Material(
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        elevation: 2.0,
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                    underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: Colors.blue,
                      ),
                    ),
                    elevation: 3,
                    isExpanded: true,
                    hint: Text(
                      'Seleccionar en número de cuotas',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15
                      ),
                    ),
                    items: _dropDownItems(_con.cuotasList),
                    value: _con.selectedInstallment,
                    onChanged: (option) {
                      setState(() {
                        print('Cuotas a pagar $option');
                        _con.selectedInstallment = option;
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List cuotasList) {
    List<DropdownMenuItem<String>> list = [];
    list.add(DropdownMenuItem(
      child: Container(
        margin: EdgeInsets.only(top: 7),
        child: Text('${_con.cuotasList}'),
      ),
      value: '',
    ));
    return list;
  }

  void refresh() {
    setState(() {});
  }
}


