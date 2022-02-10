import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/Module/productlastapi.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:jettaexstores/main.dart';

class MasterImage extends StatefulWidget {
  final int id;
  const MasterImage({Key key, this.id}) : super(key: key);

  @override
  _MasterImageState createState() => _MasterImageState();
}

class _MasterImageState extends State<MasterImage> {
  final imagePicker = ImagePicker();
  File images;
  List<ProductsApi> products = [];

  String primaryImage = '';
  var lang = sharedPreferences.getString("lang");

  Future deleteMainImage(var id) async {
    String url = Api.deleteMainImage;
    try {
      final response =
          await http.post(Uri.parse(url), body: {"id": id.toString()});
      var json = jsonDecode(response.body);
      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "Deleted"),
            style: TextStyle(color: PrimaryColor),
          ),
          action: SnackBarAction(label: '', onPressed: () {}),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print("hi");
      }
    } catch (e) {}
  }

  Future insertPrimaryImage(
      int productId, String image, String imageDecode) async {
    try {
      String url = Api.InsertPrimaryImage;
      final response = await http.post(Uri.parse(url), body: {
        "id": productId.toString(),
        "image": image,
        "productImageDecode": imageDecode
      });

      var json = jsonDecode(response.body);
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

  Future<List<ProductsApi>> _getData(int id) async {
    try {
      String url = Api.productViewEdit + id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<ProductsApi> productsList =
            productsApiFromJson(response.body);
        return productsList;
      } else {
        // ignore: deprecated_member_use
        return List<ProductsApi>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future getImage(ImageSource src) async {
    final pickedFile = await imagePicker.pickImage(source: src);

    setState(() {
      if (pickedFile != null) {
        images = File(pickedFile.path);
      } else {}
    });
  }

  @override
  void dispose() {
    super.dispose();
    imageCache.clear();
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.id).then((productsList) {
      setState(() {
        products = productsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                      getLang(context, "MasterImage"),
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
                        getImage(ImageSource.gallery);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: SecondryColor,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                Container(
                    child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, int index) {
                    ProductsApi productsApi = products[index];
                    if (products.isEmpty) {
                      print('object');
                      return Center(
                        child: Text('HI'),
                      );
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
                            child: Stack(
                              children: [
                                Row(children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: images == null
                                          ? Image.network(
                                              Api.imageUrl + productsApi.image,
                                              key: ValueKey(
                                                  new Random().nextInt(100)),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.96,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .6,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent
                                                          loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: PrimaryColor,
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes
                                                        : null,
                                                  ),
                                                );
                                              },
                                            )
                                          : Image.file(
                                              images,
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.96,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .6,
                                            )),
                                ]),
                              ],
                            ),
                          ));
                    }
                  },
                  itemCount: null == products ? 0 : products.length,
                )),
                Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * .1,
                  width: MediaQuery.of(context).size.width * .3,
                  child: TextButton(
                    onPressed: () async {
                      if (images != null) {
                        var now = DateTime.now();

                        primaryImage = widget.id.toString() +
                            '' +
                            now.toString() +
                            '.' +
                            images.path.split('.').last;

                        String primaryImageDecode =
                            base64Encode(images.readAsBytesSync());

                        await insertPrimaryImage(
                            widget.id, primaryImage, primaryImageDecode);

                        await _getData(widget.id).then((productsList) {
                          setState(() {
                            products = productsList;
                          });
                        });

                        setState(() {
                          imageCache.clearLiveImages();
                          imageCache.clear();
                        });
                      } else {
                        print("null");
                      }
                    },
                    child: Text(getLang(context, "Save")),
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height * .1,
                  child: TextButton(
                    onPressed: () async {
                      await deleteMainImage(widget.id);

                      await _getData(widget.id).then((productsList) {
                        setState(() {
                          products = productsList;
                        });
                      });

                      imageCache.clear();

                      setState(() {
                        imageCache.clearLiveImages();
                        imageCache.clear();
                      });
                    },
                    child: Text(getLang(context, "Delete")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
