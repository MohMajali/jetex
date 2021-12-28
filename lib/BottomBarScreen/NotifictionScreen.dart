import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/notification.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NoteficationScreen extends StatefulWidget {
  const NoteficationScreen({Key key}) : super(key: key);

  @override
  _NoteficationScreenState createState() => _NoteficationScreenState();
}

class _NoteficationScreenState extends State<NoteficationScreen> {
  List<Notifications> note;
  SharedPreferences sharedPreferences;

  Future<List<Notifications>> _getNotes() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var id = sharedPreferences.getString("storeID");
    print(id);
    String url = Api.getNotes + id.toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Notifications> notesList =
          notificationsFromJson(response.body);
      return notesList;
    } else {
      // ignore: deprecated_member_use
      return List<Notifications>();
    }
  }

  @override
  void initState() {
    super.initState();
    _getNotes().then((notesList) {
      setState(() {
        note = notesList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text(getLang(context, "NotificationNav"),
            style: TextStyle(color: SecondryColor)),
      ),
      backgroundColor: SecondryColor,
      body: ListView.builder(
        itemBuilder: (_, i) {
          Notifications notification = note[i];
          if (note.isEmpty) {
            return Center();
          } else {
            return Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 3),
                    InkWell(
                      onTap: () {
                        // showAlertDialog(context, reviewApi.review);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
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
                                                  image: notification
                                                              .profilePhotoPath ==
                                                          null
                                                      ? NetworkImage(
                                                          'https://images-na.ssl-images-amazon.com/images/I/513CiKyzUWL.jpg')
                                                      : NetworkImage(Api
                                                              .userimg +
                                                          notification
                                                              .profilePhotoPath),
                                                  fit: BoxFit.fill)),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              notification.name,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: SecondryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              notification.subject,
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: SecondryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top: 5),
                                              width: 120,
                                              child: Text(
                                                'Notes' + notification.body,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 15,
                                                  color: SecondryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
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
        itemCount: null == note ? 0 : note.length,
      ),
    );
  }
}
