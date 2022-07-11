import 'package:app_burger_stone/src/models/orden.dart';
import 'package:app_burger_stone/src/models/producto.dart';
import 'package:app_burger_stone/src/models/usuario.dart';
import 'package:app_burger_stone/src/pages/restaurant/orders/detail/restaurant_orders_detail_controller.dart';
import 'package:app_burger_stone/src/utils/my_colors.dart';
import 'package:app_burger_stone/src/utils/relative_time_util.dart';
import 'package:app_burger_stone/src/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RestaurantOrdersDetailPage extends StatefulWidget
{
  Orden orden;

  RestaurantOrdersDetailPage({Key key, @required this.orden}) : super(key: key);

  @override
  State<RestaurantOrdersDetailPage> createState() => _RestaurantOrdersDetailPageState();
}

class _RestaurantOrdersDetailPageState extends State<RestaurantOrdersDetailPage> {
  RestaurantOrdersDetailController _con = new RestaurantOrdersDetailController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, widget.orden);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orden # ${_con.orden?.id ?? ''}'),
        actions: [
          Container(
            margin: EdgeInsets.only(top: 18, right: 15),
            child: Text(
              'TOTAL: \$ ${_con.total}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height * 0.52,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Divider(
                  color: Colors.grey[400],
                  endIndent: 20, //Margen en la Derecha
                  indent: 20, // Margen en la Izquierda
                ),
                SizedBox(height: 5),
                _textDescription(),
                SizedBox(height: 10),
                _con.orden.status != 'PAGADO' ? _deliveryData() : Container(),
                _con.orden.status == 'PAGADO' ? _dropDown(_con.usuarios) : Container(),
                _textData('Cliente:', '${_con.orden?.cliente?.nombre ?? ''} ${_con.orden?.cliente?.apellido ?? ''}'),
                _textData('Entregar en:', '${_con.orden?.direccion?.direccion ?? ''}'),
                _textData(
                    'Fecha de pedido:',
                    '${RelativeTimeUtil.getRelativeTime(_con.orden?.timestamp ?? 0)}'),
                _con.orden.status == 'PAGADO' ? _buttonNext() : Container()
              ],
            ),
          )),
      body: _con.orden.producto.length > 0
          ? ListView(
              children: _con.orden.producto.map((Producto producto) {
                return _cardProducto(producto);
              }).toList(),
            )
          : NoDataWidget( text: 'Ningún producto agregado'),
    );
  }

  Widget _textDescription() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        _con.orden.status == 'PAGADO' ? 'Asignar repartidor' : 'Repartidor asignado',
        style: TextStyle(
          fontStyle: FontStyle.italic,
          color: MyColors.primaryColor
        ),
      ),
    );
  }

  Widget _dropDown(List<Usuario> usuarios) {
    // return Material(
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 29, vertical: 15),
      child: Material(
        elevation: 2.0,
        //es para dar una sobra
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        //redondear los bordes
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
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
                      'Repartidores',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    items: _dropDownItems(usuarios),
                    value: _con.idRepartidor,
                    onChanged: (option) {
                      setState(() {
                        print('Repartidor seleccionado $option'); //muestra el id de la categoria seleccionada
                        _con.idRepartidor = option; //establecineod el valor selecionado a la variable id category
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _deliveryData() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Container(
            height: 40,
            width:40,
            child: FadeInImage(
              image: _con.orden.repartidor?.imagen != null
                  ? NetworkImage(_con.orden.repartidor?.imagen)
                  : AssetImage('assets/img/no-image.png'),
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          SizedBox(width: 5),
          Text('${_con.orden.repartidor?.nombre ?? ''} ${_con.orden.repartidor?.apellido ?? ''}')
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<Usuario> usuarios) {
    List<DropdownMenuItem<String>> list = [];
    usuarios.forEach((usuario) {
      list.add(DropdownMenuItem(
        child: Row(
          children: [
            Container(
              height: 40,
              width:40,
              child: FadeInImage(
                image: usuario.imagen != null
                    ? NetworkImage(usuario.imagen)
                    : AssetImage('assets/img/no-image.png'),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage('assets/img/no-image.png'),
              ),
            ),
            SizedBox(width: 5),
            Text(usuario.nombre)
          ],
        ),
        value: usuario.id,
      ));
    });
    return list;
  }

  Widget _textData(String title, String contenido) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: ListTile(
          title: Text(title),
          subtitle: Text(
              contenido,
              maxLines: 2
          ),
        )
    );
  }

  Widget _buttonNext() {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, top: 5, bottom: 20),
      child: ElevatedButton(
        onPressed: _con.updateOrden,
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
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  'DESPACHAR ORDEN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(left: 50, top: 5),
                height: 30,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
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
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                  fontSize: 13
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Precio: \$ ${producto.precio}',
                style: TextStyle(
                    fontSize: 12
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 4),
              Text(
                'Cantidad: ${producto.cantidad}',
                style: TextStyle(
                    fontSize: 12
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imagenProducto(Producto producto) {
    return Container(
      width: 50,
      height: 50,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
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

  void refresh() {
    setState(() {});
  }
}
