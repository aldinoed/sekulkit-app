import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:sekulkit/view/insert_page/add_product.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../detail_page/detail_product.dart';
import '../update_page/update_product_page.dart';

class OutOfStockProduct extends StatefulWidget {
  const OutOfStockProduct({super.key});

  @override
  State<OutOfStockProduct> createState() => _OutOfStockProductState();
}

class _OutOfStockProductState extends State<OutOfStockProduct> {
  List<Map<String, dynamic>> listProduct = [];
  bool isLoaded = false;

  _getProduct() async {
    listProduct =
        await client.from('product').select('*').match({'quantity': 0});
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProduct();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.9),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Stok Habis',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: isLoaded == true
            ? listProduct.isNotEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: ListView.builder(
                        itemCount: listProduct.length,
                        itemBuilder: (context, index) {
                          final product = listProduct[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailProduct(
                                  productId: product['id'],
                                  categoryId: product['category_id'],
                                );
                              }));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 20, left: 15, right: 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 80,
                              width: MediaQuery.of(context).size.width / 1.2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: const EdgeInsets.only(
                                            left: 15, right: 13),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image(
                                            image: NetworkImage(
                                                product['product_image']),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UpdateProduct(
                                                productId: product['id'],
                                                categoryId:
                                                    product['category_id'],
                                              );
                                            }));
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.pencilAlt,
                                            size: 20,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            Map<String, dynamic> extension =
                                                await client
                                                    .from('product')
                                                    .select('extension')
                                                    .match({
                                              'id': product['id']
                                            }).single();
                                            await client.storage
                                                .from('product_assets')
                                                .remove([
                                              '${product['product_name']}.${extension['extension']}'
                                            ]);
                                            await client
                                                .from('product')
                                                .delete()
                                                .match({'id': product['id']});
                                            final snackBar = SnackBar(
                                              elevation: 0,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              backgroundColor:
                                                  Colors.transparent,
                                              content: AwesomeSnackbarContent(
                                                title: 'Success!',
                                                message:
                                                    'Berhasil menghapus produk ${product['product_name']}',

                                                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                contentType:
                                                    ContentType.success,
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(snackBar);

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
                            ),
                          );
                        }),
                  )
                : dataNotFound()
            : Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.deepPurpleAccent, size: 50),
              ));
  }
}
