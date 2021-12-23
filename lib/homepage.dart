import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/Module/Info_Api.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/alertdilog.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';
import 'package:jettaexstores/widget.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'Provider/Localapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Screens/LoginScreen.dart';
import 'config/Configers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//HIIII

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();
  dynamic userdata;
  var lang = sharedPreferences.getString("lang");
  var englishName = '';
  String imageName = '';

  Future getImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(source: src);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      } else {
        print('non');
      }
    });
  }

  Future updateLogo(var productId, String imageName, String imageCode) async {
    String url = 'http://45.76.132.167/api/authentication/UpdateLogo.php';
    final response = await http.post(Uri.parse(url), body: {
      "id": productId.toString(),
      "store_logo": imageName,
      "imageCode": imageCode
    });
  }

  Future deleteLogo(var id) async {
    String url = 'http://45.76.132.167/api/authentication/deleteLogo.php';
    try {
      final response =
          await http.post(Uri.parse(url), body: {"id": id.toString()});

      setState(() {
        sharedPreferences.setString('storeLogo', 'defaultStorelogo.jpg');
        imageCache.clear();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Infoapi>> _getData() async {
    String url = Api.getInfo;
    var getStore = {"storeID": sharedPreferences.getString("storeID")};

    var response = await http.post(
      Uri.parse(url),
      body: getStore,
    );
    var jsonData = json.decode(response.body);
    List<Infoapi> info = [];

    for (var itm in jsonData) {
      info.add(Infoapi.fromJson(itm));
    }
    return info;
  } //with shared pref

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_getData();
    //setdata();
  }

  void setdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userdata = jsonDecode(sharedPreferences.getString("userdata"));
    });
  }

  Widget buildContainer(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
          color: SecondryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildListTile(context, Icons.image, getLang(context, 'glalrydio'),
                ImageSource.gallery),
            buildListTile(context, Icons.camera, getLang(context, 'camdi'),
                ImageSource.camera),
          ],
        ),
      ),
    );
  }

  Widget buildListTile(
      BuildContext context, IconData icon, String fname, ImageSource src) {
    return ListTile(
      onTap: () {
        getImage(src);
        // });
        Navigator.of(context).pop();
      },
      leading: Icon(
        icon,
        color: PrimaryColor,
      ),
      title: Text(
        fname,
        style: TextStyle(color: PrimaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AlertDialog alertq = AlertDialog(
      backgroundColor: SecondryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: buildContainer(context),
    );

    return Scaffold(
      backgroundColor: SecondryColor,
      appBar: AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: lang == 'ar'
            ? Text(
                sharedPreferences.getString('storeNameAr'),
                style: TextStyle(
                    color: SecondryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    wordSpacing: 4),
              )
            : Text(
                sharedPreferences.getString('storeNameEn'),
                style: TextStyle(
                    color: SecondryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    wordSpacing: 4),
              ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: (MediaQuery.of(context).size.height -
                            appBar.preferredSize.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) /
                        3.5,
                    child: _image == null
                        ? Image.network(
                            'https://jettaex.net/storelogos/' +
                                sharedPreferences.getString('storeLogo'),
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: PrimaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          )
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                          )),
                Column(
                  children: [
                    Editbutton(
                      ico: Icons.edit,
                      radios: 15,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return alertq;
                            });
                      },
                    ),
                    Editbutton(
                      ico: Icons.save,
                      radios: 15,
                      onTap: () {
                        if (_image == null) {
                          print('no Image');
                        } else {
                          imageName = 'storeLogo' +
                              sharedPreferences.getString("storeID") +
                              '.' +
                              _image.path.split('.').last;

                          String imageCode =
                              base64Encode(_image.readAsBytesSync());

                          var storeId = {
                            "storeID": sharedPreferences.getString("storeID")
                          };

                          var id = storeId['storeID'];

                          updateLogo(id, imageName, imageCode);

                          sharedPreferences.setString('storeLogo', imageName);
                          setState(() {
                            imageCache.clear();
                          });
                        }
                      },
                    ),
                    Editbutton(
                      ico: Icons.delete,
                      radios: 15,
                      onTap: () async {
                        var storeId = sharedPreferences.getString("storeID");

                        await deleteLogo(storeId);
                        setState(() {
                          _getData();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) /
                6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //للمسافات الي بين اسم المحل و الايقونات والييتختهن
              children: [
                Container(
                  alignment: Alignment.center,
                  child: SmoothStarRating(
                      allowHalfRating: true,
                      onRated: (v) {
                        v = sharedPreferences.getDouble("storeRate");
                      },
                      starCount: 5,
                      rating: sharedPreferences.getDouble("storeRate"),
                      size: 30.0,
                      isReadOnly: true,
                      color: PrimaryColor,
                      borderColor: Color(0xffbf942e),
                      spacing: 0.0),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height -
                    appBar.preferredSize.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom) /
                2.5,
            child: GridView(
              children: [
                ProdcutsBoxs(context, getLang(context, "ProductButton"),
                    'ProscutDitalScreen'),
                ProdcutsBoxs(
                    context, getLang(context, "OrderButton"), 'OrderScreen'),
                ProdcutsBoxs(context, getLang(context, "ReviewButton"),
                    'RevewiesScreen'),
                ProdcutsBoxs(
                    context, getLang(context, "InfoButton"), 'InfoScreen'),
              ],
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton cbuildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Color(0xffedb54f),
      onPressed: null,
      child: Icon(
        Icons.home,
        color: SecondryColor,
      ),
    );
  }
}
