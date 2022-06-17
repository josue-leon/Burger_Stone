import 'dart:convert';

// Creación de la clase usuario para el registro de usuario y para almacenar los datos en la db

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {

  int id;
  String cedula;
  String email;
  String nombre;
  String apellido;
  String telefono;
  String imagen;
  String password;
  String sessionToken;

  // Constructor de la clase
  Usuario({
    this.id,
    this.cedula,
    this.email,
    this.nombre,
    this.apellido,
    this.telefono,
    this.imagen,
    this.password,
    this.sessionToken,
  });

  // Mapa de valores Json que retorna un objeto usuario
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json["id"],
    cedula: json["cedula"],
    email: json["email"],
    nombre: json["nombre"],
    apellido: json["apellido"],
    telefono: json["telefono"],
    imagen: json["imagen"],
    password: json["password"],
    sessionToken: json["session_token"],
  );

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
  };
}