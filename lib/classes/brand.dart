import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/brand.dart';
import 'package:jettaexstores/Module/brandspro.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:jettaexstores/main.dart';

class ProductBrand extends StatefulWidget {
  final int id;
  const ProductBrand({Key key, this.id}) : super(key: key);

  @override
  _ProductBrandState createState() => _ProductBrandState();
}

class _ProductBrandState extends State<ProductBrand> {
  String _brand;
  List<Brandspro> brandpro = [];
  List<Brands> brand = [];
  var lang = sharedPreferences.getString("lang");

  Future insertBrand(int id, var brand) async {
    try {
      String url = Api.InsertBrand;
      final response = await http.post(Uri.parse(url),
          body: {"id": id.toString(), "brand_id": brand.toString()});

      var json = jsonDecode(response.body);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "branadded"),
            style: TextStyle(color: PrimaryColor),
          ),
          action: SnackBarAction(label: '', onPressed: () {}),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (x) {
      print(x);
    }
  }

  Future _getBrands() async {
    try {
      String url = Api.getBrands;

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<Brands> brandList = brandsFromJson(response.body);

        return brandList;
      } else {
        // ignore: deprecated_member_use
        return List<Brands>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future<List<Brandspro>> _getBrand(var proid) async {
    String url = Api.getBrand + proid.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Brandspro> brandList = brandsproFromJson(response.body);

      return brandList;
    } else {
      // ignore: deprecated_member_use
      return List<Brandspro>();
    }
  }

  @override
  void initState() {
    super.initState();
    _getBrands().then((brandList) {
      brand = brandList;
    });

    _getBrand(widget.id).then((brandList) {
      setState(() {
        brandpro = brandList;
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _brand,
                        iconSize: 30,
                        icon: const Icon(Icons.add),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: brandpro.length == 0
                            ? Text(
                                getLang(context, "brand"),
                                style: TextStyle(color: PrimaryColor),
                              )
                            : lang == 'ar'
                                ? Text(
                                    brandpro[0].nameAr,
                                    style: TextStyle(color: PrimaryColor),
                                  )
                                : Text(
                                    brandpro[0].nameEn,
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                        onChanged: (String newValue) {
                          setState(() async {
                            _brand = newValue;

                            await insertBrand(widget.id, _brand);
                          });
                        },
                        items: brand.map((brands) {
                              return DropdownMenuItem(
                                  value: brands.id.toString(),
                                  child: lang == 'ar'
                                      ? Text(
                                          brands.nameAr,
                                          style: TextStyle(color: Colors.black),
                                        )
                                      : Text(
                                          brands.nameEn,
                                          style: TextStyle(color: Colors.black),
                                        ));
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ],
    ));
  }
}
