import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  void dispose()
  {
    super.dispose();
    _con.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
              child: _googleMaps()),
          // Sólo ocupe el área segura
          SafeArea(
            child: Column(
              children: [
                _buttonCenterPosition(),
                Spacer(),
                _cardOrderInfo()
              ],
            ),
          ),
          Positioned(
            top: 40,
              left: 15,
              child: _iconGoogleMaps()
          ),
          Positioned(
              top: 85,
              left: 15,
              child: _iconWaze()
          )
        ],
      ),
    );
  }

  Widget _cardOrderInfo()
  {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25),
          topLeft: Radius.circular(25)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.amber[200].withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Column(
        children: [
          _listTitleAddress(_con.orden?.direccion?.vecindario, 'Vecindario', Icons.my_location),
          _listTitleAddress(_con.orden?.direccion?.direccion, 'Dirección', Icons.location_on),
          Divider(color: Colors.amber[600], endIndent: 30, indent: 30),
          _clientInfo(),
          _buttonNext()
        ],
      ),
    );
  }

  Widget _clientInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: FadeInImage(
              image: _con.orden?.cliente?.imagen != null
                  ? NetworkImage(_con.orden?.cliente?.imagen)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Text(
              '${_con.orden?.cliente?.nombre ?? ''} ${_con.orden?.cliente?.apellido ?? ''}',
              style: TextStyle(
                color: Colors.amber[800],
                fontSize: 16
              ),
              maxLines: 1,
            ),
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.blueGrey[100]
            ),
            child: IconButton(
              onPressed: _con.call,
              icon: Icon(Icons.phone, color: Colors.blue[800]),
            ),
          )
        ],
      ),
    );
  }

  Widget _iconGoogleMaps() {
    return GestureDetector(
      onTap: _con.launchGoogleMaps,
      child: Image.asset(
        'assets/img/google_maps.png',
        height: 35,
        width: 35,
      ),
    );
  }

  Widget _iconWaze() {
    return GestureDetector(
      onTap: _con.launchWaze,
      child: Image.asset(
        'assets/img/waze.png',
        height: 35,
        width: 35,
      ),
    );
  }

  Widget _listTitleAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: ListTile(
        title: Text(
          title ?? '',
          style: TextStyle(
            fontSize: 13
          ),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(iconData),
      )
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 5),
      child: ElevatedButton(
        onPressed: _con.updateToDelivery,
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
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  'ENTREGAR PRODUCTO',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 45, top: 5),
                height: 30,
                child: Icon(
                  Icons.check_circle,
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


  Widget _buttonCenterPosition()
  {
    return GestureDetector(
      onTap: () {},
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.blue[600],
              size: 20,
            ),
          ),
        ),
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
      polylines: _con.polylines,
    );
  }

  void refresh()
  {
    if (!mounted) return;
    setState(() {});
  }
}