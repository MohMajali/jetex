import 'package:flutter/material.dart';
import 'package:jettaexstores/Screens/productsignleEdit.dart';
import 'package:jettaexstores/classes/brand.dart';
import 'package:jettaexstores/classes/categories.dart';
import 'package:jettaexstores/classes/colors.dart';
import 'package:jettaexstores/classes/description.dart';
import 'package:jettaexstores/classes/feature.dart';
import 'package:jettaexstores/classes/images.dart';
import 'package:jettaexstores/classes/master.dart';
import 'package:jettaexstores/classes/model.dart';
import 'package:jettaexstores/classes/paid.dart';
import 'package:jettaexstores/classes/price.dart';
import 'package:jettaexstores/classes/productname.dart';
import 'package:jettaexstores/classes/warrenty.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';

class SingleComponent extends StatefulWidget {
  final String type;
  final int id;
  final String nameEn, nameAr;
  const SingleComponent({Key key, this.type, this.id, this.nameEn, this.nameAr})
      : super(key: key);

  @override
  _SingleComponentState createState() => _SingleComponentState();
}

class _SingleComponentState extends State<SingleComponent> {
  var lang = sharedPreferences.getString("lang");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignleEditPro(
                            id: widget.id,
                            nameEn: widget.nameEn,
                            nameAr: widget.nameAr,
                          )),
                );
              },
              icon: Icon(Icons.arrow_back)),
          title: lang == 'en'
              ? Text(widget.nameEn ?? "HI")
              : Text(widget.nameAr ?? "HI"),
          foregroundColor: SecondryColor,
          backgroundColor: PrimaryColor,
        ),
        body: type());
  }

  Widget type() {
    if (widget.type == "Master Image") {
      return MasterImage(
        id: widget.id,
      );
    } else if (widget.type == "Product Name") {
      return ProductName(
        id: widget.id,
      );
    } else if (widget.type == "Product Description") {
      return Description(
        id: widget.id,
      );
    } else if (widget.type == "Product Images") {
      return ProductImages(
        id: widget.id,
      );
    } else if (widget.type == "Product Colors") {
      return ProductColor(
        id: widget.id,
      );
    } else if (widget.type == "Price & Discount") {
      return ProcductPrice(
        id: widget.id,
      );
    } else if (widget.type == "Warrenty") {
      return Warrenty(
        id: widget.id,
      );
    } else if (widget.type == "Model Number") {
      return ProductModel(
        id: widget.id,
      );
    } else if (widget.type == "Brand") {
      return ProductBrand(
        id: widget.id,
      );
    } else if (widget.type == "Categories") {
      return Categories(
        id: widget.id,
      );
    } else if (widget.type == "Paid") {
      return PaidFeature(
        id: widget.id,
      );
    } else if (widget.type == "Features") {
      return Feature(
        id: widget.id,
      );
    }
  }
}
