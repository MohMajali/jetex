import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;

class ProductModel extends StatefulWidget {
  final int id;
  const ProductModel({Key key, this.id}) : super(key: key);

  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  TextEditingController model = TextEditingController();
  List<ProductsApi> products = [];
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

  Future<bool> updateModel(var id, String model) async {
    try {
      final response = await http.post(Uri.parse(Api.updateModelNumber),
          body: {"id": id.toString(), "model_number": model});

      var json = jsonDecode(response.body);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "model"),
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
                    getLang(context, "modelNumber"),
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
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: TextFormField(
              controller: model,
              style: TextStyle(color: PrimaryColor, fontSize: 15),
              keyboardType: TextInputType.text,
              maxLength: 100,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: PrimaryColor),
                    borderRadius: BorderRadius.circular(2)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                hintText: products.length == 0
                    ? ""
                    : products[0] == null
                        ? "Model Number"
                        : products[0].modelNumber,
                hintStyle: TextStyle(color: PrimaryColor),
              ),
            ),
          ),
          TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: SecondryColor)))),
              onPressed: () async {
                String modelTxt = model.text;
                await updateModel(widget.id, modelTxt);

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
