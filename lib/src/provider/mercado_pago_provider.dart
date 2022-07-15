import 'dart:convert';

import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/mercado_pago_document_type.dart';
import 'package:app_burger_stone/src/models/mercado_pago_payment_method_installments.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MercadoPagoProvider {
  String _urlMercadoPago = 'api.mercadopago.com';
  final _mercadoPagoCredentials = Environment.mercadoPagoCredentials;

  BuildContext context;
  Usuario usuario;

  Future init (BuildContext context, Usuario usuario) {
    this.context = context;
    this.usuario = usuario;
  }

  Future<List<MercadoPagoDocumentType>> getIdentificationTypes() async {
    try
    {
      final url = Uri.https(_urlMercadoPago, '/v1/identification_types', {
        'access_token': _mercadoPagoCredentials.accessToken
      });
      final res = await http.get(url);
      final data = json.decode(res.body);
      final result = new MercadoPagoDocumentType.fromJsonList(data);

      return result.documentTypeList;
    }
    catch(e)
    {
      print('Error: $e');
      return null;
    }
  }

  Future<MercadoPagoPaymentMethodInstallments> getInstallments(String bin, double amount) async {
    try
    {
      final url = Uri.https(_urlMercadoPago, '/v1/payment_methods/installments', {
        'access_token': _mercadoPagoCredentials.accessToken,
        'bin': bin,
        'amount': '${amount}'
      });
      final res = await http.get(url);
      final data = json.decode(res.body);
      final result = new MercadoPagoPaymentMethodInstallments.fromJsonList(data);

      return result.installmentList.first;
    }
    catch(e)
    {
      print('Error: $e');
      return null;
    }
  }
  
  Future<Response> createCardToken({
    String cvv,
    String expirationYear,
    int expirationMonth,
    String cardNumber,
    String documentNumber,
    String documentId,
    String cardHolderName
  }) async
  {
    try
    {
      final url = Uri.https(_urlMercadoPago, '/v1/card_tokens', {
        'public_key': _mercadoPagoCredentials.publicKey
      });

      final body = {
        'security_code': cvv,
        'expiration_year': expirationYear,
        'expiration_month': expirationMonth,
        'card_number': cardNumber,
        'card_holder': {
          'identification' : {
            'number': documentNumber,
            'type': documentId,
          },
          'name': cardHolderName
        },
        'security_code': cvv,
      };

      final res = await http.post(url, body:json.encode(body));
      return res;
    }
    catch (e)
    {
      print('Error: $e');
      return null;
    }
  }
}