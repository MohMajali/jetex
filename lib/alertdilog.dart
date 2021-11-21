import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Constant.dart';

import 'Module/SingleProduct.dart';

class cad extends StatefulWidget {
  final String nameen;
  final String desen;
  final String desar;
  final String namear;
  final String price;
  final String imag;

  const cad(
      this.nameen, this.desen, this.desar, this.price, this.namear, this.imag);

  @override
  State<cad> createState() => _cadState();
}

class _cadState extends State<cad> {
  List<Product> products = [];
  dynamic storeData;
  String imageUrl = 'http://45.76.132.167/productImages/';
  Future<List<Product>> _getData() async {
    String url = 'http://45.76.132.167/api/authentication/product.php?id=';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Product> productsList = productFromJson(response.body);
      return productsList;
    } else {
      // ignore: deprecated_member_use
      return List<Product>();
    }
  }

  @override
  void initState() {
    super.initState();

    _getData().then((productsList) {
      setState(() {
        products = productsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.imag);
    return FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
                child: Container(
              child: Text('Loading...'),
            ));
          } else {
            return Container(
              height: MediaQuery.of(context).size.height * .6,
              width: MediaQuery.of(context).size.width * .75,
              decoration: BoxDecoration(
                color: SecondryColor,
              ),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .25,
                    width: MediaQuery.of(context).size.width * .65,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 3,
                          color: PrimaryColor,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        image: DecorationImage(
                            image: widget.imag.isNotEmpty
                                ? NetworkImage(widget.imag)
                                : NetworkImage(
                                    'https://images-na.ssl-images-amazon.com/images/I/513CiKyzUWL.jpg'),
                            fit: BoxFit.fill)),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Container(
                    child: Center(
                        child: Text(
                      widget.nameen,
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
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Center(
                        child: Text(
                      widget.desen,
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
                  SizedBox(
                    height: 15,
                  ),

                  Container(
                    child: Center(
                        child: Text(
                      widget.namear,
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
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Center(
                        child: Text(
                      widget.nameen,
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
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Center(
                        child: Text(
                      widget.price + "\$",
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
                  // buildListTile(Icons.money_off, widget.price),
                  // buildListTile(
                  //     Icons.location_on, getLang(context, "StoreLocationEdit")),
                ],
              ),
            );
          }
        });
  }

  ListTile buildListTile(IconData icon, String fname) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xffedb54f),
      ),
      title: Text(
        fname,
        textAlign: TextAlign.center,
        style: TextStyle(color: PrimaryColor),
      ),
    );
  }
}
