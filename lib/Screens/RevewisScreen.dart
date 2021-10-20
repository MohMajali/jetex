import 'dart:convert';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/reviewapi.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Widget/review.dart';
import 'package:jettaexstores/config/Constant.dart';
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
    print(getStoreID['storeID'].toString());

    String url =
        'http://45.76.132.167/api/authentication/reviewsapi.php?stores_id=' +
            getStoreID['storeID'].toString();

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
    String name,
    String review,
  ) {
    final AlertDialog alert = AlertDialog(
      backgroundColor: SecondryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: revied(
        name,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 3),
                      InkWell(
                        onTap: () {
                          showAlertDialog(
                              context, reviewApi.name, reviewApi.review);
                        },
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          color: PrimaryColor,
                          child: Padding(
                            padding: const EdgeInsets.all(1.0),
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
                                          CircleAvatar(
                                            backgroundColor: SecondryColor,
                                            radius: 35,
                                            backgroundImage: NetworkImage(
                                                'https://www.seriouseats.com/thmb/XhfxmcTdvTRcJtPpqwz5G0s9aBs=/960x0/filters:no_upscale():max_bytes(150000):strip_icc():format(webp)/__opt__aboutcom__coeus__resources__content_migration__serious_eats__sweets.seriouseats.com__images__2015__04__20150428-best-apples-for-pie-reupload-kenji-1-4d0a4c15136e4819814b2d205d2dc08f.jpg'),
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
                                                  fontSize: 18,
                                                  color: SecondryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                // textAlign: TextAlign.left,
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
                                    // SizedBox(
                                    //   width: MediaQuery.of(context).size.width *
                                    //       .27,
                                    // ),

                                    Container(
                                      child: Center(
                                        child: IconButton(
                                          icon: const Icon(Icons.report),
                                          color: SecondryColor,
                                          iconSize: 30,
                                          onPressed: () => print('object'),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SmoothStarRating(
                                        allowHalfRating: true,
                                        onRated: (v) {
                                          // v = sharedPreferences.getDouble("storeRate");
                                        },
                                        starCount: 5,
                                        rating: double.parse(
                                            reviewApi.rating.toString()),
                                        size: 30.0,
                                        isReadOnly: true,
                                        color: Colors.yellow,
                                        borderColor: Colors.yellow,
                                        spacing: 0.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
          itemCount: null == review ? 0 : review.length),
    );
  }
}
