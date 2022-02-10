import 'package:flutter/material.dart';
import 'package:jettaexstores/BottomBarScreen/SettingScreen.dart';
import 'package:jettaexstores/Module/types.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Screens/department.dart';
import 'package:jettaexstores/Widget/NavBar.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:jettaexstores/main.dart';

class TypesScreen extends StatefulWidget {
  const TypesScreen({Key key}) : super(key: key);

  @override
  _TypesScreenState createState() => _TypesScreenState();
}

class _TypesScreenState extends State<TypesScreen> {
  List<Types> types;
  var lang = sharedPreferences.getString("lang");

  Future<List<Types>> _getTypes() async {
    String url = Api.getTypes;
    var response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<Types> typeList = typesFromJson(response.body);
      return typeList;
    } else {
      // ignore: deprecated_member_use
      return List<Types>();
    }
  }

  @override
  void initState() {
    super.initState();
    _getTypes().then((typeList) {
      setState(() {
        types = typeList;
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
        title: Text(getLang(context, 'Terms&Conditions'),
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: SecondryColor,
        child: ListView.builder(
          itemBuilder: (_, index) {
            Types type = types[index];
            if (types.isEmpty) {
              return Center();
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            color: PrimaryColor,
                            borderRadius: BorderRadiusDirectional.circular(8)),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          leading: Container(
                            height: MediaQuery.of(context).size.height * 2,
                            width: MediaQuery.of(context).size.width * .21,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadiusDirectional.circular(8),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              lang == 'ar'
                                  ? Text(
                                      type.nameAr,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: SecondryColor),
                                    )
                                  : Text(
                                      type.nameEn,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: SecondryColor),
                                    ),
                              const SizedBox(height: 4),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DepartmentScreen(
                                        id: type.id,
                                      )),
                            );
                          },
                        )),
                  ],
                ),
              );
            }
          },
          itemCount: null == types ? 0 : types.length,
        ),
      ),
    );
  }
}
