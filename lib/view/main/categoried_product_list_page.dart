import 'package:flutter/material.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:sekulkit/view/insert_page/add_product.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class CategoriedProduct extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoriedProduct(
      {Key? key, required this.categoryId, required this.categoryName})
      : super(key: key);

  @override
  State<CategoriedProduct> createState() => _CategoriedProduct();
}

class _CategoriedProduct extends State<CategoriedProduct> {
  List<Map<String, dynamic>> listProduct = [];

  _getProduct() async {
    listProduct = await client
        .from('product')
        .select('*')
        .match({'category_id': widget.categoryId});
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent[100],
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            widget.categoryName,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 3,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const AddProduct();
              }));
            },
            shape: const CircleBorder(),
            backgroundColor: Colors.deepPurpleAccent,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: listProduct.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 15),
                child: ListView.builder(
                    itemCount: listProduct.length,
                    itemBuilder: (context, index) {
                      final product = listProduct[index];
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 20, left: 15, right: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        height: 80,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 13),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image(
                                      image: NetworkImage(
                                          product['product_image']),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['product_name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                        'Tersedia: ${product['quantity'].toString()}'),
                                    Text(
                                        'Harga: Rp. ${product['price'].toString()},-')
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.add)),
                                IconButton(
                                    onPressed: () async {
                                      print("INI ID PRODUCT" + product['id']);
                                      await client
                                          .from('product')
                                          .delete()
                                          .match({'id': product['id']});
                                      await client.storage
                                          .from('product_assets')
                                          .remove([
                                        'product_assets/${product['product_name']}'
                                      ]);
                                      _getProduct();
                                      setState(() {
                                        listProduct;
                                      });
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            )
                          ],
                        ),
                      );
                    }),
              )
            : dataNotFound());
  }
}
