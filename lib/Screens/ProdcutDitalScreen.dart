import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/productlastapi.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Widget/NavBar.dart';
import 'package:jettaexstores/alertdilog.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/homepage.dart';
import 'package:jettaexstores/main.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_slidable/flutter_slidable.dart';

class ProscutDitalScreen extends StatefulWidget {
  @override
  _ProscutDitalScreenState createState() => _ProscutDitalScreenState();
}

class _ProscutDitalScreenState extends State<ProscutDitalScreen> {
  List<ProductsApi> products = [];
  dynamic storeData;
  var getStoreID = {"storeID": sharedPreferences.getString("storeID")};
  var lang = sharedPreferences.getString("lang");
  Future<List<ProductsApi>> _getData() async {
    String url = Api.getProdcts + getStoreID['storeID'].toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<ProductsApi> productsList = productsApiFromJson(response.body);
      return productsList;
    } else {
      // ignore: deprecated_member_use
      return List<ProductsApi>();
    }
  }

  Future deleteProduct(var id) async {
    String url = Api.deleteProduct + id.toString();
    try {
      final response =
          await http.post(Uri.parse(url), body: {"id": id.toString()});
      setState(() {});
    } catch (e) {}
  }

  Future addProduct(
      var storeID, String nameEnglish, String nameArabic, var price) async {
    var url = Api.addProduct;
    final response = await http.post(Uri.parse(url), body: {
      "name_en": nameEnglish,
      "name_ar": nameArabic,
      "store_id": storeID,
      "price": price
    });
  }

  void showAlertDialog(BuildContext context, String nameen, String namear,
      String desen, String desar, String imag, String price) {
    final AlertDialog alert = AlertDialog(
      backgroundColor: SecondryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: cad(nameen, namear, desen, desar, imag, price),
    );
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return alert;
        });
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
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  addProductDialog();
                },
                icon: Icon(Icons.add))
          ],
          foregroundColor: SecondryColor,
          backgroundColor: PrimaryColor,
          title: Text(getLang(context, "ProductButton"),
              style: TextStyle(color: SecondryColor)),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              icon: Icon(Icons.arrow_back)),
        ),
        backgroundColor: SecondryColor,
        body: ListView.builder(
          itemBuilder: (context, int index) {
            ProductsApi productsApi = products[index];
            if (products.isEmpty) {
              return Center(
                  child: Container(
                child: Text('Loading...'),
              ));
            } else {
              return Slidable(
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  InkWell(
                      onTap: () {
                        sharedPreferences.setInt(
                            'selectedProductID', productsApi.id);
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, 'EditProduct', arguments: {
                          "id": productsApi.id,
                          "namear": productsApi.nameAr,
                          "nameen": productsApi.nameEn,
                          "image": productsApi.image,
                          "desar": productsApi.descriptionAr,
                          "desen": productsApi.descriptionEn,
                          "price": productsApi.price,
                          "discount": productsApi.discount,
                          "warranty": productsApi.warranty,
                          "modelNumber": productsApi.modelNumber
                        });
                      },
                      child: slideContiner(Icons.edit, Colors.black54,
                          getLang(context, "Edit"))),
                  InkWell(
                    onTap: () async {
                      var id = productsApi.id;

                      await deleteProduct(id);
                      setState(() {
                        _getData().then((productsList) {
                          setState(() {
                            products = productsList;
                          });
                        });
                      });
                    },
                    child: slideContiner(
                        Icons.delete, Colors.red, getLang(context, "delete")),
                  )
                ],
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        color: PrimaryColor,
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      leading: Container(
                        height: MediaQuery.of(context).size.height * 2,
                        width: MediaQuery.of(context).size.width * .21,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(8),
                            image: DecorationImage(
                                image:
                                    NetworkImage(Api.img + productsApi.image),
                                fit: BoxFit.fill)),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          lang == 'ar'
                              ? Text(
                                  productsApi.nameAr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: SecondryColor),
                                )
                              : Text(
                                  productsApi.nameEn,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: SecondryColor),
                                ),
                          const SizedBox(height: 4),
                        ],
                      ),
                      onTap: () {},
                    )),
              );
            }
          },
          itemCount: null == products ? 0 : products.length,
        ));
  }

  FloatingActionButton cbuildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Color(0xffedb54f),
      onPressed: null,
      child: Icon(
        Icons.home,
        color: SecondryColor,
      ),
    );
  }

  Future<bool> addProductDialog() {
    TextEditingController englishName = TextEditingController();
    TextEditingController arabicName = TextEditingController();
    TextEditingController price = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: SecondryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                height: MediaQuery.of(context).size.height * .5,
                width: MediaQuery.of(context).size.width * .5,
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      title: TextFormField(
                        controller: englishName,
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          hintText: getLang(context, "ProductinEnglish"),
                          hintStyle: TextStyle(
                              color: PrimaryColor,
                              letterSpacing: 0,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: arabicName,
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          hintText: getLang(context, "ProductinArabic"),
                          hintStyle: TextStyle(
                              color: PrimaryColor,
                              letterSpacing: 0,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        controller: price,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          hintText: getLang(context, "price"),
                          hintStyle: TextStyle(
                              color: PrimaryColor,
                              letterSpacing: 0,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await addProduct(getStoreID['storeID'].toString(),
                            englishName.text, arabicName.text, price.text);
                        setState(() {
                          Navigator.of(context).pop();

                          _getData().then((productsList) {
                            setState(() {
                              products = productsList;
                            });
                          });
                        });
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .05,
                        width: MediaQuery.of(context).size.width * .4,
                        decoration: BoxDecoration(
                            color: PrimaryColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                            child: Text(
                          getLang(context, "InfoSaveBottn"),
                          style: TextStyle(
                              color: SecondryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

Container slideContiner(IconData icon, Color color, String txt) {
  return Container(
    margin: EdgeInsets.only(left: 5, right: 5),
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Text(
          txt,
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}

class Utils {
  static void showSnackBar(BuildContext context, String message) =>
      Scaffold.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(message)),
        );
}
