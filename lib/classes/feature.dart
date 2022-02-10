import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:jettaexstores/Module/feature.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';

class Feature extends StatefulWidget {
  final int id;
  const Feature({Key key, this.id}) : super(key: key);

  @override
  _FeatureState createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  String labelEn, labelAr, descEn, descAr, pricetxt;
  Future featuresAPi(int productId, String labelEn, String labelAr,
      String descEn, String descAr, var price) async {
    try {
      String url = Api.insertFeature;
      final response = await http.post(Uri.parse(url), body: {
        "product_id": productId.toString(),
        "label_en": labelEn,
        "label_ar": labelAr,
        "description_en": descEn,
        "description_ar": descAr,
        "price": price.toString()
      });
      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            json['message'],
            style: TextStyle(color: PrimaryColor),
          ),
          action: SnackBarAction(label: '', onPressed: () {}),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text(
            json['message'],
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

  List<Features> features = [];
  TextEditingController lableen = TextEditingController();
  TextEditingController lablear = TextEditingController();
  TextEditingController descen = TextEditingController();
  TextEditingController descar = TextEditingController();
  TextEditingController price = TextEditingController();

  Future<List<Features>> _getData(int id) async {
    try {
      String url = Api.getFeature + id.toString();
      print(url);

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<Features> list = featuresFromJson(response.body);

        return list;
      } else {
        // ignore: deprecated_member_use
        return List<Features>();
      }
    } catch (x) {
      print(x);
    }
  }

  void check() {
    if (features?.isNotEmpty ?? true) {
      if (features[0].labelEn != null) {
        lableen.text = features[0].labelEn;
        labelEn = lableen.text;
      }
      if (features[0].labelAr != null) {
        lablear.text = features[0].labelAr;
      }

      if (features[0].descriptionEn != null) {
        descen.text = features[0].descriptionEn;
        descEn = descen.text;
      }
      if (features[0].descriptionAr != null) {
        descar.text = features[0].descriptionAr;
        descAr = descar.text;
      }

      if (features[0].price != null) {
        price.text = features[0].price.toString();
        pricetxt = price.text;
      }
    } else {
      // print('object');
    }
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.id).then((list) {
      setState(() {
        features = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    check();
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      getLang(context, "LabelnEnglish"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
          Container(
              height: 60,
              padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * .05,
                  0,
                  MediaQuery.of(context).size.width * .05,
                  0),
              color: SecondryColor,
              child: TextFormField(
                  controller: lableen,
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: features.length == 0
                        ? getLang(context, "labelEm")
                        : features[0].labelEn == null
                            ? getLang(context, "labelEm")
                            : labelEn,
                    hintStyle: TextStyle(color: PrimaryColor),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      getLang(context, "LabelArabic"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
          Container(
              height: 60,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .05,
                right: MediaQuery.of(context).size.width * .05,
                top: MediaQuery.of(context).size.width * .012,
              ),
              color: SecondryColor,
              child: TextFormField(
                  controller: lablear,
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: features.length == 0
                        ? getLang(context, "labelAr")
                        : features[0].labelAr == null
                            ? getLang(context, "labelAr")
                            : labelAr,
                    hintStyle: TextStyle(color: PrimaryColor),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      getLang(context, "descEn"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
          Container(
              height: 60,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .05,
                right: MediaQuery.of(context).size.width * .05,
                top: MediaQuery.of(context).size.width * .012,
              ),
              color: SecondryColor,
              child: TextFormField(
                  controller: descen,
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: features.length == 0
                        ? getLang(context, "descenlgish")
                        : features[0].descriptionEn == null
                            ? getLang(context, "descenlgish")
                            : descEn,
                    hintStyle: TextStyle(color: PrimaryColor),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      getLang(context, "descAr"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
          Container(
              height: 60,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .05,
                right: MediaQuery.of(context).size.width * .05,
                top: MediaQuery.of(context).size.width * .012,
              ),
              color: SecondryColor,
              child: TextFormField(
                  controller: descar,
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    hintText: features.length == 0
                        ? getLang(context, "descrptionAr")
                        : features[0].descriptionAr == null
                            ? getLang(context, "descrptionAr")
                            : descAr,
                    hintStyle: TextStyle(color: PrimaryColor),
                  ))),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width * .05,
                0,
                MediaQuery.of(context).size.width * .05,
                0),
            color: SecondryColor,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * .8,
                    child: Text(
                      getLang(context, "price"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
              ],
            ),
          ),
          Container(
              height: 60,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .05,
                right: MediaQuery.of(context).size.width * .05,
                top: MediaQuery.of(context).size.width * .012,
              ),
              color: SecondryColor,
              child: TextFormField(
                  controller: price,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp(r'(^\d*\.?\d*)'))
                  ],
                  style: TextStyle(color: PrimaryColor, fontSize: 15),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: PrimaryColor),
                        borderRadius: BorderRadius.circular(2)),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    labelText: features.length == 0
                        ? getLang(context, "price")
                        : features[0].price == null
                            ? getLang(context, "price")
                            : pricetxt,
                    labelStyle: TextStyle(color: PrimaryColor),
                  ))),
          TextButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: SecondryColor)))),
              onPressed: () async {
                String englishName = lableen.text;
                String arabichName = lablear.text;
                String descEnhName = descen.text;
                String descArName = descar.text;
                var pricetxt = price.text;

                await featuresAPi(widget.id, englishName, arabichName,
                    descEnhName, descArName, pricetxt);

                await _getData(widget.id).then((productsList) {
                  setState(() {
                    features = productsList;
                  });
                });
              },
              child: Text(
                getLang(context, "Save"),
                style: TextStyle(color: SecondryColor),
              )),
        ],
      ),
    );
  }
}
