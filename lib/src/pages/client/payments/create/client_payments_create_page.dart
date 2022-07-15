import 'package:app_burger_stone/src/models/mercado_pago_document_type.dart';
import 'package:app_burger_stone/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class ClientPaymentsCreatePage extends StatefulWidget {
  const ClientPaymentsCreatePage({Key key}) : super(key: key);

  @override
  State<ClientPaymentsCreatePage> createState() => _ClientPaymentsCreatePageState();
}

class _ClientPaymentsCreatePageState extends State<ClientPaymentsCreatePage>
{
  ClientPaymentsCreateController _con = new ClientPaymentsCreateController();

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
        title: Text('Pagos'),
      ),
      body: ListView(
        children: [
          CreditCardWidget(
            cardNumber: _con.cardNumber,
            expiryDate: _con.expireDate,
            cardHolderName: _con.cardHolderName,
            cvvCode: _con.cvvCode,
            showBackView: _con.isCvvFocused,
            cardBgColor: Colors.black,
            obscureCardNumber: true,
            obscureCardCvv: true,
            textStyle: TextStyle(color: Colors.yellowAccent),
            animationDuration: Duration(milliseconds: 1000),
            labelCardHolder: 'NOMBRE Y APELLIDO',
          ),

          CreditCardForm(
            cvvCode: '',
            expiryDate: '',
            cardHolderName: '',
            cardNumber: '',
            formKey: _con.keyForm, // Required
            onCreditCardModelChange: _con.onCreditCardModelChanged, // Required
            themeColor: Colors.red,
            obscureCvv: true,
            obscureNumber: true,
            cardNumberDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Número de la tarjeta',
              hintText: 'XXXX XXXX XXXX XXXX',
            ),
            expiryDateDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Vencimiento',
              hintText: 'XX/XX',
            ),
            cvvCodeDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'CVV',
              hintText: 'XXX',
            ),
            cardHolderDecoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre del Titular',
            ),
          ),
          _documentInfo(),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.all(20),
      child: ElevatedButton(
        onPressed: _con.createCardToken,
        style: ElevatedButton.styleFrom(
            primary: Colors.amber,
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
                  'CONTINUAR',
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
                  Icons.arrow_forward_ios,
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

  Widget _documentInfo()
  {
    // return Material(
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Material(
              elevation: 2.0,
              //es para dar una sobra
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: DropdownButton(
                        //selector de categorias
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
                            'C.I.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12
                            ),
                          ),
                          items: _dropDownItems(_con.documentTypeList),
                          value: _con.typeDocument,
                          onChanged: (option) {
                            setState(() {
                              print('Repartidor seleccionado $option');
                              _con.typeDocument = option;
                            });
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 15),
          Flexible(
            flex: 4,
            child: TextField(
              controller: _con.documentNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Número de documento'
              ),
            ),
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<MercadoPagoDocumentType> documentType) {
    List<DropdownMenuItem<String>> list = [];
    documentType.forEach((document) {
      list.add(DropdownMenuItem(
        child: Container (
          margin: EdgeInsets.only(top: 7),
          child: Text(document.name),
        ),
        value: document.id,
      ));
    });
    return list;
  }

  void refresh() {
    setState(() {});
  }
}


