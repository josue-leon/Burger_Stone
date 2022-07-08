import 'dart:convert';

Direccion direccionFromJson(String str) => Direccion.fromJson(json.decode(str));

String direccionToJson(Direccion data) => json.encode(data.toJson());

class Direccion {
  Direccion({
    this.id,
    this.idUsuario,
    this.direccion,
    this.vecindario,
    this.latitud,
    this.longitud,
  });

  String id;
  String idUsuario;
  String direccion;
  String vecindario;
  double latitud;
  double longitud;
  List<Direccion> toList = [];

  factory Direccion.fromJson(Map<String, dynamic> json) => Direccion(
    id: json["id"] is int ? json['id'].toString() : json['id'],
    idUsuario: json["id_usuario"],
    direccion: json["direccion"],
    vecindario: json["vecindario"],
    latitud: json["latitud"] is String ? double.parse(json["latitud"]) : json["latitud"],
    longitud: json["longitud"] is String ? double.parse(json["longitud"]) : json["longitud"],
  );

  Direccion.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null)
      return;
    jsonList.forEach((item) {
      Direccion direccion = Direccion.fromJson(item); //convierto el item en category
      toList.add(direccion);
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_usuario": idUsuario,
    "direccion": direccion,
    "vecindario": vecindario,
    "latitud": latitud,
    "longitud": longitud,
  };
}