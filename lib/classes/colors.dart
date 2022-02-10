import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/Module/Colors.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';

class ProductColor extends StatefulWidget {
  final int id;
  const ProductColor({Key key, this.id}) : super(key: key);

  @override
  _ProductColorState createState() => _ProductColorState();
}

class _ProductColorState extends State<ProductColor> {
  final imagePicker = ImagePicker();
  File colors;
  String color = '';
  List<ProductColors> prodcutColorsList = [];

  Future deleteColor(int id) async {
    try {
      String url = Api.deleteColor;
      final response =
          await http.post(Uri.parse(url), body: {"id": id.toString()});

      var json = jsonDecode(response.body);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "colordDeleted"),
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

  Future insertColors(int productId, String color, String colorDecode) async {
    try {
      String url = Api.insertColors;
      final response = await http.post(Uri.parse(url), body: {
        "product_id": productId.toString(),
        "color_code": color,
        "colorDecode": colorDecode
      });
      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "coloradded"),
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

  Future<List<ProductColors>> _getProdcutColors(int id) async {
    try {
      String url = Api.getProductColors + id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<ProductColors> colors = productColorsFromJson(response.body);
        return colors;
      } else {
        // ignore: deprecated_member_use
        return List<ProductColors>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future getColor(ImageSource src) async {
    final pickedFile = await imagePicker.pickImage(source: src);

    if (pickedFile != null) {
      colors = File(pickedFile.path);
      color = colors.path.split('image_picker').last;
      String colorDecode = base64Encode(colors.readAsBytesSync());
      await insertColors(widget.id, color, colorDecode);

      setState(() {
        _getProdcutColors(widget.id).then((colors) {
          setState(() {
            prodcutColorsList = colors;
          });
        });
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _getProdcutColors(widget.id).then((colors) {
      setState(() {
        prodcutColorsList = colors;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
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
                      getLang(context, "productColors"),
                      style: TextStyle(
                        fontSize: 20,
                        color: PrimaryColor,
                      ),
                    )),
                Container(
                  width: MediaQuery.of(context).size.width * .1,
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        getColor(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: SecondryColor,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
            height: MediaQuery.of(context).size.height * 0.30,
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  ProductColors prodcutColors = prodcutColorsList[index];
                  if (prodcutColorsList.isEmpty) {
                    return Center(
                        child: Container(
                      child: Text('Loading...'),
                    ));
                  } else {
                    return Container(
                        height: MediaQuery.of(context).size.height * .25,
                        width: MediaQuery.of(context).size.width * .8,
                        padding: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * .0,
                            MediaQuery.of(context).size.height * 0,
                            MediaQuery.of(context).size.width * .0,
                            MediaQuery.of(context).size.width * 0),
                        margin: EdgeInsets.fromLTRB(
                            MediaQuery.of(context).size.width * .02,
                            0,
                            MediaQuery.of(context).size.width * .02,
                            0),
                        decoration: BoxDecoration(
                          color: Color(0xff666666),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                Api.colorUrl + prodcutColors.colorCode,
                                fit: BoxFit.fitHeight,
                                width: MediaQuery.of(context).size.width * .65,
                                height:
                                    MediaQuery.of(context).size.height * .25,
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              height: MediaQuery.of(context).size.height * .25,
                              child: IconButton(
                                onPressed: () async {
                                  int id = prodcutColors.id;
                                  await deleteColor(id);

                                  await _getProdcutColors(widget.id)
                                      .then((colors) {
                                    setState(() {
                                      prodcutColorsList = colors;
                                    });
                                  });
                                },
                                icon: const Icon(Icons.delete),
                                iconSize: 20,
                                color: Colors.red,
                              ),
                            )
                          ]),
                        ));
                  }
                },
                itemCount:
                    null == prodcutColorsList ? 0 : prodcutColorsList.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
