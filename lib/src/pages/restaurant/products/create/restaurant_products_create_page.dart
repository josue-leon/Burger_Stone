import 'dart:io';

import 'package:app_burger_stone/src/models/categoria.dart';
import 'package:app_burger_stone/src/pages/restaurant/categorias/create/restaurant_categorias_create_controller.dart';
import 'package:app_burger_stone/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:flutter/scheduler.dart';

class RestaurantProductsCreatePage extends StatefulWidget {
  const RestaurantProductsCreatePage({Key key}) : super(key: key);

  @override
  State<RestaurantProductsCreatePage> createState() => _RestaurantProductsCreatePageState();
}

class _RestaurantProductsCreatePageState extends State<RestaurantProductsCreatePage> {

  RestaurantProductsCreateController _con = new RestaurantProductsCreateController();

  @override

  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
/*
***********PRODUCTOS***********************
 */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo producto'),
      ),
      body: ListView(children: [
        SizedBox(height: 30),
        _textFieldName(),
        _textFieldDescripcion(),
        _textFieldPrice(),
        Container(
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _cardImage(_con.imageFile1, 1),
              _cardImage(_con.imageFile2, 2),
              _cardImage(_con.imageFile3, 3),
            ],
          ),
        ),
        _dropDownCategories(_con.categorias),
      ]),
      bottomNavigationBar: _buttonCreate(),
    );
  }
/*
**********WIDGET NOMBRE PRODUCTO***
 * */
  Widget _textFieldName(){
    return Container(
      padding:EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        controller: _con.nombreController,
        maxLines:1,//separacion
        maxLength: 180,//para los caracteres
        decoration: InputDecoration(
            hintText: 'Nombre del producto',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.local_pizza,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }
/*
*****WIDGET PRECIO PRODUCTO*******
* */
  Widget _textFieldPrice(){
    return Container(
      padding:EdgeInsets.symmetric(horizontal:10),
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(12)
      ),
      child: TextField(
        controller: _con.precioController,
        keyboardType: TextInputType.phone,//para escribir numeros en ese campo de texto
        maxLines:1,//separacion
        decoration: InputDecoration(
            hintText: 'Precio',
            hintStyle: TextStyle(
                color: MyColors.primaryColor
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.monetization_on,
              color: MyColors.primaryColor ,)
        ) ,
      ),
    );
  }

/*
*****PARA SELECIONAR LA SCATEGORIAS***********
* */
  Widget _dropDownCategories(List<Categoria> categorias) {
    // return Material(
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 33),
      child: Material(
        elevation: 2.0,
        //es para dar una sobra
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        //redondear los bordes
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  // Material(
                  // elevation:0,
                  // color:Colors.white,
                  // borderRadius:BorderRadius.all(Radius.circular(30)),
                  //child:Icon(
                  Icon(
                    Icons.search,
                    color: MyColors.primaryColor,
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Categorias',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DropdownButton(
                    //selector de categorias
                    underline: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down_circle,
                        color: MyColors.primaryColor,
                      ),
                    ),
                    elevation: 3,
                    isExpanded: true,
                    hint: Text(
                      'Seleccionar categoria',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    items: _dropDownItems(categorias),
                    value: _con.idCategoria,
                    onChanged: (option) {
                      setState(() {
                        //para refescar la pagina
                        print('Categoria seleccionada $option'); //muestra el id de la categoria seleccionada
                        _con.idCategoria = option; //establecineod el valor selecionado a la variable id category
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Categoria> categorias) {
    List<DropdownMenuItem<String>> list = [];
    categorias.forEach((categoria) {
      list.add(DropdownMenuItem(
        child: Text(categoria.nombre),
        value: categoria.id,
      ));
    });
    return list;
  }
/*
********WIDGET DESCRIPCION PRODUCTO***********
* */
  Widget _textFieldDescripcion(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
            hintText: 'Descripción del producto',
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
/*
*PARA SELECIONAR LAS IMAGENES PANTALLA PRODUCTO
 */
  Widget _cardImage(File imageFile, int numberFile) {
    return GestureDetector(
      onTap: () {
        _con.showAlertDialog(numberFile);
      },
      child: imageFile != null
          ? Card(
              elevation: 3.0,
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : Card(
              elevation: 3.0,
              child: Container(
                height: 140,
                width: MediaQuery.of(context).size.width * 0.26,
                child: Image(
                  image: AssetImage('assets/img/add_image.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
    );
  }
/*
************BOTON PARA CREAR PRODCUTO***********************
* */
  Widget _buttonCreate(){
    return Container(
      height: 50,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: ElevatedButton(
        onPressed: _con.createProduct,
        child: Text('Crear producto'),
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