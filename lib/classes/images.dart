import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/Module/productImage.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;

class ProductImages extends StatefulWidget {
  final int id;
  const ProductImages({Key key, this.id}) : super(key: key);

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  final imagePicker2 = ImagePicker();
  File images2;
  String secondryImage = '';
  List<ProdcutImage> productImages = [];

  Future insertImage(int productId, String image, String imageDecode) async {
    try {
      String url = Api.InsertImage;
      final response = await http.post(Uri.parse(url), body: {
        "img_url": image,
        "product_id": productId.toString(),
        "productImageDecode": imageDecode
      });
      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "ImageSaved"),
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

  Future deleteSecondryImage(int id) async {
    try {
      String url = Api.deleteSecondryImage;
      final response =
          await http.post(Uri.parse(url), body: {"id": id.toString()});
      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "Deleted"),
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

  Future<List<ProdcutImage>> _getProdcutImages(int id) async {
    try {
      String url = Api.getProductImage + id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<ProdcutImage> images = prodcutImageFromJson(response.body);
        return images;
      } else {
        // ignore: deprecated_member_use
        return List<ProdcutImage>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future getImage2(ImageSource src) async {
    final pickedFile2 = await imagePicker2.pickImage(source: src);

    if (pickedFile2 != null) {
      images2 = File(pickedFile2.path);

      secondryImage = images2.path.split('image_picker').last;

      String secondryImageDecode = base64Encode(images2.readAsBytesSync());

      await insertImage(widget.id, secondryImage, secondryImageDecode);

      setState(() {
        _getProdcutImages(widget.id).then((images) {
          setState(() {
            productImages = images;
          });
        });
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _getProdcutImages(widget.id).then((Images) {
      setState(() {
        productImages = Images;
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
                      getLang(context, "ProductImages"),
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
                        getImage2(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            color: SecondryColor,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
            height: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, int index) {
                  ProdcutImage prodcutImage = productImages[index];
                  if (productImages.isEmpty) {
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
                                Api.imageUrl + prodcutImage.imgUrl,
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
                                  var id = prodcutImage.id;

                                  await deleteSecondryImage(id);

                                  setState(() {
                                    _getProdcutImages(widget.id).then((images) {
                                      setState(() {
                                        productImages = images;
                                      });
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
                itemCount: null == productImages ? 0 : productImages.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
