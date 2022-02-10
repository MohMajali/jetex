import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:jettaexstores/Widget/NavBar.dart';

import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class loginp {
  final String password;
  final String email;

  loginp({
    @required this.email,
    @required this.password,
  });

  Future<String> login(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                backgroundColor: SecondryColor,
                valueColor: AlwaysStoppedAnimation<Color>(PrimaryColor),
                strokeWidth: 5,
              ),
            ),
          );
        });

    try {
      print(email + password);
      Map data = {"Email": email, "Password": password};
      var url = Uri.parse(Api.login_api);

      var response = await http.post(url, body: data);

      final result = jsonDecode(response.body);

      String situation = result['result'];
      String storeID = result['Store']['id'];
      String storeLogo = result['Store']['store_logo'];
      String storeNameEn = result['Store']['name_en'];
      String storeNameAr = result['Store']['name_ar'];
      String rate = result['Store']['rate'];
      String storeType = result['Store']['store_type'];
      String storeEmail = result['Store']['store_email'];
      String userId = result['Store']['user_id'];
      String phoneNumber = result['Store']['phone_number'];
      String active = result['Store']['active'];

      Navigator.pop(context);
      if (situation == "1") {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString("storeID", storeID);
        sharedPreferences.setString("storeLogo", storeLogo);
        sharedPreferences.setString("storeNameEn", storeNameEn);
        sharedPreferences.setString("storeNameAr", storeNameAr);
        sharedPreferences.setDouble("storeRate", double.parse(rate));
        sharedPreferences.setString("storeType", storeType);
        // sharedPreferences.setString("storeEmail", storeEmail);
        sharedPreferences.setString("userId", userId);
        sharedPreferences.setString("phoneNumber", phoneNumber);
        sharedPreferences.setString("Password", password);
        sharedPreferences.setString("active", active);
        sharedPreferences.setBool("Remember", true);
        sharedPreferences.commit();

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => Home()),
            (Route<dynamic> route) => false);
      } else {
        AwesomeDialog(
          dialogBackgroundColor: SecondryColor,
          context: context,
          headerAnimationLoop: true,
          dialogType: DialogType.ERROR,
          body: Text(
            "Store Not Found !!",
            style: TextStyle(
                color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 30),
          ),
          autoHide: Duration(seconds: 7),
        )..show();
      }
    } catch (e) {
      Navigator.pop(context);
      AwesomeDialog(
        dialogBackgroundColor: SecondryColor,
        context: context,
        headerAnimationLoop: true,
        dialogType: DialogType.ERROR,
        body: Text(
          'Connection Error ' + e.toString(),
          style: TextStyle(
              color: PrimaryColor, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        autoHide: Duration(seconds: 7),
      )..show();
    }
  }
}
