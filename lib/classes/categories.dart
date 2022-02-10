import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/Sub2Category.dart';
import 'package:jettaexstores/Module/Sub3Category.dart';
import 'package:jettaexstores/Module/Subcategory.dart';
import 'package:jettaexstores/Module/categoryapi.dart';
import 'package:jettaexstores/Module/maincar.dart';
import 'package:jettaexstores/Module/sub2cat.dart';
import 'package:jettaexstores/Module/sub3cat.dart';
import 'package:jettaexstores/Module/subcat.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';
import 'package:http/http.dart' as http;

class Categories extends StatefulWidget {
  final int id;
  const Categories({Key key, this.id}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  String _cat;
  String _subCat;
  String _sub2Cat;
  String _sub3Cat;
  List<MainCategory> mainCat = [];
  List<MainCat> mainCateg = [];
  List<SubCategory> subCat = [];
  List<SubCat> subCateg = [];
  List<Sub2Category> sub2Cat = [];
  List<Sub2Cat> sub2Categ = [];
  List<Sub3Category> sub3Cat = [];
  List<Sub3Cat> sub3Categ = [];
  var lang = sharedPreferences.getString("lang");

  Future _getMainCategories() async {
    try {
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
    } catch (x) {
      print(x);
    }
  }

  Future<List<MainCat>> _getMaincat(var proid) async {
    try {
      String url = Api.getMainCat + widget.id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<MainCat> categoriesList = mainCatFromJson(response.body);

        return categoriesList;
      } else {
        // ignore: deprecated_member_use
        return List<MainCat>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future insertCategory(int id, var newCat) async {
    try {
      String url = Api.insertMainCategory;
      final response = await http.post(Uri.parse(url),
          body: {"id": id.toString(), "newCatID": newCat.toString()});

      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "mainCat"),
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

  Future<List<SubCategory>> _getSubCategory(var Cat_id) async {
    try {
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
    } catch (x) {
      print(x);
    }
  }

  Future<List<SubCat>> _getSubcat(var proid) async {
    try {
      String url = Api.getSubCat + widget.id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<SubCat> subCategoriesList = subCatFromJson(response.body);

        return subCategoriesList;
      } else {
        // ignore: deprecated_member_use
        return List<SubCat>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future<List<Sub2Category>> _getSub2Category(var subCat_id) async {
    try {
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
    } catch (x) {
      print(x);
    }
  }

  Future<List<Sub3Category>> _getSub3Category(var sub2Cat_id) async {
    try {
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
    } catch (x) {
      print(x);
    }
  }

  Future insertSub1(int id, var newSub1) async {
    try {
      String url = Api.insertSub1;
      final response = await http.post(Uri.parse(url),
          body: {"id": id.toString(), "newSub1CatID": newSub1.toString()});

      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "sub1"),
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

  Future<List<Sub2Cat>> _getSub2cat(var proid) async {
    try {
      String url = Api.getSub2Cat + widget.id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<Sub2Cat> sub2CategoriesList = sub2CatFromJson(response.body);

        return sub2CategoriesList;
      } else {
        // ignore: deprecated_member_use
        return List<Sub2Cat>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future insertSub2(int id, var newSub2) async {
    try {
      String url = Api.insertsub2Category;
      final response = await http.post(Uri.parse(url),
          body: {"id": id.toString(), "newSub2CatID": newSub2.toString()});

      var json = jsonDecode(response.body);

      print(json['error']);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "sub2"),
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

  Future<List<Sub3Cat>> _getSub3cat(var proid) async {
    try {
      String url = Api.getSub3Cat + widget.id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<Sub3Cat> sub3CategoriesList = sub3CatFromJson(response.body);

        return sub3CategoriesList;
      } else {
        // ignore: deprecated_member_use
        return List<Sub3Cat>();
      }
    } catch (x) {
      print(x);
    }
  }

  Future insertSub3(int id, var newSub3) async {
    try {
      String url = Api.insertsub3Category;
      final response = await http.post(Uri.parse(url),
          body: {"id": id.toString(), "newSub3CatID": newSub3.toString()});

      var json = jsonDecode(response.body);

      if (!json['error']) {
        final snackBar = SnackBar(
          content: Text(
            getLang(context, "sub3"),
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

  @override
  void initState() {
    super.initState();
    _getMainCategories().then((categoriesList) {
      setState(() {
        mainCat = categoriesList;
      });
    });

    _getMaincat(widget.id).then((categoriesList) {
      setState(() {
        mainCateg = categoriesList;
      });
    });

    _getSubcat(widget.id).then((subCategoriesList) {
      setState(() {
        subCateg = subCategoriesList;
        print(subCateg.length);
      });
    });

    _getSub2cat(widget.id).then((sub2CategoriesList) {
      setState(() {
        sub2Categ = sub2CategoriesList;
      });
    });

    _getSub3cat(widget).then((sub3CategoriesList) {
      setState(() {
        sub3Categ = sub3CategoriesList;
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
          SizedBox(
            height: 10,
          ),
          subCategory(),
          SizedBox(
            height: 10,
          ),
          sub2Category(),
          SizedBox(
            height: 10,
          ),
          sub3Category()
        ],
      ),
    );
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
                    hint: mainCateg.length == 0
                        ? Text(
                            getLang(context, "MainCategory"),
                            style: TextStyle(color: PrimaryColor),
                          )
                        : lang == 'ar'
                            ? Text(
                                mainCateg[0].nameAr,
                                style: TextStyle(color: PrimaryColor),
                              )
                            : Text(
                                mainCateg[0].nameEn,
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
                            // loadSub = true;
                          });
                        });
                        insertCategory(widget.id, _cat);
                        print(mainCateg[0].nameEn);
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
                    hint: subCateg.length == 0
                        ? Text(
                            getLang(context, "SubCategories"),
                            style: TextStyle(color: PrimaryColor),
                          )
                        : lang == 'ar'
                            ? Text(
                                subCateg[0].nameAr,
                                style: TextStyle(color: PrimaryColor),
                              )
                            : Text(
                                subCateg[0].nameEn,
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
                            // loadSub = true;
                          });
                        });
                        // print(_subCat);
                        insertSub1(widget.id, _subCat);
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
        ));
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
                    hint: sub2Categ.length == 0
                        ? Text(
                            getLang(context, "SubCategories2"),
                            style: TextStyle(color: PrimaryColor),
                          )
                        : lang == 'ar'
                            ? Text(
                                sub2Categ[0].nameAr,
                                style: TextStyle(color: PrimaryColor),
                              )
                            : Text(
                                sub2Categ[0].nameEn,
                                style: TextStyle(color: PrimaryColor),
                              ),
                    onChanged: (String newValue3) {
                      setState(() {
                        _sub2Cat = newValue3;
                        _sub3Cat = null;
                        _getSub3Category(_sub2Cat).then((sub3CategoriesList) {
                          setState(() {
                            sub3Cat = sub3CategoriesList;
                            // loadSub = true;
                          });
                        });
                        insertSub2(widget.id, _sub2Cat);
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
        ));
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
                    hint: sub3Categ.length == 0
                        ? Text(
                            getLang(context, "SubCategories3"),
                            style: TextStyle(color: PrimaryColor),
                          )
                        : lang == 'ar'
                            ? Text(
                                sub3Categ[0].nameAr,
                                style: TextStyle(color: PrimaryColor),
                              )
                            : Text(
                                sub3Categ[0].nameEn,
                                style: TextStyle(color: PrimaryColor),
                              ),
                    onChanged: (String newValue4) {
                      setState(() {
                        _sub3Cat = newValue4;
                        insertSub3(widget.id, _sub3Cat);
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
        ));
  }
}
