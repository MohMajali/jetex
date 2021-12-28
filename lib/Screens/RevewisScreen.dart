import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/reviewapi.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Widget/NavBar.dart';
import 'package:jettaexstores/Widget/review.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/homepage.dart';
import 'package:jettaexstores/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class RevewiesScreen extends StatefulWidget {
  @override
  _RevewiesScreenState createState() => _RevewiesScreenState();
}

class _RevewiesScreenState extends State<RevewiesScreen> {
  List<ReviewApi> review = [];
  dynamic storeData;

  Future<List<ReviewApi>> _getReview() async {
    var getStoreID = {"storeID": sharedPreferences.getString("storeID")};

    String url = Api.getReviews + getStoreID['storeID'].toString();

    var response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final List<ReviewApi> reviewList = reviewApiFromJson(response.body);

      return reviewList;
    } else {
      // ignore: deprecated_member_use
      return List<ReviewApi>();
    }
  }

  void setdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      storeData = jsonDecode(sharedPreferences.getString("userdata"));
    });
  }

  void showAlertDialog(
    BuildContext context,
    String review,
  ) {
    final AlertDialog alert = AlertDialog(
      backgroundColor: SecondryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: revied(
        review,
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return alert;
        });
  }

  @override
  void initState() {
    super.initState();

    _getReview().then((reviewList) {
      setState(() {
        review = reviewList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text(getLang(context, "Reviewbar"),
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
      backgroundColor: SecondryColor,
      body: ListView.builder(
          itemBuilder: (context, int index) {
            ReviewApi reviewApi = review[index];
            if (review.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator(
                        backgroundColor: SecondryColor,
                        valueColor: AlwaysStoppedAnimation<Color>(PrimaryColor),
                        strokeWidth: 5,
                      ),
                    ),
                    Text(
                      getLang(context, "Indicator"),
                      style: TextStyle(
                          color: PrimaryColor, fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              );
            } else {
              return Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 3),
                      InkWell(
                        onTap: () {
                          showAlertDialog(context, reviewApi.review);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: PrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .1,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .21,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .circular(8),
                                                image: DecorationImage(
                                                    image: reviewApi
                                                                .profilePhotoPath ==
                                                            null
                                                        ? NetworkImage(
                                                            'https://images-na.ssl-images-amazon.com/images/I/513CiKyzUWL.jpg')
                                                        : NetworkImage(Api
                                                                .userimg +
                                                            reviewApi
                                                                .profilePhotoPath),
                                                    fit: BoxFit.fill)),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                reviewApi.name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: SecondryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  SmoothStarRating(
                                                      allowHalfRating: true,
                                                      onRated: (v) {},
                                                      starCount: 5,
                                                      rating: double.parse(
                                                          reviewApi.rating
                                                              .toString()),
                                                      size: 20.0,
                                                      isReadOnly: true,
                                                      color: Colors.yellow,
                                                      borderColor:
                                                          Colors.yellow,
                                                      spacing: 0.0),
                                                ],
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                                width: 120,
                                                child: Text(
                                                  reviewApi.review,
                                                  style: TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontSize: 15,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Center(
                                        child: IconButton(
                                          icon: const Icon(Icons.report),
                                          color: SecondryColor,
                                          iconSize: 30,
                                          onPressed: () {},
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                ],
              );
            }
          },
          itemCount: null == review ? 0 : review.length),
    );
  }
}
