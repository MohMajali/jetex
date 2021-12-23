import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/alertdilog.dart';
import 'package:jettaexstores/config/Constant.dart';

Widget ProdcutsBoxs(context, String boxname, String rout) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, rout);
    },
    child: Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width / 2.3,
      decoration: BoxDecoration(
          color: PrimaryColor, borderRadius: BorderRadius.circular(15)),
      child: Center(
          child: Text(
        boxname,
        style: TitlesTextStyle,
      )),
    ),
  );
} //Product's container

final CbottomNavigationBar = BottomAppBar(
  child: Container(
    padding: EdgeInsets.all(5),
    //height: 56,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.wb_incandescent_rounded,
        ),
        Icon(
          Icons.chat,
        ),
        Icon(
          Icons.phone,
        ),
        Icon(
          Icons.settings,
        ),
      ],
    ),
  ),
);

final appBar = AppBar(
  foregroundColor: SecondryColor,
  backgroundColor: PrimaryColor,
  title: Text('te', style: TextStyle(color: SecondryColor)),
);

Widget Editbutton({double radios, onTap, IconData ico}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTap,
      child: CircleAvatar(
          radius: radios,
          child: Icon(
            ico,
            color: SecondryColor,
            size: 18,
          ),
          backgroundColor: PrimaryColor),
    ),
  );
}
