import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  int statusReady = 4;
  int statusShipping = 5;
  dynamic storeData;

  List<OrderItem> infos = [];

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

  @override
  void initState() {
    super.initState();

    _getData(pending).then((orderList) {
      setState(() {
        infos = orderList;
      });
    });
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
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        statuemethod(pending, getLang(context, 'pending')),

                        statuemethod(statusReady, getLang(context, 'Ready')),
                        statuemethod(
                            statusShipping, getLang(context, 'ShippedOut')),

                        // statuemethod(
                        //     statusRejected, getLang(context, 'Rejected')),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
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
                            color: Colors.black54,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: SecondryColor,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20))),
                              height: MediaQuery.of(context).size.height * .5,
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
                                    title: Text('Product name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor)),
                                    trailing: Text(order.nameEn,
                                        style: TextStyle(
                                          color: PrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  ListTile(
                                    title: Text('Price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor)),
                                    trailing:
                                        Text(order.price.toString() + ' JOD',
                                            style: TextStyle(
                                              color: PrimaryColor,
                                              fontWeight: FontWeight.bold,
                                            )),
                                  ),
                                  ListTile(
                                    title: Text('Quantity',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor)),
                                    trailing: Text(order.quantity.toString(),
                                        style: TextStyle(
                                          color: PrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                  ListTile(
                                    title: Text('Total price',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: PrimaryColor)),
                                    trailing: Text(
                                        order.totalPrice.toString() + ' JOD',
                                        style: TextStyle(
                                          color: PrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    decoration: BoxDecoration(
                        color: PrimaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: order.status == 5
                        ? ListTile(
                            leading: Image(
                                image: NetworkImage(Api.img + order.image)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 0),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(order.status.toString()),
                                // IconButton(
                                //   icon: const Icon(Icons.check),
                                //   color: SecondryColor,
                                //   onPressed: () async {
                                //     var id = order.itemsId.toString();
                                //     if (order.status == 1) {
                                //       await updateStatus(id, statusReady);

                                //       await _getData(pending).then((orderList) {
                                //         return infos = orderList;
                                //       });
                                //       setState(() {});
                                //     } else if (order.status == 4) {
                                //       await updateStatus(id, statusShipping);

                                //       await _getData(statusReady).then((orderList) {
                                //         return infos = orderList;
                                //       });
                                //       setState(() {});
                                //     }
                                //   },
                                // ),
                                // IconButton(
                                //     onPressed: () async {
                                //       // var id = order.itemsId.toString();
                                //       // if (order.status == 0) {
                                //       //   await updateStatus(id, statusRejected);
                                //       //   await _getData(pending).then((orderList) {
                                //       //     return infos = orderList;
                                //       //   });
                                //       //   setState(() {});
                                //       // } else if (order.status == 3) {
                                //       //   await updateStatus(id, statusCanceled);
                                //       //   await _getData(pending).then((orderList) {
                                //       //     return infos = orderList;
                                //       //   });
                                //       //   setState(() {});
                                //       // }
                                //     },
                                //     icon: const Icon(
                                //       Icons.cancel,
                                //       color: SecondryColor,
                                //     ))
                              ],
                            ),
                            title: Text(
                              order.nameEn.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: SecondryColor),
                            ),
                          )
                        : ListTile(
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
                                      await updateStatus(id, statusReady);

                                      await _getData(pending).then((orderList) {
                                        return infos = orderList;
                                      });
                                      setState(() {});
                                    } else if (order.status == 4) {
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
                                      // var id = order.itemsId.toString();
                                      // if (order.status == 0) {
                                      //   await updateStatus(id, statusRejected);
                                      //   await _getData(pending).then((orderList) {
                                      //     return infos = orderList;
                                      //   });
                                      //   setState(() {});
                                      // } else if (order.status == 3) {
                                      //   await updateStatus(id, statusCanceled);
                                      //   await _getData(pending).then((orderList) {
                                      //     return infos = orderList;
                                      //   });
                                      //   setState(() {});
                                      // }
                                    },
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: SecondryColor,
                                    ))
                              ],
                            ),
                            title: Text(
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
        ],
      ),
    );
  }

  InkWell statuemethod(int st, String title) {
    return InkWell(
        onTap: () {
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
}

Future<bool> updateStatus(var id, int status) async {
  print(status.toString());

  final response = await http.post(Uri.parse(Api.updateStatus),
      body: {"id": id.toString(), "status": status.toString()});

  return true;
}
