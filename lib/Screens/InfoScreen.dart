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
                            padding: const EdgeInsets.all(5),
                            child: ListTile(
                              onTap: () async {
                                enlgihDialog();
                              },
                              title: RichText(
                                text: TextSpan(
                                  text: maininfo.nameEn,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
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
                            padding: const EdgeInsets.all(5),
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
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
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
                            padding: const EdgeInsets.all(5),
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
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
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
                            padding: const EdgeInsets.all(5),
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
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
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
          contentPadding: EdgeInsets.all(2),
          backgroundColor: SecondryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                width: 50,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('+962',
                            style:
                                TextStyle(color: PrimaryColor, fontSize: 15)),
                        Container(
                          width: 190,
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(),
                          child: TextFormField(
                            style: TextStyle(color: Colors.amber, fontSize: 15),
                            cursorColor: PrimaryColor,
                            maxLength: 9,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: getLang(context, "InfoPhoneEdit"),
                              labelStyle: TextStyle(color: PrimaryColor),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                borderSide: BorderSide(
                                  color: PrimaryColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(1.0),
                                borderSide: BorderSide(
                                  color: PrimaryColor,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            controller: pn,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                            onSaved: (newvalue) {
                              // signUPUserEmail = newvalue!;
                            },
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        if (pn.text == '') {
                          final snackBar = SnackBar(
                            content: const Text(
                              "Phone should not be empty",
                              style: TextStyle(color: PrimaryColor),
                            ),
                            action: SnackBarAction(label: '', onPressed: () {}),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (pn.text[0] == '0') {
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
                            sharedPreferences.remove("phoneNumber");
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
                        width: MediaQuery.of(context).size.width * .8,
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
          contentPadding: EdgeInsets.all(2),
          backgroundColor: SecondryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                width: 50,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(),
                        child: TextFormField(
                          style: TextStyle(color: Colors.amber, fontSize: 15),
                          cursorColor: PrimaryColor,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: getLang(context, "InfoEmailEdit"),
                            labelStyle: TextStyle(color: PrimaryColor),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: PrimaryColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          controller: em,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          onSaved: (newvalue) {
                            // signUPUserEmail = newvalue!;
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        if (em.text == '') {
                          final snackBar = SnackBar(
                            content: const Text(
                              "Field must not be empty",
                              style: TextStyle(color: PrimaryColor),
                            ),
                            action: SnackBarAction(label: '', onPressed: () {}),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (!em.text.contains('@')) {
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
                            sharedPreferences.remove("storeEmail");
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
                        width: MediaQuery.of(context).size.width * .8,
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
          contentPadding: EdgeInsets.all(2),
          backgroundColor: SecondryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                width: 50,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(),
                        child: TextFormField(
                          style: TextStyle(color: Colors.amber, fontSize: 15),
                          cursorColor: PrimaryColor,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: getLang(context, "InfoStorename"),
                            labelStyle: TextStyle(color: PrimaryColor),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: PrimaryColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          controller: en,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          onSaved: (newvalue) {
                            // signUPUserEmail = newvalue!;
                          },
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
                        width: MediaQuery.of(context).size.width * .8,
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
          contentPadding: EdgeInsets.all(2),
          backgroundColor: SecondryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          content: SingleChildScrollView(
            child: Form(
              child: Container(
                width: 50,
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: SecondryColor,
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Container(
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(),
                        child: TextFormField(
                          style: TextStyle(color: Colors.amber, fontSize: 15),
                          cursorColor: PrimaryColor,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: getLang(context, "InfoarStorename"),
                            labelStyle: TextStyle(color: PrimaryColor),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: PrimaryColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(1.0),
                              borderSide: BorderSide(
                                color: PrimaryColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          controller: ar,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "";
                            }
                            return null;
                          },
                          onSaved: (newvalue) {
                            // signUPUserEmail = newvalue!;
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await updateArabic(getStore, ar.text);
                        setState(() {
                          sharedPreferences.remove("storeNameAr");
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
                        width: MediaQuery.of(context).size.width * .8,
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
