import 'package:flutter/material.dart';



//No Dara wifget es para que no cambien el estado es de algo fijo
class  NoDataWidget extends StatelessWidget {

  String text;

 NoDataWidget ({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/img/no_items.png'),
        Text(text)
        ],
      ),
    );
  }
}

