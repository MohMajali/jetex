import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jettaexstores/Module/productjson.dart';
import 'package:jettaexstores/Screens/ProdcutDitalScreen.dart';
import 'package:jettaexstores/config/Configers.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';
import 'package:jettaexstores/widget.dart';

class AddProdcut extends StatefulWidget {
  @override
  _AddProdcutState createState() => _AddProdcutState();
}

class _AddProdcutState extends State<AddProdcut> {
  TextEditingController nameen = TextEditingController();
  TextEditingController namear = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController storeid = TextEditingController();
  List<ProductsApi> products = [];

  Future addProduct(
      var storeID, String nameEnglish, String nameArabic, var price) async {
    var url = Api.addProduct;
    final response = await http.post(Uri.parse(url), body: {
      "name_en": nameEnglish,
      "name_ar": nameArabic,
      "store_id": storeID,
      "price": price
    });

    print(response.body);
  }

  Future<List<ProductsApi>> _getData() async {
    var getStoreID = {"storeID": sharedPreferences.getString("storeID")};

    String url = Api.getProdcts + getStoreID['storeID'].toString();

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<ProductsApi> productsList = productsApiFromJson(response.body);
      return productsList;
    } else {
      // ignore: deprecated_member_use
      return List<ProductsApi>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SecondryColor,
      appBar: new AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text('Add Product', style: TextStyle(color: SecondryColor)),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.37,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      cont(nameen, Icons.edit, 'Product Name In English',
                          TextInputType.text),
                      cont(namear, Icons.title, 'اسم المنتج',
                          TextInputType.text),
                      cont(price, Icons.money_off, 'Product Price',
                          TextInputType.phone),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  var id = sharedPreferences.getString('storeID');
                  String eName = nameen.text;
                  String aName = namear.text;
                  String productPrice = price.text;

                  await addProduct(id, eName, aName, productPrice);
                  setState(() {
                    // _getData().then((productsList) {
                    //   setState(() {
                    //     products = productsList;
                    //   });
                    // });
                  });
                },
                child: Container(
                  //padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 80, vertical: 1),
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

  Container cont(TextEditingController te, IconData icon, String title,
      TextInputType tybe) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
      decoration: BoxDecoration(
          color: PrimaryColor, borderRadius: BorderRadius.circular(5)),
      child: ListTile(
        leading: Icon(
          icon,
          color: SecondryColor,
        ),
        title: TextFormField(
          controller: te,
          style: TextStyle(color: SecondryColor),
          // controller: ,
          keyboardType: tybe,
          decoration: InputDecoration(
            labelText: title,
            labelStyle: TextStyle(color: SecondryColor),
          ),
        ),
      ),
    );
  }
}
