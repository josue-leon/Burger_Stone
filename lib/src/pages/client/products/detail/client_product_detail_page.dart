import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/pages/client/products/detail/client_product_detail_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ClientProductsDetailPage extends StatefulWidget {

  Producto producto;
  ClientProductsDetailPage({Key key, @required this.producto}) : super(key: key);

  @override
  State<ClientProductsDetailPage> createState() => _ClientProductsDetailPageState();
}

class _ClientProductsDetailPageState extends State<ClientProductsDetailPage> {

  ClientProductsDetailController _con = new ClientProductsDetailController();
  @override
  void initState() {
    //TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.producto);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          _imageSlideshow(),
          _textNombre(),
          _textDescripcion(),
          Spacer(),
          _addOrRemoveItem(),
          _standartDelivery(),
          _buttonShoppingBag()
        ],
      ),
    );
  }

  Widget _textNombre() {
    return Container(
      alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(right: 30, left: 30, top: 30),
      child: Text(
        _con.producto?.nombre ?? '',
        style: TextStyle(
          color: Colors.orange,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }

  Widget _textDescripcion() {
    return Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(right: 30, left: 30, top: 15),
        child: Text(
          _con.producto?.descripcion ?? '',
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey
          ),
        )
    );
  }

  Widget _buttonShoppingBag() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.addToBag,
        style: ElevatedButton.styleFrom(
          primary: MyColors.primaryColor,
          padding: EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14)
          )
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  '     AGREGAR A LA BOLSA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 6),
                height: 30,
                child: Image.asset('assets/img/bag.png'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _standartDelivery() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: [
          Image.asset(
            'assets/img/delivery.png',
            height: 20,
          ),
          SizedBox(width: 7),
          Text(
            'Envío estándar',
            style: TextStyle(
              fontSize: 13,
              color: Colors.red
            ),
          )
        ],
      )
    );
  }

  Widget _addOrRemoveItem() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17),
      child: Row(
        children: [
          IconButton(
              onPressed: _con.addItem,
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.green,
                size: 30,
              )
          ),
          Text(
            '${_con.counter}',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey
            ),
          ),
          IconButton(
              onPressed: _con.removeItem,
              icon: Icon(
                Icons.remove_circle_outline,
                color: Colors.pinkAccent,
                size: 30,
              )
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 16),
            child: Text(
              '${_con.productoPrecio ?? 0}\$',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                  ),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageSlideshow() {
    return Stack(
      children: [
        ImageSlideshow(
          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.4,
          initialPage: 0,
          indicatorColor: MyColors.primaryColor,
          indicatorBackgroundColor: Colors.grey,

          children: [
            FadeInImage(
              image: _con.producto?.imagen1 != null
                  ? NetworkImage(_con.producto.imagen1)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.producto?.imagen2 != null
                  ? NetworkImage(_con.producto.imagen2)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
            FadeInImage(
              image: _con.producto?.imagen3 != null
                  ? NetworkImage(_con.producto.imagen3)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.fill,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ],

          onPageChanged: (value) {
            print('Page changed: $value');
          },

          autoPlayInterval: 3000,

          isLoop: true,
        ),
        Positioned(
          left: 10,
          top: 5,
          child: IconButton(
            onPressed: _con.close,
            icon: Icon(Icons.arrow_back_ios,
            color: MyColors.primaryColor),
          ),
        )
      ],
    );
  }

  void refresh(){
    setState(() {

    });
  }
}
