import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'delivery_orders_map_controller.dart';

class DeliveryOrdersMapPage extends StatefulWidget {
  const DeliveryOrdersMapPage({Key key}) : super(key: key);

  @override
  _DeliveryOrdersMapPage createState() => _DeliveryOrdersMapPage();
}

class _DeliveryOrdersMapPage extends State<DeliveryOrdersMapPage> {
  DeliveryOrdersMapController _con = new DeliveryOrdersMapController();

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
      body: Stack(
        children: [
          _googleMaps(),
          Container(
            alignment: Alignment.bottomCenter,
            child: _buttonAccept(),
          )
        ],
      ),
    );
  }

  Widget _buttonAccept() {
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 70),
      child: ElevatedButton(
        onPressed: _con.selectRefPoint,
        child: Text('SELECCIONAR ESTE PUNTO'),
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: MyColors.primaryColor),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
    );
  }

  void refresh() {
    setState(() {});
  }
}
