import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/Colors.dart';
import 'package:jettaexstores/Module/statusshippied.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Widget/NavBar.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:jettaexstores/homepage.dart';
import 'package:jettaexstores/orderApi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int pending = 1;
  int accepted = 2;
  int statusReady = 3;
  int statusShipping = 4;
  int rejected = 13;
  dynamic storeData;
  var lang = sharedPreferences.getString("lang");
  bool out = false;

  List<OrderItem> infos = [];
  List<ProductColors> colors = [];
  List<StatuShipped> shippied = [];

  Future<List<OrderItem>> _getData(int status) async {
    //int status;
    var getStoreID = {"storeID": sharedPreferences.getString("storeID")};
    String url = Api.getOrders +
        getStoreID['storeID'].toString() +
        '&status=' +
        status.toString();

    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final List<OrderItem> orderList = orderItemFromJson(response.body);

      return orderList;
    } else {
      // ignore: deprecated_member_use
      return List<OrderItem>();
    }
  }

  Future<List<StatuShipped>> _getShipped() async {
    //int status;
    var getStoreID = {"storeID": sharedPreferences.getString("storeID")};
    String url = Api.getShipped + getStoreID['storeID'].toString();

    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final List<StatuShipped> shippedList =
          statusShippedFromJson(response.body);

      return shippedList;
    } else {
      // ignore: deprecated_member_use
      return List<StatuShipped>();
    }
  }

  Future<List<ProductColors>> _getColors(int status) async {
    //int status;
    var getStoreID = {"storeID": sharedPreferences.getString("storeID")};
    String url = Api.getColors +
        getStoreID['storeID'].toString() +
        '&status=' +
        status.toString();

    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final List<ProductColors> colorList =
          productColorsFromJson(response.body);

      return colorList;
    } else {
      // ignore: deprecated_member_use
      return List<ProductColors>();
    }
  }

  @override
  void initState() {
    super.initState();

    _getData(pending).then((orderList) {
      setState(() {
        infos = orderList;
      });
    });

    _getColors(pending).then((colorList) {
      setState(() {
        colors = colorList;
      });
    });

    // _getShipped().then((shippedList) {
    //   setState(() {
    //     shippied = shippedList;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondryColor,
      appBar: AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text(getLang(context, 'Orderbar'),
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  color: PrimaryColor, borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.height * 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  statuemethod(pending, getLang(context, 'pending')),
                  SizedBox(
                    width: 10,
                  ),
                  statuemethod(accepted, getLang(context, 'accept')),
                  SizedBox(
                    width: 10,
                  ),
                  statuemethod(statusReady, getLang(context, 'Ready')),
                  SizedBox(
                    width: 10,
                  ),
                  statueShipped(getLang(context, 'ShippedOut')),
                ],
              )),
          out == false
              ? Container(
                  height: MediaQuery.of(context).size.height * .68,
                  width: MediaQuery.of(context).size.height * .9,
                  child: ListView.builder(
                    itemBuilder: (context, int index) {
                      OrderItem order = infos[index];
                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                    decoration: BoxDecoration(
                                        color: SecondryColor,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20))),
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 9,
                                          ),
                                          Divider(
                                            thickness: 4,
                                            color: PrimaryColor,
                                            height: 8,
                                            endIndent: 110,
                                            indent: 110,
                                          ),
                                          ListTile(
                                            title: Text(
                                                getLang(context, 'Productname'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: PrimaryColor)),
                                            trailing: lang == 'ar'
                                                ? Text(order.nameAr,
                                                    style: TextStyle(
                                                      color: PrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))
                                                : Text(order.nameEn,
                                                    style: TextStyle(
                                                      color: PrimaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                          ),
                                          ListTile(
                                            title: Text(
                                                getLang(context, 'Price'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: PrimaryColor)),
                                            trailing: Text(
                                                order.price.toString() + ' JOD',
                                                style: TextStyle(
                                                  color: PrimaryColor,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                          ListTile(
                                            title: Text(
                                                getLang(context, 'Quantity'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: PrimaryColor)),
                                            trailing: Text(
                                                order.quantity.toString(),
                                                style: TextStyle(
                                                  color: PrimaryColor,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                          ListTile(
                                            title: Text(
                                                getLang(context, 'Totalprice'),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: PrimaryColor)),
                                            trailing: Text(
                                                order.totalPrice.toString() +
                                                    ' JOD',
                                                style: TextStyle(
                                                  color: PrimaryColor,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                          orderListTile(order),
                                        ],
                                      ),
                                    ));
                              });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                              color: PrimaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            leading: Image(
                                image: NetworkImage(Api.img + order.image)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check),
                                  color: SecondryColor,
                                  onPressed: () async {
                                    var id = order.itemsId.toString();
                                    if (order.status == 1) {
                                      await updateStatus(id, accepted);

                                      await _getData(pending).then((orderList) {
                                        return infos = orderList;
                                      });
                                      setState(() {});
                                    } else if (order.status == 2) {
                                      await updateStatus(id, statusReady);

                                      await _getData(accepted)
                                          .then((orderList) {
                                        return infos = orderList;
                                      });
                                      setState(() {});
                                    } else if (order.status == 3) {
                                      await updateStatus(id, statusShipping);

                                      await _getData(statusReady)
                                          .then((orderList) {
                                        return infos = orderList;
                                      });
                                      setState(() {});
                                    }
                                  },
                                ),
                                IconButton(
                                    onPressed: () async {
                                      var id = order.itemsId.toString();
                                      await updateStatus(id, rejected);
                                      await _getData(pending).then((orderList) {
                                        return infos = orderList;
                                      });
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: SecondryColor,
                                    ))
                              ],
                            ),
                            title: lang == 'ar'
                                ? Text(
                                    order.nameAr.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: SecondryColor),
                                  )
                                : Text(
                                    order.nameEn.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: SecondryColor),
                                  ),
                          ),
                        ),
                      );
                    },
                    itemCount: null == infos ? 0 : infos.length,
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * .68,
                  width: MediaQuery.of(context).size.height * .9,
                  child: ListView.builder(
                    itemBuilder: (context, int index) {
                      StatuShipped statuShipped = shippied[index];
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                          decoration: BoxDecoration(
                              color: PrimaryColor,
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            leading: Image(
                                image:
                                    NetworkImage(Api.img + statuShipped.image)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                lang == 'ar'
                                    ? Text(statuShipped.statusAr)
                                    : Text(statuShipped.statusEn)
                              ],
                            ),
                            title: lang == 'ar'
                                ? Text(
                                    statuShipped.nameAr.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: SecondryColor),
                                  )
                                : Text(
                                    statuShipped.nameEn.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: SecondryColor),
                                  ),
                          ),
                        ),
                      );
                    },
                    itemCount: null == shippied ? 0 : shippied.length,
                  ),
                )
        ],
      ),
    );
  }

  InkWell statuemethod(int st, String title) {
    return InkWell(
        onTap: () {
          out = false;
          setState(() {
            _getData(st).then((orderList) {
              setState(() {
                infos = orderList;
              });
            });
          });
        },
        child: buildContainer(title, PrimaryColor));
  }

  InkWell statueShipped(String title) {
    return InkWell(
        onTap: () {
          setState(() {
            out = true;
            _getShipped().then((shippedList) {
              setState(() {
                shippied = shippedList;
              });
            });
          });
        },
        child: buildContainer(title, PrimaryColor));
  }

  Widget buildContainer(String st, Color co) {
    return Center(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: co, borderRadius: BorderRadiusDirectional.circular(5)),
          height: 50,
          width: 65,
          child: Text(
            st,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: SecondryColor),
          )),
    );
  }

  Widget orderListTile(OrderItem order) {
    if (order.productPaidFeatureLabel == null &&
        order.productPaidFeatureWeight == null &&
        (order.colorId == 0 || order.colorId == null)) {
      return ListTile();
    } else if (order.productPaidFeatureLabel == null &&
        order.productPaidFeatureWeight == null) {
      return ListTile(
        title: Text("Color",
            style: TextStyle(fontWeight: FontWeight.bold, color: PrimaryColor)),
        trailing: Text(colors[0].colorCode,
            style: TextStyle(
              color: PrimaryColor,
              fontWeight: FontWeight.bold,
            )),
      );
    } else if (order.colorId == 0 || order.colorId == null) {
      return Column(
        children: [
          ListTile(
            title: Text("Feature Label",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: PrimaryColor)),
            trailing: Text(order.productPaidFeatureLabel,
                style: TextStyle(
                  color: PrimaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
          ListTile(
            title: Text("Feature weight",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: PrimaryColor)),
            trailing: Text(order.productPaidFeatureLabel,
                style: TextStyle(
                  color: PrimaryColor,
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      );
    } else if (order.productPaidFeatureLabel != null &&
        order.productPaidFeatureWeight != null &&
        (order.colorId != 0 || order.colorId != null)) {
      return Column(
        children: [
          ListTile(
            title: Text("Color",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: PrimaryColor)),
            trailing: Text(colors[0].colorCode,
                style: TextStyle(
                  color: PrimaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
          ListTile(
            title: Text("Feature Label",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: PrimaryColor)),
            trailing: Text(order.productPaidFeatureLabel,
                style: TextStyle(
                  color: PrimaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
          ListTile(
            title: Text("Feature weight",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: PrimaryColor)),
            trailing: Text(order.productPaidFeatureWeight,
                style: TextStyle(
                  color: PrimaryColor,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      );
    }
  }
}

Future<bool> updateStatus(var id, int status) async {
  print(status.toString());

  final response = await http.post(Uri.parse(Api.updateStatus),
      body: {"id": id.toString(), "status": status.toString()});

  return true;
}
