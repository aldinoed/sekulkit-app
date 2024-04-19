import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:sekulkit/view/detail_page/detail_product.dart';
import 'package:sekulkit/view/insert_page/add_product.dart';
import 'package:sekulkit/view/update_page/update_product_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/login.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  List<Map<String, dynamic>> listProduct = [];
  List<Map<String, dynamic>> filteredListProduct = [];
  bool isLoaded = false;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String search = '';

  void _updateSearchController() {
    setState(() {
      search = searchController.text;
    });
  }

  _getProduct() async {
    listProduct = await client.from('product').select('*');
    setState(() {});
  }

  void _search(String query) {
    setState(() {
      if (query.isNotEmpty) {
        isSearching = true;
        filteredListProduct = listProduct.where((product) {
          return product['product_name']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              product['brand_name']
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              product['price'].toString().contains(query);
        }).toList();
        setState(() {});
      } else {
        isSearching = false;
        filteredListProduct = listProduct;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_updateSearchController);
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.addListener(_updateSearchController);
    _getProduct();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.05),
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () async {
                await client.auth.signOut(scope: SignOutScope.local);
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Success!',
                    message: 'Berhasil logout',

                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                    contentType: ContentType.success,
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return Login();
                }));
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const FaIcon(
                    FontAwesomeIcons.signOutAlt,
                    size: 20,
                  )),
            )
          ],
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: const Text(
            'Daftar Produk',
            // search,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 3,
            onPressed: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return const AddProduct();
              }));
              _getProduct();
              setState(() {
                listProduct;
              });
            },
            shape: const CircleBorder(),
            backgroundColor: Colors.deepPurpleAccent,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: isLoaded == false
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.deepPurpleAccent, size: 50),
              )
            : listProduct.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8)),
                              width: MediaQuery.of(context).size.width / 1.1,
                              height: 50,
                              child: TextField(
                                onChanged: (search) {
                                  _search(search);
                                },
                                controller: searchController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                      '  Cari nama produk, nama brand, harga',
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: search == ''
                              ? ListView.builder(
                                  itemCount: listProduct.length,
                                  itemBuilder: (context, index) {
                                    final product = listProduct[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          // setState(() {
                                          //   isLoaded = false;
                                          //   print(isLoaded);
                                          // });
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 80,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
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
                                                          BorderRadius.circular(
                                                              10)),
                                                  margin: const EdgeInsets.only(
                                                      left: 15, right: 13),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          product[
                                                              'product_image']),
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
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return UpdateProduct(
                                                          productId:
                                                              product['id'],
                                                          categoryId: product[
                                                              'category_id'],
                                                        );
                                                      }));
                                                      _getProduct();
                                                      setState(() {
                                                        listProduct;
                                                      });
                                                    },
                                                    icon: const FaIcon(
                                                      FontAwesomeIcons
                                                          .pencilAlt,
                                                      size: 20,
                                                    )),
                                                IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        Map<String, dynamic>
                                                            extension =
                                                            await client
                                                                .from('product')
                                                                .select(
                                                                    'extension')
                                                                .match({
                                                          'id': product['id']
                                                        }).single();
                                                        await client.storage
                                                            .from(
                                                                'product_assets')
                                                            .remove([
                                                          '${product['product_name']}.${extension['extension']}'
                                                        ]);
                                                        await client
                                                            .from('product')
                                                            .delete()
                                                            .match({
                                                          'id': product['id']
                                                        });

                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Success!',
                                                            message:
                                                                'Berhasil menghapus produk ${product['product_name']}',

                                                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                            contentType:
                                                                ContentType
                                                                    .success,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                        _getProduct();
                                                        setState(() {
                                                          listProduct;
                                                        });
                                                      } catch (err) {
                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Error!',
                                                            message: '$err',
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : ListView.builder(
                                  itemCount: filteredListProduct.length,
                                  itemBuilder: (context, index) {
                                    final product = filteredListProduct[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          // setState(() {
                                          //   isLoaded = false;
                                          //   print(isLoaded);
                                          // });
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        height: 80,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
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
                                                          BorderRadius.circular(
                                                              10)),
                                                  margin: const EdgeInsets.only(
                                                      left: 15, right: 13),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          product[
                                                              'product_image']),
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
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    onPressed: () async {
                                                      await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                        return UpdateProduct(
                                                          productId:
                                                              product['id'],
                                                          categoryId: product[
                                                              'category_id'],
                                                        );
                                                      }));
                                                      _getProduct();
                                                      setState(() {
                                                        listProduct;
                                                      });
                                                    },
                                                    icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .pencilAlt,
                                                      size: 20,
                                                    )),
                                                IconButton(
                                                    onPressed: () async {
                                                      try {
                                                        Map<String, dynamic>
                                                            extension =
                                                            await client
                                                                .from('product')
                                                                .select(
                                                                    'extension')
                                                                .match({
                                                          'id': product['id']
                                                        }).single();
                                                        await client.storage
                                                            .from(
                                                                'product_assets')
                                                            .remove([
                                                          '${product['product_name']}.${extension['extension']}'
                                                        ]);
                                                        await client
                                                            .from('product')
                                                            .delete()
                                                            .match({
                                                          'id': product['id']
                                                        });

                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Success!',
                                                            message:
                                                                'Berhasil menghapus produk ${product['product_name']}',

                                                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                            contentType:
                                                                ContentType
                                                                    .success,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                        _getProduct();
                                                        setState(() {
                                                          listProduct;
                                                        });
                                                      } catch (err) {
                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Error!',
                                                            message: '$err',
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                      }
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                        ),
                      ],
                    ),
                  )
                : dataNotFound());
  }
}
