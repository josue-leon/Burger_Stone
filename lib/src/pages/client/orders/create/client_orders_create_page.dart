import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/pages/client/orders/create/client_orders_create_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:app_burger_stone/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ClientOrdersCreatePage extends StatefulWidget {
  const ClientOrdersCreatePage({Key key}) : super(key: key);

  @override
  State<ClientOrdersCreatePage> createState() => _ClientOrdersCreatePageState();
}

class _ClientOrdersCreatePageState extends State<ClientOrdersCreatePage> {
  ClientOrdersCreateController _con = new ClientOrdersCreateController();

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
        title: Text('Mi orden'),
      ),
      bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            children: [
              Divider(
                color: Colors.grey[400],
                endIndent: 20, //Margen en la Derecha
                indent: 20, // Margen en la Izquierda
              ),
              _textTotalPrecio(),
              _buttonNext()
            ],
          )),
      body: _con.selectedProductos.length > 0
          ? ListView(
              children: _con.selectedProductos.map((Producto producto) {
                return _cardProducto(producto);
              }).toList(),
            )
          : NoDataWidget( text: 'Ningún producto agregado'),
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 40, bottom: 30),
      child: ElevatedButton(
        onPressed: _con.goToAddress,
        style: ElevatedButton.styleFrom(
            primary: Colors.amber,
            padding: EdgeInsets.symmetric(vertical: 5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14))),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  'CONTINUAR',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 80, top: 10),
                height: 30,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.blueGrey,
                  size: 30,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cardProducto(Producto producto) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imagenProducto(producto),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                producto?.nombre ?? '',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _addOrRemoveItem(producto)
            ],
          ),
          Spacer(),
          Column(
            children: [_textPrecio(producto), _iconDelete(producto)],
          )
        ],
      ),
    );
  }

  Widget _iconDelete(Producto producto) {
    return IconButton(
        onPressed: () {
          _con.deleteItem(producto);
        },
        icon: Icon(Icons.delete, color: MyColors.primaryColor));
  }

  Widget _textTotalPrecio() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TOTAL:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          Text(
            '${_con.total}\$',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
  }

  Widget _textPrecio(Producto producto) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        '${producto.precio * producto.cantidad}',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _imagenProducto(Producto producto) {
    return Container(
      width: 90,
      height: 90,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.amber),
      child: FadeInImage(
        image: producto.imagen1 != null
            ? NetworkImage(producto.imagen1)
            : AssetImage('assets/img/no-image.png'),
        fit: BoxFit.contain,
        fadeInDuration: Duration(milliseconds: 50),
        placeholder: AssetImage('assets/img/no-image.png'),
      ),
    );
  }

  Widget _addOrRemoveItem(Producto producto) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            _con.removeItem(producto);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
                color: Colors.yellow[100]),
            child: Text('-'),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          color: Colors.amber,
          child: Text('${producto?.cantidad ?? 0}'),
        ),
        GestureDetector(
          onTap: () {
            _con.addItem(producto);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: Colors.yellow[100]),
            child: Text('+'),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
