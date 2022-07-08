import 'package:app_burger_stone/src/models/direccion.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/provider/direccion_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/pages/client/direccion/map/client_address_map_page.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAddressCreateController {
  BuildContext context;
  Function refresh;

  TextEditingController refPointController = new TextEditingController();
  TextEditingController direccionController = new TextEditingController();
  TextEditingController vecindarioController = new TextEditingController();

  Map<String, dynamic> refPoint;

  DireccionProvider _direccionProvider = new DireccionProvider();
  Usuario usuario;
  SharedPref _sharedPref = new SharedPref();

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));
    _direccionProvider.init(context, usuario);
  }

  void createAddress() async {
    String direccionNombre = direccionController.text;
    String vecindario = vecindarioController.text;
    double latitud = refPoint['latitud'] ?? 0;
    double longitud = refPoint['longitud'] ?? 0;

    if (direccionNombre.isEmpty || vecindario.isEmpty || latitud == 0 ||
        longitud == 0) {
      MySnackbar.show(context, 'Completa todos los campos');
      return;
    }

    Direccion direccion = new Direccion(
        direccion: direccionNombre,
        vecindario: vecindario,
        latitud: latitud,
        longitud: longitud,
        idUsuario: usuario.id
    );

    ResponseApi responseApi = await _direccionProvider.create(direccion);

    if (responseApi.success)
    {
      direccion.id = responseApi.data;
      _sharedPref.save('direccion', direccion);

      Fluttertoast.showToast(msg: responseApi.message);
      Navigator.pop(context, true);
    }
  }

  void openMap() async {
    refPoint = await showMaterialModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        builder: (context) => ClientAddressMapPage());

    if (refPoint != null) {
      refPointController.text = refPoint['direccion'];
      refresh();
    }
  }
}
