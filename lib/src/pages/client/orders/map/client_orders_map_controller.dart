import 'dart:async';

import 'package:app_burger_stone/src/api/environment.dart';
import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/provider/orden_provider.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ClientOrdersMapController {
  BuildContext context;
  Function refresh;
  Position _position;

  String direccionNombre;
  LatLng direccionLatLng;

  CameraPosition initialPosition =
      CameraPosition(target: LatLng(-1.6660803, -78.72978), zoom: 14);

  Completer<GoogleMapController> _mapController = Completer();

  BitmapDescriptor deliveryMarker;
  BitmapDescriptor homeMarker;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  Orden orden;

  Set<Polyline> polylines = {};
  List<LatLng> points = [];

  OrdenProvider _ordenProvider = new OrdenProvider();
  Usuario usuario;
  SharedPref _sharedPref = new SharedPref();

  double _distanceBetween;
  IO.Socket socket;

  Future init(BuildContext context, Function refresh) async
  {
    this.context = context;
    this.refresh = refresh;
    orden = Orden.fromJson(ModalRoute.of(context).settings.arguments as Map<String, dynamic>);
    deliveryMarker = await createMarkerFromAsset('assets/img/delivery2.png');
    homeMarker = await createMarkerFromAsset('assets/img/home.png');

    socket = IO.io('http://${Environment.BURGER_STONE}/orders/delivery', <String, dynamic> {
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();

    socket.on('position/${orden.id}', (data) {
      print(data);
    });

    usuario = Usuario.fromJson(await _sharedPref.read('usuario'));
    _ordenProvider.init(context, usuario);
    print('ORDEN: ${orden.toJson()}');
    checkGPS();
  }

  void isCloseToDeliveryPosition() {
    _distanceBetween = Geolocator.distanceBetween(
        _position.latitude,
        _position.longitude,
        orden.direccion.latitud,
        orden.direccion.longitud
    );

    print ('----------DISTANCIA ${_distanceBetween} ---------------');
  }

  void launchWaze() async
  {
    var url = 'waze://?ll=${orden.direccion.latitud.toString()},${orden.direccion.longitud.toString()}';
    var fallbackUrl =
        'https://waze.com/ul?ll=${orden.direccion.latitud.toString()},${orden.direccion.longitud.toString()}&navigate=yes';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void launchGoogleMaps() async
  {
    var url = 'google.navigation:q=${orden.direccion.latitud.toString()},${orden.direccion.longitud.toString()}';
    var fallbackUrl =
        'https://www.google.com/maps/search/?api=1&query=${orden.direccion.latitud.toString()},${orden.direccion.longitud.toString()}';
    try {
      bool launched =
      await launch(url, forceSafariVC: false, forceWebView: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false, forceWebView: false);
    }
  }

  void updateToDelivery() async
  {
    if (_distanceBetween <= 200){
      ResponseApi responseApi = await _ordenProvider.updateToDelivery(orden);
      if (responseApi.success) {
        Fluttertoast.showToast(msg: responseApi.message, toastLength: Toast.LENGTH_LONG);
        Navigator.pushNamedAndRemoveUntil(context, 'delivery/orders/list', (route) => false);
      }
    }
    else {
      MySnackbar.show(context, 'Aún no llega a su destino');
    }
  }
  
  Future<void> setPolylines(LatLng from, LatLng to) async{
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.BURGER_STONE_KEY_MAPS,
        pointFrom,
        pointTo
    );

    for(PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Colors.blue,
      points: points,
      width: 6
    );
    
    polylines.add(polyline);
    refresh();

  }

  void addMarker (
      String markerId,
      double latitud,
      double longitud,
      String title,
      String contenido,
      BitmapDescriptor iconMarker) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
      markerId: id,
      icon: iconMarker,
      position: LatLng(latitud, longitud),
      infoWindow: InfoWindow(title: title, snippet: contenido)
    );

    markers[id] = marker;

    refresh();
  }

  void selectRefPoint() {
    Map<String, dynamic> data = {
      'direccion': direccionNombre,
      'latitud': direccionLatLng.latitude,
      'longitud': direccionLatLng.longitude,
    };

    Navigator.pop(context, data);
  }

  Future<BitmapDescriptor> createMarkerFromAsset(String path) async
  {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return descriptor;
  }

  Future<Null> setLocationDraggableInfo() async {
    if (initialPosition != null) {
      double latitud = initialPosition.target.latitude;
      double longitud = initialPosition.target.longitude;

      List<Placemark> address = await placemarkFromCoordinates(latitud, longitud);

      if (address != null) {
        if (address.length > 0) {
          String direction = address[0].thoroughfare;
          String street = address[0].subThoroughfare;
          String city = address[0].locality;
          String department = address[0].administrativeArea;
          String country = address[0].country;
          direccionNombre = '$direction #$street, $city, $department';
          direccionLatLng = new LatLng(latitud, longitud);
          // print('LAT: ${addressLatLng.latitude}');
          // print('LNG: ${addressLatLng.longitude}');

          refresh();
        }
      }
    }
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(
        '[{"elementType":"geometry","stylers":[{"color":"#f5f5f5"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f5f5"}]},{"featureType":"administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#dadada"}]},{"featureType":"road.highway","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#e5e5e5"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#eeeeee"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#c9c9c9"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]}]');
    _mapController.complete(controller);
  }

  void dispose() {
    socket?.disconnect();
  }

  void updateLocation() async {
    try {
      await _determinePosition(); // OBTENER LA POSICION ACTUAL Y TAMBIEN SOLICITAR LOS PERMISOS
      _position = await Geolocator.getLastKnownPosition(); // LAT Y LNG
      animateCameraToPosition(_position.latitude, _position.longitude);
      addMarker(
          'repartidor',
          _position.latitude,
          _position.longitude,
          'Su posición',
          '',
          deliveryMarker
      );

      addMarker(
          'home',
          orden.direccion.latitud,
          orden.direccion.longitud,
          'Lugar de entrega',
          '',
          homeMarker
      );

      LatLng from = new LatLng(_position.latitude, _position.longitude);
      LatLng to = new LatLng(orden.direccion.latitud, orden.direccion.longitud);

      setPolylines(from, to);
      refresh();
    }
    catch (e) {
      print('Error: $e');
    }
  }

  void call() {
    launch("tel://${orden.cliente.telefono}");
  }

  void checkGPS() async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationEnabled) {
      updateLocation();
    } else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS) {
        updateLocation();
      }
    }
  }

  Future animateCameraToPosition(double latitud, double longitud) async {
    GoogleMapController controller = await _mapController.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitud, longitud), zoom: 13, bearing: 0)));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
