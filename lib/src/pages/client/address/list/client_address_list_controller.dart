import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';

class ClientAddressListController {
  BuildContext context;
  Function refresh;

  SharedPref _sharedPref = new SharedPref();

  int radioValue = 0;
  bool isCreated;

  Map<String, dynamic> dataIsCreated;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    refresh();
  }
}
