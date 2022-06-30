import 'package:app_burger_stone/src/pages/restaurant/categorias/create/restaurant_categorias_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:flutter/scheduler.dart';

class RestaurantCategoriasCreatePage extends StatefulWidget {
  const RestaurantCategoriasCreatePage({Key key}) : super(key: key);

  @override
  State<RestaurantCategoriasCreatePage> createState() => _RestaurantCategoriasCreatePageState();
}

class _RestaurantCategoriasCreatePageState extends State<RestaurantCategoriasCreatePage> {

  RestaurantCategoriasCreateController _con = new RestaurantCategoriasCreateController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva categoría'),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          _textFieldCategoria(),
          _textFieldDescripcion()
        ],
      ),
      bottomNavigationBar: _buttonCreate(),
    );
  }

  Widget _textFieldCategoria(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        controller: _con.nombreController,
        decoration: InputDecoration(
            hintText: 'Nombre de la categoría',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.list_alt,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

  Widget _textFieldDescripcion(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        controller: _con.descripcionController,
        maxLines: 3,
        maxLength: 255,
        decoration: InputDecoration(
            hintText: 'Nombre de la categoría',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.description,
              color: MyColors.primaryColor,
            )
        ) ,
      ),
    );
  }

  Widget _buttonCreate(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.createCategory,
        child: Text('Crear categoría'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            ),
            padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}