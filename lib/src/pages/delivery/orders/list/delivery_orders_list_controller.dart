import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';


class DeliveryOrdersListController {


  BuildContext context;
  SharedPref _sharedPref = new SharedPref();
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  Future init(BuildContext context) {
    this.context = context;
  }

  void logout() {
    _sharedPref.logout(context);
  }

  void openDrawer() {
    key.currentState.openDrawer();
  }
}


