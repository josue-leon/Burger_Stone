import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:app_burger_stone/src/models/categoria.dart';
import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/models/response_api.dart';
import 'package:app_burger_stone/src/provider/categorias_provider.dart';
import 'package:app_burger_stone/src/provider/products_provider.dart';
import 'package:app_burger_stone/src/utils/my_snackbar.dart';
import 'package:app_burger_stone/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestaurantProductsCreateController {
  BuildContext context;
  Function refresh;
// CONTROLADORES
  TextEditingController nombreController = new TextEditingController();
  TextEditingController descripcionController = new TextEditingController();
  MoneyMaskedTextController precioController= new MoneyMaskedTextController();

  CategoriasProvider _categoriasProvider = new CategoriasProvider();
  ProductsProvider _productsProvider = new ProductsProvider();

  Usuario usuario;
  SharedPref sharedPref = new SharedPref();
  //************varibles******************
  List<Categoria> categorias = [];
  String idCategoria;//almacena el id de la categoria seleccionada

  //IMAGENES

  PickedFile pickedFile;
  //importo la librera
  File imageFile1;
  File imageFile2;
  File imageFile3;
  ProgressDialog _progressDialog;


//llama a los metodos provider
  Future init(BuildContext context, Function refresh) async{
    this.context = context;
    this.refresh = refresh;
    _progressDialog = new ProgressDialog(context: context);
    usuario = Usuario.fromJson(await sharedPref.read('usuario'));
    _categoriasProvider.init(context, usuario);
    _productsProvider.init(context, usuario);
    getCategorias();
  }


  void getCategorias() async {
    categorias = await _categoriasProvider.getAll(); //devuelve una lista de categorias
    refresh(); //redibuja los elementos de la pantalla
  }

  void createProduct() async {
    String nombre = nombreController.text;
    String descripcion = descripcionController.text;
    double precio = precioController.numberValue;

    if (nombre.isEmpty || descripcion.isEmpty || precio == 0) {
      MySnackbar.show(context, 'Debe ingresar todos los campos');
      return;
    }
    if (imageFile1 == null || imageFile2 == null || imageFile3 == null) {
      MySnackbar.show(context, 'Selecciona las tres imagenes');
      return;
    }
    if (idCategoria == null) {// el usuairo aun no selecciona
      MySnackbar.show(context, 'Selecciona la categoria del producto');
      return;
    }
//esto debemos importar de nuestros modelos
    Producto producto = new Producto(
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        idCategoria: int.parse(idCategoria)
    );

    List<File> images= [];
    images.add(imageFile1);
    images.add(imageFile2);
    images.add(imageFile3);

    _progressDialog.show(max: 100, msg: 'Espere un momento');
    Stream stream = await _productsProvider.create(producto,images);
    //capturar la respuesta de node js
    stream.listen((res) {
      _progressDialog.close();

      ResponseApi responseApi= ResponseApi.fromJson(json.decode(res));
      MySnackbar.show(context, responseApi.message);
      if(responseApi.success){
        resetValues();
      }
    });
    print('Formulario Producto: ${producto.toJson()}');
  }


  // metodo para limpiar el formulario

  void resetValues(){

    nombreController.text ='';
    descripcionController.text ='';
    precioController.text='0.0';
    imageFile1= null;
    imageFile2= null;
    imageFile3= null;
    idCategoria = null;
    refresh();
  }
  //METODO IMAGENES

  Future selectImage(ImageSource imageSource, int numberFile) async {
    pickedFile = await ImagePicker().getImage(source: imageSource);
    if (pickedFile != null) {
      if (numberFile == 1) {
        imageFile1 = File(pickedFile.path);
      } else if (numberFile == 2) {
        imageFile2 = File(pickedFile.path);
      } else if (numberFile == 3) {
        imageFile3 = File(pickedFile.path);
      }
    }
    Navigator.pop(context);
    refresh();
  }


// Tomar fotografia o seleccion de imagen

  void showAlertDialog(int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.gallery, numberFile);
        },
        child: Text('GALERIA'));

    Widget cameraButton = ElevatedButton(
        onPressed: () {
          selectImage(ImageSource.camera, numberFile);
        },
        child: Text('CÁMARA'));

    AlertDialog alertDialog = AlertDialog(
      title: Text('Seleccione su imagen'),
      actions: [galleryButton, cameraButton],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}