import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jettaexstores/Module/brandspro.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;

class Warrenty extends StatefulWidget {
  final int id;
  const Warrenty({Key key, this.id}) : super(key: key);

  @override
  _WarrentyState createState() => _WarrentyState();
}

class _WarrentyState extends State<Warrenty> {
  TextEditingController warranty = TextEditingController();
  List<ProductsApi> products = [];

  Future<bool> updateWarranty(var id, String warranty) async {
    try {
      final response = await http.post(Uri.parse(Api.updateWarranty),
          body: {"id": id.toString(), "warranty": warranty});

      var json = jsonDecode(response.body);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "warrentyadded"),
            style: TextStyle(color: PrimaryColor),
          ),
          action: SnackBarAction(label: '', onPressed: () {}),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return true;
    } catch (x) {
      print(x);
      return false;
    }
  }

  Future<List<ProductsApi>> _getData(int id) async {
    try {
      String url = Api.productViewEdit + id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<ProductsApi> productsList =
            productsApiFromJson(response.body);
        return productsList;
      } else {
        // ignore: deprecated_member_use
        return List<ProductsApi>();
      }
    } catch (x) {
      print(x);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.id).then((productsList) {
      setState(() {
        products = productsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .8,
                  child: Text(
                    getLang(context, "warranty"),
                    style: TextStyle(
                      fontSize: 20,
                      color: PrimaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: TextFormField(
                controller: warranty,
                inputFormatters: [
                  WhitelistingTextInputFormatter(RegExp("[0-9]"))
                ],
                style: TextStyle(color: PrimaryColor, fontSize: 15),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: PrimaryColor),
                      borderRadius: BorderRadius.circular(2)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  hintText: products.length == 0
                      ? ""
                      : products[0].warranty == null
                          ? "Warranty"
                          : products[0].warranty.toString(),
                  hintStyle: TextStyle(color: PrimaryColor),
                )),
          ),
          TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: SecondryColor)))),
              onPressed: () async {
                String warrantyTxt = warranty.text;
                await updateWarranty(widget.id, warrantyTxt);

                await _getData(widget.id).then((productsList) {
                  setState(() {
                    products = productsList;
                  });
                });
              },
              child: Text(
                getLang(context, "Save"),
                style: TextStyle(color: SecondryColor),
              )),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
