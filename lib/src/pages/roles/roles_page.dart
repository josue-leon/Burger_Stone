import 'package:app_burger_stone/src/pages/roles/roles_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/rol.dart';
import 'package:flutter/scheduler.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key key}) : super(key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {

  RolesController _con = new RolesController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        title: Text('Selecciona un Rol'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.14),
        child: ListView(
          children: _con.usuario != null ? _con.usuario.roles.map((Rol rol) {
            return _cardRol(rol);
          }).toList():[],
        ),
      ),
    );
  }

  //Elemento que muestra las imagenes de cada rol que tiene el usuario

  Widget _cardRol(Rol rol){
    return GestureDetector(
      onTap: (){
        _con.goToPage(rol.ruta);
      },
      child: Column(
        children: [
          Container(
            height: 100,
            child: FadeInImage(
              image: rol.imagen != null
                  ? NetworkImage(rol.imagen)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),

            ),
          ),
          SizedBox(height: 15),
          Text(
            rol.nombre ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          ),
          SizedBox(height: 25)
        ],
      ),
    );
  }

  void refresh(){
    setState(() { //actualiza los cambios
    });
  }
}
