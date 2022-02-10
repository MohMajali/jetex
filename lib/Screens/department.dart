import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/departments.dart';
import 'package:http/http.dart' as http;
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Screens/types.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';

import '../main.dart';

class DepartmentScreen extends StatefulWidget {
  int id;
  DepartmentScreen({Key key, this.id}) : super(key: key);

  @override
  _DepartmentScreenState createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  List<Departments> departments;
  var lang = sharedPreferences.getString("lang");
  Future<List<Departments>> _getDep() async {
    String url = Api.getDepartments + widget.id.toString();
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Departments> depList = departmentsFromJson(response.body);
      return depList;
    } else {
      // ignore: deprecated_member_use
      return List<Departments>();
    }
  }

  @override
  void initState() {
    super.initState();
    _getDep().then((depList) {
      setState(() {
        departments = depList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text(getLang(context, 'Departments'),
            style: TextStyle(color: SecondryColor)),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TypesScreen()),
              );
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: ListView.builder(
        itemBuilder: (_, i) {
          Departments department = departments[i];
          if (departments.isEmpty) {
            return Center();
          } else {
            return Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lang == 'ar'
                        ? Text(
                            department.nameAr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SecondryColor),
                          )
                        : Text(
                            department.nameEn,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: SecondryColor),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, ii) {
                          return lang == 'ar'
                              ? Text(
                                  department.title[i].titleAr,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: SecondryColor),
                                )
                              : Text(
                                  department.title[i].titleEn,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: SecondryColor),
                                );
                        },
                        itemCount: null == department.title
                            ? 0
                            : department.title.length,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (_, iii) {
                        return Column(
                          children: [
                            lang == 'ar'
                                ? Text(
                                    department.title[i].points[i].nameAr,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                : Text(department.title[i].points[i].nameEn,
                                    style: TextStyle(
                                        color: SecondryColor, fontSize: 20)),
                            lang == 'ar'
                                ? Text(
                                    department.title[i].points[i].pointValueAr,
                                    style: TextStyle(
                                        color: SecondryColor, fontSize: 17))
                                : Text(
                                    department.title[i].points[i].pointValueEn,
                                    style: TextStyle(color: SecondryColor),
                                  )
                          ],
                        );
                      },
                      itemCount: null == department.title[i].points
                          ? 0
                          : department.title[i].points.length,
                    ),
                  ],
                ));
          }
        },
        itemCount: null == departments ? 0 : departments.length,
      ),
    );
  }
}
