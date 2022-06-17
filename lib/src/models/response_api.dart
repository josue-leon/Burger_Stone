import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

// Para el error
class ResponseApi
{
  String mensaje;
  String error;
  bool success;
  dynamic data;

  ResponseApi({
    this.mensaje,
    this.error,
    this.success,
  });

  ResponseApi.fromJson(Map<String, dynamic> json)
  {
    mensaje = json["mensaje"];
    error = json["error"];
    success = json["success"];

    try
    {
      data = json['data'];
    }
    catch(e) 
    {
      print('Exception data $e');
    }
  }
  Map<String, dynamic> toJson() => {
    "mensaje": mensaje,
    "error": error,
    "success": success,
  };
}
