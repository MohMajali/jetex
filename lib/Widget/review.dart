import 'package:flutter/material.dart';
import 'package:jettaexstores/config/Constant.dart';

class revied extends StatefulWidget {
  final String reviwee;

  const revied(
    this.reviwee,
  );

  @override
  State<revied> createState() => _reviedState();
}

class _reviedState extends State<revied> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: SecondryColor,
      ),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildListTile(
            widget.reviwee,
          ),

          // buildListTile(
          //     Icons.location_on, getLang(context, "StoreLocationEdit")),
        ],
      ),
    );
  }
}

Widget buildListTile(String fname) {
  return Padding(
    padding: const EdgeInsets.only(top: 30.0),
    child: Center(
      child: ListTile(
        title: Text(
          fname,
          textAlign: TextAlign.center,
          style: TextStyle(color: PrimaryColor),
        ),
      ),
    ),
  );
}
