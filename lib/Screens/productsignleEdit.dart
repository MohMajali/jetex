import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Screens/ProdcutDitalScreen.dart';
import 'package:jettaexstores/Screens/components.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';
import 'package:http/http.dart' as http;

class SignleEditPro extends StatefulWidget {
  final String nameEn, nameAr;
  final int id;
  const SignleEditPro({Key key, this.nameEn, this.nameAr, this.id})
      : super(key: key);

  @override
  _SignleEditProState createState() => _SignleEditProState();
}

class _SignleEditProState extends State<SignleEditPro> {
  var lang = sharedPreferences.getString("lang");
  Key master = GlobalKey();
  Key name = GlobalKey();
  Key description = GlobalKey();
  Key images = GlobalKey();
  Key colors = GlobalKey();
  Key price = GlobalKey();
  Key warrent = GlobalKey();
  Key model = GlobalKey();
  Key brand = GlobalKey();
  Key category = GlobalKey();
  Key paid = GlobalKey();
  Key feature = GlobalKey();

  List<ProductsApi> product = [];

  Future<List<ProductsApi>> _getData(int id) async {
    try {
      String url = Api.productViewEdit + id.toString();

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<ProductsApi> productsList =
            productsApiFromJson(response.body);
        return productsList;
      } else {
        // ignore: deprecated_member_use
        return List<ProductsApi>();
      }
    } catch (x) {
      print(x);
    }
  }

  @override
  void initState() {
    super.initState();
    _getData(widget.id).then((productsList) {
      setState(() {
        product = productsList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProscutDitalScreen()),
                );
              },
              icon: Icon(Icons.arrow_back)),
          foregroundColor: SecondryColor,
          backgroundColor: PrimaryColor,
          title: lang == 'ar'
              ? product.length == 0
                  ? Text("",
                      style: TextStyle(
                        color: SecondryColor,
                      ))
                  : Text(product[0].nameAr)
              : product.length == 0
                  ? Text("",
                      style: TextStyle(
                        color: SecondryColor,
                      ))
                  : Text(product[0].nameEn,
                      style: TextStyle(
                        color: SecondryColor,
                      ))),
      body: Container(
        color: PrimaryColor,
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "master") ?? "HI",
              context,
              SingleComponent(
                type: "Master Image",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              master,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "ProductName") ?? "HI",
              context,
              SingleComponent(
                type: "Product Name",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              name,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "ProductDescription") ?? "HI",
              context,
              SingleComponent(
                type: "Product Description",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              description,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "ProductImages") ?? "HI",
              context,
              SingleComponent(
                type: "Product Images",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              images,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "ProductColors") ?? "HI",
              context,
              SingleComponent(
                type: "Product Colors",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              colors,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "Price&Discount") ?? "HI",
              context,
              SingleComponent(
                type: "Price & Discount",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              price,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "Warrenty") ?? "HI",
              context,
              SingleComponent(
                type: "Warrenty",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              warrent,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "ModelNumber") ?? "HI",
              context,
              SingleComponent(
                type: "Model Number",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              model,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "Brand") ?? "HI",
              context,
              SingleComponent(
                type: "Brand",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              brand,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "Categories") ?? "HI",
              context,
              SingleComponent(
                type: "Categories",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              category,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "PaidFeatures") ?? "HI",
              context,
              SingleComponent(
                type: "Paid",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              paid,
            ),
            SizedBox(
              height: 10,
            ),
            editSingle(
              getLang(context, "Features") ?? "HI",
              context,
              SingleComponent(
                type: "Features",
                id: widget.id,
                nameEn: widget.nameEn,
                nameAr: widget.nameAr,
              ),
              feature,
            ),
          ],
        ),
      ),
    );
  }
}
