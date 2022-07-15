import 'dart:convert';

import 'package:app_burger_stone/src/models/mercado_pago_card_token.dart';
import 'package:app_burger_stone/src/models/mercado_pago_document_type.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/provider/mercado_pago_provider.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:http/http.dart';

class ClientPaymentsCreateController {

  BuildContext context;
  Function refresh;
  GlobalKey<FormState> keyForm = new GlobalKey();

  TextEditingController documentNumberController = new TextEditingController();

  String cardNumber = '';
  String expireDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  List<MercadoPagoDocumentType> documentTypeList = [];
  MercadoPagoProvider _mercadoPagoProvider = new MercadoPagoProvider();
  Usuario usuario;
  SharedPref _sharedPref = new SharedPref();

  String typeDocument = 'CC';
  String expirationYear;
  int expirationMonth;

  MercadoPagoCardToken cardToken;

  Future init(BuildContext context, Function refresh) async
  {
    this.context = context;
    this.refresh = refresh;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));

    _mercadoPagoProvider.init(context, usuario);
    getIdentificationTypes();
  }

  void getIdentificationTypes() async
  {
    documentTypeList = await _mercadoPagoProvider.getIdentificationTypes();
    refresh();
  }

  void createCardToken() async
  {
    String documentNumber = documentNumberController.text;

    if (cardNumber.isEmpty)
    {
      MySnackbar.show(context, 'Ingrese el número de la tarjeta');
      return;
    }

    if (expireDate.isEmpty)
    {
      MySnackbar.show(context, 'Ingrese la fecha de expiración de la tarjeta');
      return;
    }

    if (cvvCode.isEmpty)
    {
      MySnackbar.show(context, 'Ingrese el código de seguridad de la tarjeta');
      return;
    }

    if (cardHolderName.isEmpty)
    {
      MySnackbar.show(context, 'Ingrese el titular de la tarjeta');
      return;
    }

    if (documentNumber.isEmpty)
    {
      MySnackbar.show(context, 'Ingrese el número de documento');
      return;
    }

    if (expireDate != null)
    {
      List<String> list = expireDate.split('/');
      if (list.length == 2) {
        expirationMonth = int.parse(list[0]);
        expirationYear = '20${list[1]}';
      }
      else {
        MySnackbar.show(context, 'Ingrese el mes y año de expiración de la tarjeta');
      }
    }

    if (cardNumber != null) {
      cardNumber = cardNumber.replaceAll(RegExp(' '), '');
    }

    print('CVV: $cvvCode');
    print('Card Number: $cardNumber');
    print('Card Holder Name: $cardHolderName');
    print('documentId: $typeDocument');
    print('documentNumber: $documentNumber');
    print('expirationYear: $expirationYear');
    print('expirationMonth: $expirationMonth');

    Response response = await _mercadoPagoProvider.createCardToken(
      cvv: cvvCode,
      cardNumber: cardNumber,
      cardHolderName: cardHolderName,
      documentId: typeDocument,
      documentNumber: documentNumber,
      expirationYear: expirationYear,
      expirationMonth: expirationMonth
    );

    if (response != null) {
      final data = json.decode(response.body);

      if (response.statusCode == 201)
      {
        cardToken = new MercadoPagoCardToken.fromJsonMap(data);
        //print ('CARD TOKEN: ${cardToken.toJson()}');
        Navigator.pushNamed(context, 'client/payments/cuotas', arguments: cardToken.toJson());
      }
      else {
        print('HUBO UN ERROR GENERANDO EL TOKEN DE LA TARJETA');
        int status = int.tryParse(data['causa'][0]['code'] ?? data['status']);
        String message = data['message'] ?? 'Error al registrar la tarjeta';
        MySnackbar.show(context, 'Status code $status - $message');
      }
    }
  }

  void onCreditCardModelChanged(CreditCardModel creditCardModel) {
    cardNumber = creditCardModel.cardNumber;
    expireDate = creditCardModel.expiryDate;
    cardHolderName = creditCardModel.cardHolderName;
    cvvCode = creditCardModel.cvvCode;
    isCvvFocused = creditCardModel.isCvvFocused;
    refresh();
  }
}