import 'package:app_burger_stone/src/models/mercado_pago_credentials.dart';

//Conexión PC Erika
class Environment {
  static const String BURGER_STONE = "192.168.9.1:3000";
  static const String BURGER_STONE_KEY_MAPS = "AIzaSyADP2diBoqjnCBzaqKqAkqf0WB15bpIP6k";

  static MercadoPagoCredentials mercadoPagoCredentials = MercadoPagoCredentials(
      publicKey: 'TEST-98db4d5d-663a-453b-858e-f66dfd623666',
      accessToken: 'TEST-6028900970379574-062302-e3e5d11b7871ee742832e6351694608f-191014229'
  );
}

// Conexión PC Erika ESPOCH
/*class Environment {
  static const String BURGER_STONE = "172.25.235.131:3000";
}*/

//Conexión PC Andrea
/*
class Environment {
  static const String BURGER_STONE = "192.168.100.15:3000";
}
*/

//Conexión PC Josue
/*
class Environment {
  static const String BURGER_STONE = "192.168.0.120:3000";
}
*/