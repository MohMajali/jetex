import 'package:flutter/material.dart';
import 'package:jettaexstores/config/Constant.dart';

class revied extends StatefulWidget {
  final String namee;
  final String reviwee;

  const revied(
    this.namee,
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
          Container(
            child: Center(
                child: Text(
              widget.namee,
              style: TextStyle(
                  color: SecondryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: PrimaryColor,
            ),
            padding: EdgeInsets.all(5),
            width: double.infinity,
          ),
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
