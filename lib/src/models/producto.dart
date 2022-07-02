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
    id: json["id"],
    nombre: json["nombre"],
    descripcion: json["descripcion"],
    imagen1: json["imagen1"],
    imagen2: json["imagen2"],
    imagen3: json["imagen3"],
    precio: json["precio"].toDouble(),
    idCategoria: json["id_categoria"],
    cantidad: json["cantidad"],
  );

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
}