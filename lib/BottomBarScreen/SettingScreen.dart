import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/types.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Screens/LoginScreen.dart';
import 'package:jettaexstores/Screens/types.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';
import 'package:http/http.dart' as http;

class SetteingScreen extends StatefulWidget {
  const SetteingScreen({Key key}) : super(key: key);

  @override
  _SetteingScreenState createState() => _SetteingScreenState();
}

class _SetteingScreenState extends State<SetteingScreen> {
  var lang = sharedPreferences.getString("lang");
  List<Types> types;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text(getLang(context, 'SettingsNav'),
            style: TextStyle(color: SecondryColor)),
      ),
      backgroundColor: PrimaryColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 8,
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              color: PrimaryColor,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        print(lang);
                        lang == "en"
                            ? MyApp.setLocale(context, Locale("ar", ""))
                            : MyApp.setLocale(context, Locale("en", ""));
                        setState(() {
                          lang == "en" ? lang = "ar" : lang = "en";
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: SecondryColor,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Center(
                            child: lang == "en"
                                ? Text(
                                    'العربية',
                                    style: TextStyle(
                                        color: PrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )
                                : Text(
                                    'English',
                                    style: TextStyle(
                                        color: PrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  )),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: SecondryColor,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Center(
                            child: Text(
                          getLang(context, "AppDevlopment"),
                          style: TextStyle(
                              color: PrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: SecondryColor,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Center(
                            child: Text(
                          getLang(context, "settingcontactbun"),
                          style: TextStyle(
                              color: PrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TypesScreen()),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: SecondryColor,
                            borderRadius: BorderRadius.all(Radius.circular(0))),
                        child: Center(
                            child: Text(
                          getLang(context, "Terms&Conditions"),
                          style: TextStyle(
                              color: PrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        )),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                      decoration: BoxDecoration(
                          color: SecondryColor,
                          borderRadius: BorderRadius.circular(0)),
                      child: ListTile(
                        title: Text(
                          getLang(context, "Logout"),
                          style: TextStyle(
                            fontSize: 20,
                            color: PrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          sharedPreferences.clear();
                          sharedPreferences.setBool("Remember", false);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

Widget SettingCard(
  String productitle,
  BuildContext context,
  String prodcutcategory,
) {
  return Column(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50),
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            color: SecondryColor,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Column(
                        children: [
                          Text(
                            prodcutcategory,
                            style: TextStyle(
                              fontSize: 18,
                              color: PrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            //textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: MediaQuery.of(context).size.height * .05,
                          width: MediaQuery.of(context).size.width * .4,
                          decoration: BoxDecoration(
                              color: PrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Center(
                              child: Text(
                            'English',
                            style: TextStyle(
                                color: SecondryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: MediaQuery.of(context).size.height * .05,
                          width: MediaQuery.of(context).size.width * .4,
                          decoration: BoxDecoration(
                              color: PrimaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Center(
                              child: Text(
                            'العربية',
                            style: TextStyle(
                                color: SecondryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
