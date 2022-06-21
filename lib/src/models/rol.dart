
import 'dart:convert';

Rol rolFromJson(String str) => Rol.fromJson(json.decode(str));

String rolToJson(Rol data) => json.encode(data.toJson());

class Rol {
  Rol({
    this.id,
    this.nombre,
    this.imagen,
    this.ruta,
  });

  String id;
  String nombre;
  String imagen;
  String ruta;

  factory Rol.fromJson(Map<String, dynamic> json) => Rol(
    id: json["id"] is int ? json['id'].toString() : json["id"],
    nombre: json["nombre"],
    imagen: json["imagen"],
    ruta: json["ruta"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "imagen": imagen,
    "ruta": ruta,
  };
}
