import 'dart:convert';

import 'package:app_burger_stone/src/models/rol.dart';

// Creación de la clase usuario para el registro de usuario y para almacenar los datos en la db

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  String
      id; //se le cambio a tipo dynamic está recibiendo es inconsistente. Algunos datos son int, algunos son cadenas.
  String cedula;
  String email;
  String nombre;
  String apellido;
  String telefono;
  String imagen;
  String password;
  String sessionToken;
  List<Rol> roles = [];
  List<Usuario> toList = [];

  // Constructor de la clase
  Usuario(
      {this.id,
      this.cedula,
      this.email,
      this.nombre,
      this.apellido,
      this.telefono,
      this.imagen,
      this.password,
      this.sessionToken,
      this.roles});

  // Mapa de valores Json que retorna un objeto usuario
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"] is int ? json['id'].toString() : json["id"],
        cedula: json["cedula"],
        email: json["email"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        telefono: json["telefono"],
        imagen: json["imagen"],
        password: json["password"],
        sessionToken: json["session_token"],
        roles: json["roles"] == null
            ? []
            : List<Rol>.from(
                    json['roles'].map((model) => Rol.fromJson(model))) ??
                [],
      );

  Usuario.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null)
      return;
    jsonList.forEach((item) {
      Usuario usuario = Usuario.fromJson(item); //convierto el item en category
      toList.add(usuario);
    });
  }

  // Objeto Json que toma los valores que se ingresa y lo transforma a json
  Map<String, dynamic> toJson() => {
        "id": id,
        "cedula": cedula,
        "email": email,
        "nombre": nombre,
        "apellido": apellido,
        "telefono": telefono,
        "imagen": imagen,
        "password": password,
        "session_token": sessionToken,
        "roles": roles,
      };
}
