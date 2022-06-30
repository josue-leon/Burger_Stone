import 'dart:convert';

Categoria categoriaFromJson(String str) => Categoria.fromJson(json.decode(str));

String categoriaToJson(Categoria data) => json.encode(data.toJson());

class Categoria {
  Categoria({
    this.id,
    this.nombre,
    this.descripcion,
  });

  String id;
  String nombre;
  String descripcion;

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
    id: json["id"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "descripcion": descripcion,
  };
}
