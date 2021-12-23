import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/Module/Colors.dart';
import 'package:jettaexstores/Module/Sub2Category.dart';
import 'package:jettaexstores/Module/Sub3Category.dart';
import 'package:jettaexstores/Module/Subcategory.dart';
import 'package:jettaexstores/Module/categoryapi.dart';
import 'package:jettaexstores/Module/productImage.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Module/brand.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Screens/ProdcutDitalScreen.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController en = TextEditingController();
  TextEditingController idt = TextEditingController();
  TextEditingController ar = TextEditingController();

  TextEditingController den = TextEditingController();
  TextEditingController der = TextEditingController();
  TextEditingController p1 = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController warranty = TextEditingController();
  TextEditingController model = TextEditingController();

  //SharedPreferences sharedPreferences;
  List<MainCategory> mainCat = [];
  List<SubCategory> subCat = [];
  List<Sub2Category> sub2Cat = [];
  List<Sub3Category> sub3Cat = [];
  List<Brands> brand = [];
  dynamic storeData;
  String value;
  String _cat;
  String _subCat;
  String _sub2Cat;
  String _sub3Cat;
  String _brand;
  Future<File> file;
  String status = '';
  String base64Image;
  File images;
  File images2;
  File colors;
  final imagePicker = ImagePicker();
  final imagePicker2 = ImagePicker();
  String primaryImage = '';
  String secondryImage = '';
  String color = '';
  bool loadSub = false;
  String selectedCat = '';
  var proID = 0;
  var lang = sharedPreferences.getString("lang");

  List<ProductsApi> products = [];
  List<ProdcutImage> productImages = [];
  List<ProductColors> prodcutColorsList = [];

  Future deleteMainImage(var id) async {
    String url = Api.deleteMainImage;
    try {
      final response =
          await http.post(Uri.parse(url), body: {"id": id.toString()});
    } catch (e) {}
  }

  Future<List<ProdcutImage>> _getProdcutImages(int id) async {
    String url = Api.getProductImage + id.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<ProdcutImage> Images = prodcutImageFromJson(response.body);
      return Images;
    } else {
      // ignore: deprecated_member_use
      return List<ProdcutImage>();
    }
  }

  Future<List<ProductColors>> _getProdcutColors(int id) async {
    String url = Api.getProductColors + id.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<ProductColors> colors = productColorsFromJson(response.body);
      return colors;
    } else {
      // ignore: deprecated_member_use
      return List<ProductColors>();
    }
  }

  Future<List<ProductsApi>> _getData(int id) async {
    var getStoreID = {"storeID": sharedPreferences.getString("storeID")};

    String url = Api.productViewEdit + id.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<ProductsApi> productsList = productsApiFromJson(response.body);
      return productsList;
    } else {
      // ignore: deprecated_member_use
      return List<ProductsApi>();
    }
  }

  Future<bool> updateEName(var id, String name_en) async {
    final response = await http.post(Uri.parse(Api.updateProEName),
        body: {"id": id.toString(), "name_en": name_en});

    var json = jsonDecode(response.body);

    return true;
  }

  Future<bool> updateWarranty(var id, String warranty) async {
    final response = await http.post(Uri.parse(Api.updateWarranty),
        body: {"id": id.toString(), "warranty": warranty});

    var json = jsonDecode(response.body);
    print(json);
    return true;
  }

  Future<bool> updateModel(var id, String Model) async {
    final response = await http.post(Uri.parse(Api.updateModelNumber),
        body: {"id": id.toString(), "model_number": Model});

    var json = jsonDecode(response.body);
    print(json);

    return true;
  }

  Future updateDiscount(var id, var discount) async {
    final response = await http.post(Uri.parse(Api.updateDiscount),
        body: {"id": id.toString(), "discount": discount.toString()});

    return true;
  }

  Future<bool> updateAName(var id, String name_ar) async {
    final response = await http.post(Uri.parse(Api.updateProAName),
        body: {"id": id.toString(), "name_ar": name_ar});

    return true;
  }

  Future<bool> updateADesc(var id, String ARDesc) async {
    final response = await http.post(Uri.parse(Api.updateProADesc),
        body: {"id": id.toString(), "description_ar": ARDesc});

    return true;
  }

  Future<bool> updateEDesc(var id, String EDesc) async {
    final response = await http.post(Uri.parse(Api.updateProEDesc),
        body: {"id": id.toString(), "description_en": EDesc.toString()});

    return true;
  }

  Future insertImage(int productId, String image, String imageDecode) async {
    String url = Api.InsertImage;
    final response = await http.post(Uri.parse(url), body: {
      "img_url": image,
      "product_id": productId.toString(),
      "productImageDecode": imageDecode
    });
  }

  Future insertPrimaryImage(
      int productId, String image, String imageDecode) async {
    String url = Api.InsertPrimaryImage;
    final response = await http.post(Uri.parse(url), body: {
      "id": productId.toString(),
      "image": image,
      "productImageDecode": imageDecode
    });
  }

  Future updatePrice(int id, var price) async {
    String url = Api.updatePrice;
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "price": price.toString()});
  }

  Future insertColors(int productId, String color, String colorDecode) async {
    String url = Api.insertColors;
    final response = await http.post(Uri.parse(url), body: {
      "product_id": productId.toString(),
      "color_code": color,
      "colorDecode": colorDecode
    });
  }

  Future getImage(ImageSource src) async {
    final pickedFile = await imagePicker.pickImage(source: src);

    setState(() {
      if (pickedFile != null) {
        images = File(pickedFile.path);
      } else {}
    });
  }

  Future getColor(ImageSource src) async {
    final pickedFile = await imagePicker.pickImage(source: src);

    if (pickedFile != null) {
      colors = File(pickedFile.path);
      color = colors.path.split('image_picker').last;
      String colorDecode = base64Encode(colors.readAsBytesSync());
      await insertColors(proID, color, colorDecode);

      setState(() {
        _getProdcutColors(proID).then((colors) {
          setState(() {
            prodcutColorsList = colors;
          });
        });
      });
    } else {}
  }

  Future getImage2(ImageSource src) async {
    final pickedFile2 = await imagePicker2.pickImage(source: src);

    if (pickedFile2 != null) {
      images2 = File(pickedFile2.path);

      secondryImage = images2.path.split('image_picker').last;

      String secondryImageDecode = base64Encode(images2.readAsBytesSync());

      await insertImage(proID, secondryImage, secondryImageDecode);

      setState(() {
        _getProdcutImages(proID).then((images) {
          setState(() {
            productImages = images;
          });
        });
      });
    } else {}
  }

  Future _getMainCategories() async {
    String url = Api.getMainCategories;

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<MainCategory> categoriesList =
          mainCategoryFromJson(response.body);

      return categoriesList;
    } else {
      // ignore: deprecated_member_use
      return List<MainCategory>();
    }
  }

  Future _getBrands() async {
    String url = Api.getBrands;

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Brands> brandList = brandsFromJson(response.body);

      return brandList;
    } else {
      // ignore: deprecated_member_use
      return List<Brands>();
    }
  }

  Future<List<SubCategory>> _getSubCategory(var Cat_id) async {
    String url = Api.getSubCategories + Cat_id.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<SubCategory> subCategoriesList =
          subCategoryFromJson(response.body);

      return subCategoriesList;
    } else {
      // ignore: deprecated_member_use
      return List<SubCategory>();
    }
  }

  Future<List<Sub2Category>> _getSub2Category(var subCat_id) async {
    String url = Api.getSub2Categories + subCat_id.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Sub2Category> sub2CategoriesList =
          sub2CategoryFromJson(response.body);

      return sub2CategoriesList;
    } else {
      // ignore: deprecated_member_use
      return List<Sub2Category>();
    }
  }

  Future<List<Sub3Category>> _getSub3Category(var sub2Cat_id) async {
    String url = Api.getSub3Categories + sub2Cat_id.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Sub3Category> sub3CategoriesList =
          sub3CategoryFromJson(response.body);

      return sub3CategoriesList;
    } else {
      // ignore: deprecated_member_use
      return List<Sub3Category>();
    }
  }

  Future insertCategory(int id, var newCat) async {
    String url = Api.insertMainCategory;
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "newCatID": newCat.toString()});
  }

  Future insertBrand(int id, var brand) async {
    String url = Api.InsertBrand;
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "brand_id": brand.toString()});
  }

  Future insertSub1(int id, var newSub1) async {
    String url = 'http://45.76.132.167/api/authentication/insertSub1.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "newSub1CatID": newSub1.toString()});
  }

  Future insertSub2(int id, var newSub2) async {
    String url = Api.insertsub2Category;
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "newSub2CatID": newSub2.toString()});
  }

  Future insertSub3(int id, var newSub3) async {
    String url = Api.insertsub3Category;
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "newSub3CatID": newSub3.toString()});
  }

  Future deleteSecondryImage(int id) async {
    String url = Api.deleteSecondryImage;
    final response =
        await http.post(Uri.parse(url), body: {"id": id.toString()});
  }

  Future deleteColor(int id) async {
    String url = Api.deleteColor;
    final response =
        await http.post(Uri.parse(url), body: {"id": id.toString()});
  }

  void setdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      // storeData = jsonDecode(sharedPreferences.getString("userdata"));
    });
  }

  //with shared pref
  @override
  void dispose() {
    imageCache.clear();
    super.dispose();
  }

  void initState() {
    super.initState();

    _getMainCategories().then((categoriesList) {
      setState(() {
        mainCat = categoriesList;
      });
    });

    proID = sharedPreferences.getInt('selectedProductID');

    _getData(proID).then((productsList) {
      setState(() {
        products = productsList;
      });
    });

    _getProdcutImages(proID).then((Images) {
      setState(() {
        productImages = Images;
      });
    });

    _getProdcutColors(proID).then((colors) {
      setState(() {
        prodcutColorsList = colors;
      });
    });

    _getBrands().then((brandList) {
      brand = brandList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final productdata =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    //proID = productdata['id'];

    return Scaffold(
        backgroundColor: PrimaryColor,
        appBar: AppBar(
          foregroundColor: SecondryColor,
          backgroundColor: PrimaryColor,
          title: lang == 'ar'
              ? Text(getLang(context, "EditProduct"),
                  style: TextStyle(
                    color: SecondryColor,
                  ))
              : Text(getLang(context, "EditProduct"),
                  style: TextStyle(
                    color: SecondryColor,
                  )),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProscutDitalScreen()),
                );
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                                child: lang == 'ar'
                                    ? Text(
                                        getLang(context, "MasterImage"),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryColor,
                                        ),
                                      )
                                    : Text(
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
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Container(
                            child: ListView.builder(
                          itemBuilder: (context, int index) {
                            ProductsApi productsApi = products[index];
                            if (products.isEmpty) {
                              return Center(
                                child: Text('HI'),
                              );
                            } else {
                              return Container(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: images == null
                                              ? Image.network(
                                                  Api.imageUrl +
                                                      productsApi.image,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .6,
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
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .6,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .6,
                                                )),
                                      Container(
                                        color: Colors.transparent,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .25,
                                        child: IconButton(
                                          onPressed: () async {
                                            await deleteMainImage(proID);

                                            setState(() {
                                              _getData(proID)
                                                  .then((productsList) {
                                                setState(() {
                                                  products = productsList;
                                                });
                                              });

                                              imageCache.clear();
                                            });

                                            setState(() {
                                              imageCache.clearLiveImages();
                                            });
                                          },
                                          icon: const Icon(Icons.delete),
                                          iconSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.transparent,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .25,
                                        child: IconButton(
                                          onPressed: () async {
                                            if (images != null) {
                                              primaryImage = 'PrimaryImage' +
                                                  sharedPreferences
                                                      .getString('storeID') +
                                                  '.' +
                                                  images.path.split('.').last;

                                              String primaryImageDecode =
                                                  base64Encode(
                                                      images.readAsBytesSync());

                                              await insertPrimaryImage(
                                                  proID,
                                                  primaryImage,
                                                  primaryImageDecode);

                                              setState(() {
                                                _getData(proID)
                                                    .then((productsList) {
                                                  setState(() {
                                                    products = productsList;
                                                  });
                                                });
                                              });

                                              setState(() {
                                                imageCache.clearLiveImages();
                                              });
                                            } else {}
                                          },
                                          icon: const Icon(Icons.save),
                                          iconSize: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ]),
                                  ));
                            }
                          },
                          itemCount: null == products ? 0 : products.length,
                        )),
                      ),
                      Column(
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
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: lang == 'ar'
                                        ? Text(
                                            getLang(context, "ProuctName"),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: PrimaryColor,
                                            ),
                                          )
                                        : Text(
                                            getLang(context, "ProuctName"),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: PrimaryColor,
                                            ),
                                          )),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  controller: en,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: PrimaryColor),
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      hintText: productdata['nameen'],
                                      hintStyle:
                                          TextStyle(color: PrimaryColor)),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String englishName = en.text;
                                      await updateEName(proID, englishName);

                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  controller: ar,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    hintText: productdata['namear'],
                                    hintStyle: TextStyle(color: PrimaryColor),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String arabicName = ar.text;
                                      await updateAName(proID, arabicName);

                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      Column(
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
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: lang == 'ar'
                                        ? Text(
                                            getLang(context, "ProductDesc"),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: PrimaryColor,
                                            ),
                                          )
                                        : Text(
                                            getLang(context, "ProductDesc"),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: PrimaryColor,
                                            ),
                                          )),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  maxLines: 10,
                                  controller: den,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    hintText: productdata['desen'],
                                    hintStyle: TextStyle(color: PrimaryColor),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String englishDescription = den.text;
                                      await updateEDesc(
                                          proID, englishDescription);

                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  maxLines: 10,
                                  controller: der,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    hintText: productdata['desar'],
                                    hintStyle: TextStyle(color: PrimaryColor),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String arabicDiscription = der.text;
                                      await updateADesc(
                                          proID, arabicDiscription);
                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
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
                                child: lang == 'ar'
                                    ? Text(
                                        getLang(context, "ProductImages"),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryColor,
                                        ),
                                      )
                                    : Text(
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
                                    height: MediaQuery.of(context).size.height *
                                        .25,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            Api.imageUrl + prodcutImage.imgUrl,
                                            fit: BoxFit.fitHeight,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .65,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .25,
                                          ),
                                        ),
                                        Container(
                                          color: Colors.transparent,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25,
                                          child: IconButton(
                                            onPressed: () async {
                                              var id = prodcutImage.id;

                                              await deleteSecondryImage(id);

                                              setState(() {
                                                _getProdcutImages(proID)
                                                    .then((images) {
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
                            itemCount: null == productImages
                                ? 0
                                : productImages.length,
                          ),
                        ),
                      ),
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
                                child: lang == 'ar'
                                    ? Text(
                                        getLang(context, "productColors"),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: PrimaryColor,
                                        ),
                                      )
                                    : Text(
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
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Container(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              ProductColors prodcutColors =
                                  prodcutColorsList[index];
                              if (prodcutColorsList.isEmpty) {
                                return Center(
                                    child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
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
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(color: PrimaryColor),
                                  ),
                                ));
                              } else {
                                return Container(
                                    height: MediaQuery.of(context).size.height *
                                        .25,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Image.network(
                                            Api.colorUrl +
                                                prodcutColors.colorCode,
                                            fit: BoxFit.fitHeight,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .65,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .25,
                                          ),
                                        ),
                                        Container(
                                          color: Colors.transparent,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .25,
                                          child: IconButton(
                                            onPressed: () async {
                                              int id = prodcutColors.id;
                                              await deleteColor(id);

                                              setState(() {
                                                _getProdcutColors(proID)
                                                    .then((colors) {
                                                  setState(() {
                                                    prodcutColorsList = colors;
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
                            itemCount: null == prodcutColorsList
                                ? 0
                                : prodcutColorsList.length,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
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
                                  child: lang == 'ar'
                                      ? Text(
                                          getLang(context, "PriceDiscount"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        )
                                      : Text(
                                          getLang(context, "PriceDiscount"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  controller: p1,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    hintText: productdata['price'].toString(),
                                    hintStyle: TextStyle(color: PrimaryColor),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String price = p1.text;
                                      await updatePrice(proID, price);
                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  controller: discount,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    hintText:
                                        productdata['discount'].toString(),
                                    hintStyle: TextStyle(color: PrimaryColor),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String discountTxt = discount.text;
                                      await updateDiscount(proID, discountTxt);

                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      Column(
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
                                  child: lang == 'ar'
                                      ? Text(
                                          getLang(context, "warranty"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        )
                                      : Text(
                                          getLang(context, "warranty"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  controller: warranty,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    hintText:
                                        productdata['warranty'].toString(),
                                    hintStyle: TextStyle(color: PrimaryColor),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String warrantyTxt = warranty.text;
                                      await updateWarranty(proID, warrantyTxt);
                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      Column(
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
                                  child: lang == 'ar'
                                      ? Text(
                                          getLang(context, "modelNumber"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        )
                                      : Text(
                                          getLang(context, "modelNumber"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width * .05,
                                0,
                                MediaQuery.of(context).size.width * .05,
                                0),
                            color: SecondryColor,
                            child: ListTile(
                                title: TextFormField(
                                  controller: model,
                                  style: TextStyle(
                                      color: PrimaryColor, fontSize: 10),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 2, color: PrimaryColor),
                                        borderRadius: BorderRadius.circular(2)),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    hintText:
                                        productdata['modelNumber'].toString(),
                                    hintStyle: TextStyle(color: PrimaryColor),
                                  ),
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      String modelTxt = model.text;
                                      await updateModel(proID, modelTxt);
                                      setState(() {
                                        _getData(proID).then((productsList) {
                                          setState(() {
                                            products = productsList;
                                          });
                                        });
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.save,
                                      color: PrimaryColor,
                                    ))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                      brands(),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
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
                                  child: lang == 'ar'
                                      ? Text(
                                          getLang(context, "Categories"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        )
                                      : Text(
                                          getLang(context, "Categories"),
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: PrimaryColor,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          mainCategory(),
                        ],
                      ),
                      Column(
                        children: [
                          loadSub ? subCategory() : nullSubCategory(),
                        ],
                      ),
                      Column(
                        children: [
                          loadSub ? sub2Category() : nullSubCategory(),
                        ],
                      ),
                      Column(
                        children: [
                          loadSub ? sub3Category() : nullSubCategory(),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ));
  }

  Container mainCategory() {
    return Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .05, 0,
            MediaQuery.of(context).size.width * .05, 0),
        color: SecondryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: _cat,
                    iconSize: 30,
                    icon: const Icon(Icons.add),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    hint: lang == 'ar'
                        ? Text(
                            getLang(context, "MainCategory"),
                            style: TextStyle(color: PrimaryColor),
                          )
                        : Text(
                            getLang(context, "MainCategory"),
                            style: TextStyle(color: PrimaryColor),
                          ),
                    onChanged: (String newValue) {
                      setState(() {
                        _cat = newValue;
                        _subCat = null;
                        _sub2Cat = null;
                        _sub3Cat = null;
                        _getSubCategory(_cat).then((subCategoriesList) {
                          setState(() {
                            subCat = subCategoriesList;
                            loadSub = true;
                          });
                        });
                        insertCategory(proID, _cat);
                      });
                    },
                    items: mainCat.map((category) {
                          return DropdownMenuItem(
                              value: category.id.toString(),
                              child: lang == 'ar'
                                  ? Text(
                                      category.nameAr,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      category.nameEn,
                                      style: TextStyle(color: Colors.black),
                                    ));
                        }).toList() ??
                        [],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Container brands() {
    return Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .05, 0,
            MediaQuery.of(context).size.width * .05, 0),
        color: SecondryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    value: _brand,
                    iconSize: 30,
                    icon: const Icon(Icons.add),
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    hint: lang == 'ar'
                        ? Text(
                            getLang(context, "brand"),
                            style: TextStyle(color: PrimaryColor),
                          )
                        : Text(
                            getLang(context, "brand"),
                            style: TextStyle(color: PrimaryColor),
                          ),
                    onChanged: (String newValue) {
                      setState(() {
                        _brand = newValue;

                        insertBrand(proID, _brand);
                      });
                    },
                    items: brand.map((brands) {
                          return DropdownMenuItem(
                              value: brands.id.toString(),
                              child: lang == 'ar'
                                  ? Text(
                                      brands.nameAr,
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      brands.nameEn,
                                      style: TextStyle(color: Colors.black),
                                    ));
                        }).toList() ??
                        [],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Container nullSubCategory() {
    return Container();
  }

  Container subCategory() {
    return Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .05, 0,
          MediaQuery.of(context).size.width * .05, 0),
      color: SecondryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _subCat,
                  iconSize: 30,
                  icon: const Icon(Icons.add),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: lang == 'ar'
                      ? Text(
                          getLang(context, "SubCategories"),
                          style: TextStyle(color: PrimaryColor),
                        )
                      : Text(
                          getLang(context, "SubCategories"),
                          style: TextStyle(color: PrimaryColor),
                        ),
                  onChanged: (String newValue2) {
                    setState(() {
                      _subCat = newValue2;
                      _sub2Cat = null;
                      _sub3Cat = null;
                      _getSub2Category(_subCat).then((sub2CategoriesList) {
                        setState(() {
                          sub2Cat = sub2CategoriesList;
                          loadSub = true;
                        });
                      });
                      insertSub1(proID, _subCat);
                    });
                  },
                  items: subCat.map((subCategory) {
                        return DropdownMenuItem(
                            value: subCategory.id.toString(),
                            child: lang == 'ar'
                                ? Text(
                                    subCategory.nameAr,
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    subCategory.nameEn,
                                    style: TextStyle(color: Colors.black),
                                  ));
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container sub2Category() {
    return Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .05, 0,
          MediaQuery.of(context).size.width * .05, 0),
      color: SecondryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _sub2Cat,
                  iconSize: 30,
                  icon: const Icon(Icons.add),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: lang == 'ar'
                      ? Text(
                          getLang(context, "SubCategories2"),
                          style: TextStyle(color: PrimaryColor),
                        )
                      : Text(
                          getLang(context, "SubCategories2"),
                          style: TextStyle(color: PrimaryColor),
                        ),
                  onChanged: (String newValue3) {
                    setState(() {
                      _sub2Cat = newValue3;
                      _sub3Cat = null;
                      _getSub3Category(_sub2Cat).then((sub3CategoriesList) {
                        setState(() {
                          sub3Cat = sub3CategoriesList;
                          loadSub = true;
                        });
                      });
                      insertSub2(proID, _sub2Cat);
                    });
                  },
                  items: sub2Cat.map((sub2Category) {
                        return DropdownMenuItem(
                            value: sub2Category.id.toString(),
                            child: lang == 'ar'
                                ? Text(
                                    sub2Category.nameAr,
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    sub2Category.nameEn,
                                    style: TextStyle(color: Colors.black),
                                  ));
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container sub3Category() {
    return Container(
      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * .05, 0,
          MediaQuery.of(context).size.width * .05, 0),
      color: SecondryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  value: _sub3Cat,
                  iconSize: 30,
                  icon: const Icon(Icons.add),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                  hint: lang == 'ar'
                      ? Text(
                          getLang(context, "SubCategories3"),
                          style: TextStyle(color: PrimaryColor),
                        )
                      : Text(
                          getLang(context, "SubCategories3"),
                          style: TextStyle(color: PrimaryColor),
                        ),
                  onChanged: (String newValue4) {
                    setState(() {
                      _sub3Cat = newValue4;
                      insertSub3(proID, _sub3Cat);
                    });
                  },
                  items: sub3Cat.map((sub3Category) {
                        return DropdownMenuItem(
                            value: sub3Category.id.toString(),
                            child: lang == 'ar'
                                ? Text(
                                    sub3Category.nameAr,
                                    style: TextStyle(color: Colors.black),
                                  )
                                : Text(
                                    sub3Category.nameEn,
                                    style: TextStyle(color: Colors.black),
                                  ));
                      }).toList() ??
                      [],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
