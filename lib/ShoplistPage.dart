import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopping_box/Prices.dart';
import 'package:shopping_box/Products.dart';

class ShoplistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateClass();
  }
}

class StateClass extends State<ShoplistPage> {
  bool deger = false;
  int urunMiktari = 1;
  var key = GlobalKey<FormState>();
  String urunAdi;
  List productInfo;
  List productPriceInfo;
  List<Product> allProducts;
  int fiyat = 0;

  @override
  void initState() {
    super.initState();
    allProducts = [];
  }

  @override
  Widget build(BuildContext context) {
    productInfo = verileriCek();
    productPriceInfo=fiyatiCek();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Make Your List"),
        backgroundColor: Colors.cyan.shade300,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade200,
        onPressed: () {
          if (key.currentState.validate()) {
            key.currentState.save();
          }

        },
        child: Icon(Icons.add),
      ),
      body:
      Container(

          child: Form(
              key: key,
              // ignore: deprecated_member_use
              autovalidate: deger,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextFormField(
                    validator: (yazilanUrun) {
                      if (yazilanUrun.contains(new RegExp(r'[0-9]'))) {
                        return "ürün adı rakam ve sayı içeremez";
                      }
                    },
                    onSaved: (alinanUrun) {
                      urunAdi = alinanUrun;
                      setState(() {
                        allProducts.add(new Product(urunAdi.toString(), urunMiktari.toString()));
                      });
                      setState(() {
                      //  fiyat = 0;
                        fiyatiHesapla();
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.cyan.shade200)),
                      hintText: "lütfen ürün adı giriniz",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 280, 8),
                  child: DropdownButton(
                      hint: Text("miktar"),
                      value: urunMiktari,
                      items: dropDownElemanlari(),
                      onChanged: (secilenMiktar) {
                        setState(() {
                          urunMiktari = secilenMiktar;
                        });
                      }),
                ),
                sonuc(),
                Container(
                  width: double.infinity,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.89,
                  child:ListView.builder(
                      itemCount: allProducts.length,
                      itemBuilder: (context,int index) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.shopping_cart_outlined),
                            title: Text("ürün adi : "+ allProducts[index].pName  +  "adet : "  +  allProducts[index].Pcost ),
                          ),
                        );
                  }),

                )

              ]))),
    );
  }

  List<DropdownMenuItem> dropDownElemanlari() {
    List<DropdownMenuItem> menuItems = [];
    for (int i = 1; i < 11; i++) {
      DropdownMenuItem dropdownMenuItem =
      DropdownMenuItem(child: Text("$i"), value: i);
      menuItems.add(dropdownMenuItem);
    }
    return menuItems;
  }

  Widget sonuc() {
    return Center(
      child: Container(
        width: double.infinity,
        height: MediaQuery
            .of(context)
            .size
            .height / 8,
        color: Colors.pink.shade200,
        child: Center(
            child: Text(
              "toplam tutar : $fiyat",
              style: TextStyle(fontSize: 30, color: Colors.white),
            )),
      ),
    );
  }

  List verileriCek() {
    List<String> productInfos = [];
    Prices pricess = new Prices();
    for (int i = 0; i < (pricess.names.length); i++) {
      productInfos.add(pricess.names[i]);
    }
    return productInfos;
  }


  int fiyatiHesapla() {
    for (int i = 0; i < productPriceInfo.length; i++) {
      if (urunAdi == productInfo[i]) {
        fiyat += int.parse(productPriceInfo[i].toString()) * urunMiktari;
      }
    }
    print(fiyat);
    return fiyat;
  }

  Widget eklenenUrunleriListele() {
  }

  List fiyatiCek() {
    List productInfos2 = [];
    Prices prices = new Prices();
    for (int i = 0; i < (prices.names.length); i++) {
      productInfos2.add(prices.prices[i]);

    }
    return productInfos2;



  }
}
