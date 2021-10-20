import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/productlastapi.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/alertdilog.dart';
import 'package:jettaexstores/config/Constant.dart';
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
  String imageUrl = 'http://45.76.132.167/productImages/';
  Future<List<ProductsApi>> _getData() async {
    var getStoreID = {"storeID": sharedPreferences.getString("storeID")};

    String url =
        'http://45.76.132.167/api/authentication/productview.php?store_id=' +
            getStoreID['storeID'].toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<ProductsApi> productsList = productsApiFromJson(response.body);
      return productsList;
    } else {
      // ignore: deprecated_member_use
      return List<ProductsApi>();
    }
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
                  Navigator.pushNamed(context, 'AddProdcut');
                },
                icon: Icon(Icons.add))
          ],
          foregroundColor: SecondryColor,
          backgroundColor: PrimaryColor,
          title: Text('Products', style: TextStyle(color: SecondryColor)),
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
                actions: <Widget>[
                  SlideContiner(Icons.share, Colors.indigo, 'Share'),
                ],
                secondaryActions: <Widget>[
                  InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, 'EditProduct', arguments: {
                          "id": productsApi.id,
                          "namear": productsApi.nameAr,
                          "nameen": productsApi.nameEn,
                          "image": productsApi.image,
                          "desar": productsApi.descriptionAr,
                          "desen": productsApi.descriptionEn,
                          "price": productsApi.price,
                          "discount": productsApi.discount
                        });
                      },
                      child: SlideContiner(Icons.edit, Colors.black54, 'Edit')),
                  SlideContiner(Icons.delete, Colors.red, 'Delete')
                ],
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                    decoration: BoxDecoration(
                        color: Color(0xffedb54f),
                        borderRadius: BorderRadiusDirectional.circular(8)),
                    child: null == productsApi.image
                        ? ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            leading: Container(
                              height: MediaQuery.of(context).size.height * 2,
                              width: MediaQuery.of(context).size.width * .21,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          'https://images-na.ssl-images-amazon.com/images/I/513CiKyzUWL.jpg'),
                                      fit: BoxFit.fill)),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  productsApi.nameEn,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: SecondryColor),
                                ),
                                const SizedBox(height: 4),
                                // Text(
                                //   snapshot.data[index].descriptionEn,
                                //   style: TextStyle(color: Colors.black54),
                                // )
                              ],
                            ),
                            onTap: () {
                              showAlertDialog(
                                context,
                                productsApi.nameAr,
                                productsApi.descriptionEn,
                                productsApi.descriptionAr,
                                productsApi.price.toString(),
                                productsApi.nameEn,
                                productsApi.image,
                              );
                            },
                          )
                        : ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 8,
                            ),
                            leading: Container(
                              height: MediaQuery.of(context).size.height * 2,
                              width: MediaQuery.of(context).size.width * .21,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(productsApi.image),
                                      fit: BoxFit.fill)),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  productsApi.nameEn,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: SecondryColor),
                                ),
                                const SizedBox(height: 4),
                                // Text(
                                //   snapshot.data[index].descriptionEn,
                                //   style: TextStyle(color: Colors.black54),
                                // )
                              ],
                            ),
                            onTap: () {
                              // print(snapshot.data[index].id);
                              // print(snapshot.data[index].nameEn);
                              showAlertDialog(
                                context,
                                productsApi.nameAr,
                                productsApi.descriptionEn,
                                productsApi.descriptionAr,
                                productsApi.price.toString(),
                                productsApi.nameEn,
                                productsApi.image,
                              );
                            },
                          )),
              );
            }
          },
          itemCount: null == products ? 0 : products.length,
        ));
  }
}

Container SlideContiner(IconData icon, Color color, String txt) {
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
