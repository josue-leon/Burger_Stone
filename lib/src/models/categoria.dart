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
  List<Categoria>toList=[];

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
    id: json["id"] is int ? json["id"].toString() : json['id'],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
  );

  Categoria.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null)
      return;
      jsonList.forEach((item) {
      Categoria categoria = Categoria.fromJson(item); //convierto el item en category
      toList.add(categoria);
    });
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "descripcion": descripcion,
  };
}
