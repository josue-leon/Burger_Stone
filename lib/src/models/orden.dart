import 'dart:convert';

import 'package:app_burger_stone/src/models/direccion.dart';
import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/models/usuario.dart';

Orden ordenFromJson(String str) => Orden.fromJson(json.decode(str));

String ordenToJson(Orden data) => json.encode(data.toJson());

class Orden {

  String id;
  String idCliente;
  String idRepartidor;
  String idDireccion;
  String status;
  double latitud;
  double longitud;
  int timestamp;
  List<Producto> producto = [];
  List<Orden> toList = [];
  Usuario cliente;
  Usuario repartidor;
  Direccion direccion;

  Orden({
    this.id,
    this.idCliente,
    this.idRepartidor,
    this.idDireccion,
    this.status,
    this.latitud,
    this.longitud,
    this.timestamp,
    this.producto,
    this.cliente,
    this.repartidor,
    this.direccion
  });

  factory Orden.fromJson(Map<String, dynamic> json) =>
      Orden(
          id: json["id"] is int ? json["id"].toString() : json['id'],
          idCliente: json["id_cliente"],
          idRepartidor: json["id_repartidor"],
          idDireccion: json["id_direccion"],
          status: json["status"],
          latitud: json["latitud"] is String
              ? double.parse(json["latitud"])
              : json["latitud"],
          longitud: json["longitud"] is String
              ? double.parse(json["longitud"])
              : json["longitud"],
          timestamp: json["timestamp"] is String
              ? int.parse(json["timestamp"])
              : json["timestamp"],
          producto: json["producto"] != null ? List<Producto>.from(json["producto"].map((model) => model is Producto ? model : Producto.fromJson(model))) ?? [] : [],
          cliente: json['cliente'] is String ? usuarioFromJson(json['cliente']) : json['cliente'] is Usuario ? json['cliente'] : Usuario.fromJson(json['cliente'] ?? {}),
          repartidor: json['repartidor'] is String ? usuarioFromJson(json['repartidor']) : json['repartidor'] is Usuario ? json['repartidor'] : Usuario.fromJson(json['repartidor'] ?? {}),
          direccion: json['direccion'] is String ? direccionFromJson(json['direccion']) : json['direccion'] is Direccion ? json['direccion'] : Direccion.fromJson(json['direccion'] ?? {})
      );

  Orden.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null)
      return;
    jsonList.forEach((item) {
      Orden orden = Orden.fromJson(item); //convierto el item en category
      toList.add(orden);
    });
  }

  Map<String, dynamic> toJson() =>
      {
        "id": id,
        "id_cliente": idCliente,
        "id_repartidor": idRepartidor,
        "id_direccion": idDireccion,
        "status": status,
        "latitud": latitud,
        "longitud": longitud,
        "timestamp": timestamp,
        "producto": producto,
        "cliente": cliente,
        "repartidor": repartidor,
        "direccion": direccion
      };
}