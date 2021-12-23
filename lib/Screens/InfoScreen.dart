import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/mainscreeninfo.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Widget/NavBar.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';

class InfoScreen extends StatefulWidget {
  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  List<Maininfo> products = [];
  var getStore = sharedPreferences.getString('storeID');

  Future<List<Maininfo>> _getData() async {
    String url = Api.getStoreInfo + getStore;

    var response = await http.post(
      Uri.parse(url),
      body: getStore,
    );

    if (response.statusCode == 200) {
      final List<Maininfo> productsList = maininfoFromJson(response.body);
      return productsList;
    } else {
      // ignore: deprecated_member_use
      return List<Maininfo>();
    }
  }

  @override
  void initState() {
    _getData().then((productsList) {
      setState(() {
        products = productsList;
      });
    });
    super.initState();
    setdata();
  }

  void setdata() async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      //location = sharedPreferences.getString('key');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text(getLang(context, "Infobar"),
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
      body: ListView.builder(
        itemBuilder: (context, int index) {
          Maininfo maininfo = products[index];
          if (products.isEmpty) {
            return Center(
                child: Container(
              child: Text('Loading...'),
            ));
          } else {
            return Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      children: [
                        Card(
                          color: SecondryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: ListTile(
                              onTap: () async {
                                enlgihDialog();
                              },
                              title: RichText(
                                text: TextSpan(
                                  text: maininfo.nameEn,
                                  style: TextStyle(
                                      fontFamily: 'Simpletax',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w200,
                                      color: PrimaryColor),
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: PrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: SecondryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  arabicDialog();
                                });
                              },
                              title: RichText(
                                text: TextSpan(
                                  text: maininfo.nameAr,
                                  style: TextStyle(
                                      fontFamily: 'Simpletax',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w200,
                                      color: PrimaryColor),
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_outlined,
                                  color: PrimaryColor),
                            ),
                          ),
                        ),
                        Card(
                          color: SecondryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  phonealertDialog();
                                });
                              },
                              title: RichText(
                                text: TextSpan(
                                  text: maininfo.phoneNumber.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Simpletax',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w200,
                                      color: PrimaryColor),
                                ),
                              ),
                              trailing: Icon(Icons.arrow_forward_ios_outlined,
                                  color: PrimaryColor),
                            ),
                          ),
                        ),
                        Card(
                          color: SecondryColor,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  emailalertDialog();
                                });
                              },
                              title: RichText(
                                text: TextSpan(
                                  text: maininfo.storeEmail,
                                  style: TextStyle(
                                      fontFamily: 'Simpletax',
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.w200,
                                      color: PrimaryColor),
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: PrimaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            );
          }
        },
        itemCount: null == products ? 0 : products.length,
      ),
    );
  }

  Container infobox(BuildContext context, String title, IconData icon) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xffedb54f), borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        title: Text(
          title,
          style: CategoryTextStyle,
          textAlign: TextAlign.center,
        ),
        leading: Icon(
          icon,
          color: SecondryColor,
        ),
        trailing: Icon(
          Icons.arrow_right,
          color: SecondryColor,
        ),
      ),
    );
  }

  Container buildContainer(String st, IconData icon) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color(0xffedb54f), borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        title: Text(
          st,
          style: CategoryTextStyle,
          textAlign: TextAlign.center,
        ),
        leading: Icon(
          icon,
          color: SecondryColor,
        ),
      ),
    );
  }

  Future updatePhone(var id, String phone) async {
    final response = await http.post(Uri.parse(Api.updatePhone),
        body: {"id": id.toString(), "phone_number": phone});
  }

  Future<bool> phonealertDialog() {
    TextEditingController pn = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: SecondryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .7,
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      leading: Text(
                        '+962',
                        style: TextStyle(color: PrimaryColor, fontSize: 15),
                      ),
                      title: TextFormField(
                        controller: pn,
                        maxLength: 9,
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          // icon: IconButton(
                          //   icon: const Icon(Icons.edit),
                          //   color: PrimaryColor,
                          //   onPressed: () {
                          //     setState(() {});
                          //   },
                          // ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          hintText: getLang(context, "InfoPhoneEdit"),
                          hintStyle: TextStyle(
                              color: PrimaryColor,
                              letterSpacing: 0,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (pn.text[0] == '0') {
                          final snackBar = SnackBar(
                            content: const Text(
                              "Phone should not have 0",
                              style: TextStyle(color: PrimaryColor),
                            ),
                            action: SnackBarAction(label: '', onPressed: () {}),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          await updatePhone(getStore, pn.text);
                          setState(() {
                            sharedPreferences.setString("phoneNumber", pn.text);

                            Navigator.of(context).pop();

                            _getData().then((productsList) {
                              setState(() {
                                products = productsList;
                              });
                            });
                          });
                        }
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

  Future updateMail(var id, String mail) async {
    final response = await http.post(Uri.parse(Api.updateMail),
        body: {"id": id.toString(), "store_email": mail});
  }

  Future<bool> emailalertDialog() {
    TextEditingController em = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: SecondryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      title: TextFormField(
                        controller: em,
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          icon: IconButton(
                            icon: const Icon(Icons.edit),
                            color: PrimaryColor,
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          hintText: getLang(context, "InfoEmailEdit"),
                          hintStyle: TextStyle(
                              color: PrimaryColor,
                              letterSpacing: 0,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (!em.text.contains('@')) {
                          final snackBar = SnackBar(
                            content: const Text(
                              "Email Should Have @",
                              style: TextStyle(color: PrimaryColor),
                            ),
                            action: SnackBarAction(label: '', onPressed: () {}),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          await updateMail(getStore, em.text);
                          setState(() {
                            sharedPreferences.setString("storeEmail", em.text);

                            Navigator.of(context).pop();

                            _getData().then((productsList) {
                              setState(() {
                                products = productsList;
                              });
                            });
                          });
                        }
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

  Future update(var id, String nameEnglish) async {
    final response = await http.post(Uri.parse(Api.updateNameEnglish),
        body: {"id": id.toString(), "name_en": nameEnglish});
  }

  Future<bool> enlgihDialog() {
    TextEditingController en = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: SecondryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      title: TextFormField(
                        controller: en,
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          icon: IconButton(
                            icon: const Icon(Icons.edit),
                            color: PrimaryColor,
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          hintText: getLang(context, "InfoStorename"),
                          hintStyle: TextStyle(
                              color: PrimaryColor,
                              letterSpacing: 0,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await update(getStore, en.text);
                        setState(() {
                          sharedPreferences.remove("storeNameEn");
                          sharedPreferences.setString('storeNameEn', en.text);

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

  Future updateArabic(var id, String nameArabic) async {
    final response = await http.post(Uri.parse(Api.updateNameArabic),
        body: {"id": id.toString(), "name_ar": nameArabic});
  }

  Future<bool> arabicDialog() {
    TextEditingController ar = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: SecondryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                height: MediaQuery.of(context).size.height * .25,
                width: MediaQuery.of(context).size.width * .7,
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      title: TextFormField(
                        controller: ar,
                        style: TextStyle(color: PrimaryColor),
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          icon: IconButton(
                            icon: const Icon(Icons.edit),
                            color: PrimaryColor,
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          hintText: getLang(context, "InfoarStorename"),
                          hintStyle: TextStyle(
                              color: PrimaryColor,
                              letterSpacing: 0,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await updateArabic(getStore, ar.text);
                        setState(() {
                          sharedPreferences.setString('storeNameAr', ar.text);

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

  // Future<bool> locationalertDialog() {
  //   TextEditingController lo = TextEditingController();
  //   return showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //         backgroundColor: SecondryColor,
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //         content: SingleChildScrollView(
  //           child: Form(
  //             child: Container(
  //               height: MediaQuery.of(context).size.height * .4,
  //               width: MediaQuery.of(context).size.width * .7,
  //               decoration: BoxDecoration(
  //                 color: SecondryColor,
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                 children: [
  //                   ListTile(
  //                     leading: Icon(
  //                       Icons.location_on,
  //                       color: PrimaryColor,
  //                     ),
  //                     title: TextFormField(
  //                       controller: lo,
  //                       style: TextStyle(color: PrimaryColor),
  //                       keyboardType: TextInputType.text,
  //                       decoration: InputDecoration(
  //                         labelText: getLang(context, "InfoStoreLocation"),
  //                         labelStyle: TextStyle(color: PrimaryColor),
  //                       ),
  //                     ),
  //                   ),
  //                   InkWell(
  //                     onTap: () {
  //                       setState(() {
  //                         // Infoapi inf = Infoapi(storeLocation: lo.text);
  //                         // Insert(inf);
  //                         Navigator.of(context).pop();
  //                       });
  //                     },
  //                     child: Container(
  //                       height: MediaQuery.of(context).size.height * .05,
  //                       width: MediaQuery.of(context).size.width * .4,
  //                       decoration: BoxDecoration(
  //                           color: PrimaryColor,
  //                           borderRadius:
  //                               BorderRadius.all(Radius.circular(15))),
  //                       child: Center(
  //                           child: Text(
  //                         getLang(context, "InfoSaveBottn"),
  //                         style: TextStyle(
  //                             color: SecondryColor,
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 15),
  //                       )),
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         )),
  //   );
  // }
}
