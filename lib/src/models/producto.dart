import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {

  String id;
  String nombre;
  String descripcion;
  String imagen1;
  String imagen2;
  String imagen3;
  double precio;
  int idCategoria;
  int cantidad;//quantity
  List<Producto> toList = [];


  Producto({
    this.id,
    this.nombre,
    this.descripcion,
    this.imagen1,
    this.imagen2,
    this.imagen3,
    this.precio,
    this.idCategoria,
    this.cantidad,
  });

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    id: json["id"] is int ? json["id"].toString() : json['id'],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
    imagen1: json["imagen1"],
    imagen2: json["imagen2"],
    imagen3: json["imagen3"],
    precio: json['precio'] is String ? double.parse(json["precio"]) : isInteger(json["precio"]) ? json["precio"].toDouble() : json['precio'],
    idCategoria: json["id_categoria"] is String ? int.parse(json["id_categoria"]) : json["id_categoria"],
    cantidad: json["cantidad"],
  );

  Producto.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null)
      return;
    jsonList.forEach((item) {
      Producto producto = Producto.fromJson(item); //convierto el item en category
      toList.add(producto);
    });
  }


  Map<String, dynamic> toJson() => {
    "id": id,
    "nombre": nombre,
    "descripcion": descripcion,
    "imagen1": imagen1,
    "imagen2": imagen2,
    "imagen3": imagen3,
    "precio": precio,
    "id_categoria": idCategoria,
    "cantidad": cantidad,
  };

  static bool isInteger(num value) => value is int || value == value.roundToDouble();
}