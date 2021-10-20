import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/config/Constant.dart';
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
  //SharedPreferences sharedPreferences;
  //List<Categories> mainCat = [];
  //List<SubCategories> subCat = [];
  dynamic storeData;
  String value;
  String _cat;
  String _subCat;
  Future<File> file;
  String status = '';
  String base64Image;
  File images;
  final imagePicker = ImagePicker();
  String errMessage = 'Error Uploading Image';

  Future<bool> updateEName(var id, String name_en) async {
    final response = await http.post(
        Uri.parse('http://45.76.132.167/api/authentication/updateProEName.php'),
        body: {"id": id.toString(), "name_en": name_en});

    print(response.body);

    return true;
  }

  Future updateDiscount(var id, var discount) async {
    final response = await http.post(
        Uri.parse('http://45.76.132.167/api/authentication/updateDiscount.php'),
        body: {"id": id.toString(), "discount": discount.toString()});

    print(response.body);

    return true;
  }

  Future<bool> updateAName(var id, String name_ar) async {
    final response = await http.post(
        Uri.parse('http://45.76.132.167/api/authentication/updateProAName.php'),
        body: {"id": id.toString(), "name_ar": name_ar});
    print(response.body);

    return true;
  }

  Future<bool> updateADesc(var id, String ARDesc) async {
    final response = await http.post(
        Uri.parse('http://45.76.132.167/api/authentication/updateProADesc.php'),
        body: {"id": id.toString(), "description_ar": ARDesc});

    print(response.body);

    return true;
  }

  Future<bool> updateEDesc(var id, String EDesc) async {
    final response = await http.post(
        Uri.parse('http://45.76.132.167/api/authentication/updateProEDesc.php'),
        body: {"id": id.toString(), "description_en": EDesc.toString()});

    print(response.body);

    return true;
  }

  Future insertImage(int productId, String image) async {
    String url = 'http://45.76.132.167/api/authentication/insertimage.php';
    final response = await http.post(Uri.parse(url),
        body: {"product_id": productId.toString(), "img_url": image});

    print('RESPONSE------>' + response.body);
  }

  Future updatePrice(int id, var price) async {
    String url = 'http://45.76.132.167/api/authentication/updatePrice.php';
    final response = await http.post(Uri.parse(url),
        body: {"id": id.toString(), "price": price.toString()});

    print('RESPONSE------>' + response.body);
  }

  Future insertColors(int productId, String color) async {
    String url = 'http://45.76.132.167/api/authentication/insertColors.php';
    final response = await http.post(Uri.parse(url),
        body: {"product_id": productId.toString(), "color_code": color});

    print('RESPONSE------>' + response.body);
  }

  Future getImage(ImageSource src) async {
    final pickedFile = await imagePicker.pickImage(source: src);

    setState(() {
      if (pickedFile != null) {
        images = File(pickedFile.path);
      } else {
        print('non');
      }
    });
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  // Future<List<Categories>> _getData() async {
  //   String url = 'http://45.76.132.167/api/authentication/categoryList.php';

  //   var response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final List<Categories> categoriesList = categoriesFromJson(response.body);

  //     return categoriesList;
  //   } else {
  //     // ignore: deprecated_member_use
  //     return List<Categories>();
  //   }
  // }

  // Future<List<bool>> _getSubCategory(var Cat_id) async {
  //   String url =
  //       'http://45.76.132.167/api/authentication/Sub1Category.php?category_id=' +
  //           Cat_id.toString();

  //   var response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     final List<SubCategories> subCategoriesList =
  //         subCategoriesFromJson(response.body);

  //     subCat = subCategoriesList;
  //   } else {}
  // }

  void setdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      storeData = jsonDecode(sharedPreferences.getString("userdata"));
    });
  }

  //with shared pref
  @override
  void initState() {
    super.initState();

    // _getData().then((categoriesList) {
    //   setState(() {
    //     mainCat = categoriesList;
    //   });
    // });

    setdata();
  }

  @override
  Widget build(BuildContext context) {
    final productdata =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    var proID = productdata['id'];

    return Scaffold(
      backgroundColor: PrimaryColor,
      appBar: AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text('Edit Product',
            style: TextStyle(
              color: SecondryColor,
            )),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * .2,
                  width: MediaQuery.of(context).size.height * .9,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        photocon(Icons.camera_alt, "Primary Product Photo"),
                        // photocon(Icons.camera_alt_outlined, "Secondery Photo"),
                        // photocon(Icons.camera_alt_outlined, "Secondery Photo"),
                        // photocon(Icons.camera_alt_outlined, "Secondery Photo"),
                        // photocon(Icons.camera_alt_outlined, "Secondery Photo"),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .8,
                width: MediaQuery.of(context).size.height * .7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      cont(
                          en,
                          Icons.edit,
                          TextInputType.text,
                          productdata['nameen'],
                          IconButton(
                            onPressed: () async {
                              String englishName = en.text;
                              await updateEName(proID, englishName);
                              setState(() {
                                productdata['nameen'].toString();
                              });
                            },
                            icon: const Icon(Icons.save),
                            color: PrimaryColor,
                          )),
                      cont(
                          den,
                          Icons.edit,
                          TextInputType.text,
                          productdata['desen'],
                          IconButton(
                            onPressed: () {
                              String englishDiscription = den.text;
                              updateEDesc(proID, englishDiscription);
                            },
                            icon: const Icon(Icons.save),
                            color: PrimaryColor,
                          )),
                      cont(
                          ar,
                          Icons.edit,
                          TextInputType.text,
                          productdata['namear'],
                          IconButton(
                            onPressed: () {
                              String arabicName = ar.text;
                              updateAName(proID, arabicName);
                            },
                            icon: const Icon(Icons.save),
                            color: PrimaryColor,
                          )),
                      cont(
                          der,
                          Icons.edit,
                          TextInputType.text,
                          productdata['desar'],
                          IconButton(
                            onPressed: () {
                              String arabicDiscription = der.text;
                              updateADesc(proID, arabicDiscription);
                            },
                            icon: const Icon(Icons.save),
                            color: PrimaryColor,
                          )),
                      // mainCategory(),
                      // subCategory(),
                      // mainCategory(),
                      //mainCategory(),
                      colorContinaer("Color", context),
                      cont(
                          p1,
                          Icons.edit,
                          TextInputType.number,
                          productdata['price'].toString(),
                          IconButton(
                            onPressed: () {
                              String price = p1.text;
                              updatePrice(proID, price);
                            },
                            icon: const Icon(Icons.save),
                            color: PrimaryColor,
                          )),
                      cont(
                          discount,
                          Icons.edit,
                          TextInputType.number,
                          productdata['discount'].toString(),
                          IconButton(
                            onPressed: () {
                              String discountTxt = discount.text;
                              updateDiscount(proID, discountTxt);
                            },
                            icon: const Icon(Icons.save),
                            color: PrimaryColor,
                          )),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (images == null) {
                    print('No photo');
                  } else {
                    String image = images.path.split('/').last;
                    print('IMG---->' + image);
                    insertImage(proID, image);
                  }

                  String selectedColor = color.toString();
                  selectedColor = selectedColor.substring(5);
                  selectedColor = selectedColor.replaceAll('(', '');
                  selectedColor = selectedColor.replaceAll(')', '');
                  selectedColor = selectedColor.substring(4);
                  selectedColor = '#' + selectedColor;

                  if (selectedColor[2] == 'l') {
                    print('object');
                  } else {
                    print(selectedColor);
                    insertColors(proID, selectedColor);
                  }
                },
                child: Container(
                  //padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(
                    horizontal: 90,
                  ),
                  decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  child: ListTile(
                    title: Text('Add Product ',
                        style: TextStyle(
                            color: SecondryColor, fontWeight: FontWeight.bold)),
                    trailing: Icon(
                      Icons.arrow_right,
                      color: SecondryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container photocon(IconData ic, String tx) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: SecondryColor, borderRadius: BorderRadius.circular(5)),
      child: images == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                    // Navigator.of(context).pop();
                  },
                  icon: Icon(ic),
                ),
                Text(
                  tx,
                  style: TextStyle(
                      fontSize: 10,
                      color: PrimaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          : Image.file(
              images,
              fit: BoxFit.cover,
            ),
    );
  }

  Container cont(TextEditingController te, IconData icon, TextInputType tybe,
      String lab, IconButton iconButton) {
    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: SecondryColor, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: Icon(
          icon,
          color: PrimaryColor,
        ),
        title: TextFormField(
          controller: te,
          style: TextStyle(color: PrimaryColor),
          // controller: ,
          keyboardType: tybe,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: PrimaryColor),
                borderRadius: BorderRadius.circular(2)),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            labelText: lab,
            labelStyle: TextStyle(color: PrimaryColor),
            // hintText: title,
            // hintStyle: TextStyle(color: PrimaryColor),
          ),
        ),
        trailing: iconButton,
      ),
    );
  }

  Container descont(TextEditingController te, IconData icon, String title,
      TextInputType tybe, String lab) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
          color: SecondryColor, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: Icon(
          icon,
          color: PrimaryColor,
        ),
        title: Container(
          child: TextFormField(
            controller: te,
            style: TextStyle(color: PrimaryColor),
            // controller: ,
            keyboardType: tybe,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: PrimaryColor),
                  borderRadius: BorderRadius.circular(2)),
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              labelText: lab,
              labelStyle: TextStyle(color: PrimaryColor),
              hintText: title,
              hintStyle: TextStyle(color: PrimaryColor),
            ),
          ),
        ),
      ),
    );
  }

  Color color = Colors.red;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);
  Widget bildcolorpiker() => ColorPicker(
      pickerColor: color,
      onColorChanged: (color) => setState(
            () => this.color = color,
          ));

  void pickColor(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
              child: Column(
            children: [
              bildcolorpiker(),
              TextButton(
                child: Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ))));

  Container colorContinaer(String st, BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: SecondryColor, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        title: Text(st,
            style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                pickColor(ctx);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: CircleAvatar(
                  backgroundColor: color,
                  radius: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 12,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Container mainCategory() {
  //   return Container(
  //     padding: EdgeInsets.all(5),
  //     margin: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //         color: SecondryColor, borderRadius: BorderRadius.circular(5)),
  //     child: ListTile(
  //       title: Text('',
  //           style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold)),
  //       trailing: DropdownButtonHideUnderline(
  //         child: ButtonTheme(
  //             alignedDropdown: true,
  //             child: DropdownButton<String>(
  //                 value: _cat,
  //                 iconSize: 30,
  //                 icon: const Icon(Icons.add),
  //                 style: TextStyle(
  //                   color: Colors.black54,
  //                   fontSize: 16,
  //                 ),
  //                 //hint: Text('Select Category'),
  //                 onChanged: (String newValue) async {
  //                   _cat = newValue;
  //                   subCat.clear();
  //                   await _getSubCategory(_cat);
  //                   setState(() {});

  //                   // print('Value ' + newValue);
  //                 },
  //                 items: mainCat.map((category) {
  //                   return DropdownMenuItem(
  //                     value: category.id.toString(),
  //                     child: Text(category.nameEn),
  //                   );
  //                 }).toList())),
  //       ),
  //     ),
  //   );
  // }

  // Container subCategory() {
  //   return Container(
  //     padding: EdgeInsets.all(5),
  //     margin: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //         color: SecondryColor, borderRadius: BorderRadius.circular(5)),
  //     child: ListTile(
  //       title: Text('',
  //           style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold)),
  //       trailing: DropdownButtonHideUnderline(
  //         child: ButtonTheme(
  //             alignedDropdown: true,
  //             child: DropdownButton<String>(
  //                 value: _subCat,
  //                 iconSize: 30,
  //                 icon: const Icon(Icons.add),
  //                 style: TextStyle(
  //                   color: Colors.black54,
  //                   fontSize: 16,
  //                 ),
  //                 //hint: Text('Select Category'),
  //                 onChanged: (String newValue) {
  //                   setState(() {
  //                     _subCat = newValue;
  //                   });
  //                 },
  //                 items: subCat == null
  //                     ? CircularProgressIndicator
  //                     : subCat.map((subCategory) {
  //                         return DropdownMenuItem(
  //                           value: subCategory.id.toString(),
  //                           child: Text(subCategory.nameEn),
  //                         );
  //                       }).toList())),
  //       ),
  //     ),
  //   );
  // }

  // Container sub2Category() {
  //   return Container(
  //     padding: EdgeInsets.all(5),
  //     margin: EdgeInsets.all(5),
  //     decoration: BoxDecoration(
  //         color: SecondryColor, borderRadius: BorderRadius.circular(5)),
  //     child: ListTile(
  //       title: Text('',
  //           style: TextStyle(color: PrimaryColor, fontWeight: FontWeight.bold)),
  //       trailing: DropdownButtonHideUnderline(
  //         child: ButtonTheme(
  //             alignedDropdown: true,
  //             child: DropdownButton<String>(
  //                 value: _subCat,
  //                 iconSize: 30,
  //                 icon: const Icon(Icons.add),
  //                 style: TextStyle(
  //                   color: Colors.black54,
  //                   fontSize: 16,
  //                 ),
  //                 //hint: Text('Select Category'),
  //                 onChanged: (String newValue) {
  //                   setState(() {
  //                     _subCat = newValue;
  //                   });
  //                 },
  //                 items: subCat.map((subCategory) {
  //                   return DropdownMenuItem(
  //                     value: subCategory.id.toString(),
  //                     child: Text(subCategory.nameEn),
  //                   );
  //                 }).toList())),
  //       ),
  //     ),
  //   );
  // }

  // DropdownMenuItem<String> categoryiteam(String cat) => DropdownMenuItem(
  //       value: cat,
  //       child: Text(
  //         cat,
  //         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
  //       ),
  //     );

}
