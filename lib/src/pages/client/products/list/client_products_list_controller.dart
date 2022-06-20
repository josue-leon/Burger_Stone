import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';


class ClientProductsListController {

  BuildContext context;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context){
    this.context = context;
  }
  logout() {
    _sharedPref.logout(context);
  }


}