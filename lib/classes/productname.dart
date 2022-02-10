import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;

class ProductName extends StatefulWidget {
  final int id;
  const ProductName({Key key, this.id}) : super(key: key);

  @override
  _ProductNameState createState() => _ProductNameState();
}

class _ProductNameState extends State<ProductName> {
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
      print(x.toString());
    }
  }

  Future<bool> updateAName(var id, String name_ar) async {
    try {
      final response = await http.post(Uri.parse(Api.updateProAName),
          body: {"id": id.toString(), "name_ar": name_ar});

      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "productadded"),
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

  Future<bool> updateEName(var id, String name_en) async {
    try {
      final response = await http.post(Uri.parse(Api.updateProEName),
          body: {"id": id.toString(), "name_en": name_en});

      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "productadded"),
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

  TextEditingController en = TextEditingController();
  TextEditingController ar = TextEditingController();

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
          SizedBox(
            height: 15,
          ),
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
                      getLang(context, "ProductinEnglish"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
          Container(
              height: 60,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  0,
                  MediaQuery.of(context).size.width * .05,
                  0),
              color: SecondryColor,
              child: TextFormField(
                  controller: en,
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: products.length == 0
                        ? getLang(context, "productEn")
                        : products[0].nameEn == null
                            ? getLang(context, "productEn")
                            : products[0].nameEn,
                    hintStyle: TextStyle(color: PrimaryColor),
                  ))),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: SecondryColor)))),
              onPressed: () async {
                String englishName = en.text;
                await updateEName(widget.id, englishName);

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
                      getLang(context, "ProductinArabic"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
          Container(
              height: 60,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .05,
                right: MediaQuery.of(context).size.width * .05,
                top: MediaQuery.of(context).size.width * .012,
              ),
              color: SecondryColor,
              child: TextFormField(
                  controller: ar,
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: products.length == 0
                        ? getLang(context, "productAr")
                        : products[0].nameAr == null
                            ? getLang(context, "productAr")
                            : products[0].nameAr,
                    hintStyle: TextStyle(color: PrimaryColor),
                  ))),
          SizedBox(
            height: 10,
          ),
          TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: SecondryColor)))),
              onPressed: () async {
                String arabicName = ar.text;
                await updateAName(widget.id, arabicName);

                setState(() {
                  _getData(widget.id).then((productsList) {
                    setState(() {
                      products = productsList;
                    });
                  });
                });
              },
              child: Text(
                getLang(context, "Save"),
                style: TextStyle(color: SecondryColor),
              )),
        ],
      ),
    );
  }
}
