import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;

class Description extends StatefulWidget {
  final int id;
  const Description({Key key, this.id}) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController den = TextEditingController();
  TextEditingController der = TextEditingController();

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

  Future<bool> updateADesc(var id, String ARDesc) async {
    try {
      final response = await http.post(Uri.parse(Api.updateProADesc),
          body: {"id": id.toString(), "description_ar": ARDesc});

      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "descAdded"),
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

  Future<bool> updateEDesc(var id, String eDesc) async {
    try {
      final response = await http.post(Uri.parse(Api.updateProEDesc),
          body: {"id": id.toString(), "description_en": eDesc.toString()});

      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "descAdded"),
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
    return Container(
      height: MediaQuery.of(context).size.height * 1,
      child: SingleChildScrollView(
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
                        getLang(context, "descEn"),
                        style: TextStyle(
                          fontSize: 20,
                          color: PrimaryColor,
                        ),
                      )),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  0,
                  MediaQuery.of(context).size.width * .05,
                  0),
              color: SecondryColor,
              child: TextFormField(
                  maxLines: 10,
                  controller: den,
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: products.length == 0
                        ? getLang(context, "descEnglish")
                        : products[0].descriptionEn == null
                            ? getLang(context, "descEnglish")
                            : products[0].descriptionEn,
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
                  String englishDescription = den.text;
                  await updateEDesc(widget.id, englishDescription);

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
                        getLang(context, "descAr"),
                        style: TextStyle(
                          fontSize: 20,
                          color: PrimaryColor,
                        ),
                      )),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              color: SecondryColor,
              child: TextFormField(
                maxLines: 10,
                controller: der,
                style: TextStyle(color: PrimaryColor, fontSize: 15),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: products.length == 0
                        ? getLang(context, "descArabic")
                        : products[0].descriptionAr == null
                            ? getLang(context, "descArabic")
                            : products[0].descriptionAr,
                    hintStyle: TextStyle(color: PrimaryColor)),
              ),
            ),
            TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: SecondryColor)))),
                onPressed: () async {
                  String arabicDiscription = der.text;
                  await updateADesc(widget.id, arabicDiscription);

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
          ],
        ),
      ),
    );
  }
}
