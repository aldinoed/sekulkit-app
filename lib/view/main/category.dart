import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sekulkit/view/main/categoried_product_list_page.dart';
import 'package:sekulkit/view/update_page/update_category_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/constant.dart';
import '../auth/login.dart';
import '../insert_page/add_category.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Map<String, dynamic>> listCategory = [];
  bool isLoaded = false;

  // static const IconData pencil = IconData(0xf37e, fontFamily: FontFa, fontPackage: iconFontPackage);

  _getCategory() async {
    listCategory = await client.from('category').select('*');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory();
    Future.delayed(Duration(seconds: 1), () {
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
                margin: EdgeInsets.only(right: 20),
                child: FaIcon(
                  FontAwesomeIcons.signOutAlt,
                  size: 20,
                )),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Daftar Kategori',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 3,
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const AddCategory();
            }));
            _getCategory();
            setState(() {
              listCategory;
            });
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: isLoaded == true
          ? listCategory.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    Future.delayed(Duration(seconds: 1), () {
                      setState(() {
                        _getCategory();
                      });
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ListView.builder(
                        itemCount: listCategory.length,
                        itemBuilder: (context, index) {
                          final category = listCategory[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CategoriedProduct(
                                  categoryId: category['id'],
                                  categoryName: category['category_name'],
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
                              width: MediaQuery.of(context).size.width / 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      category['category_name'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            await Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return UpdateCategory(
                                                categoryId: category['id'],
                                              );
                                            }));
                                            _getCategory();
                                            setState(() {
                                              listCategory;
                                            });
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.pencilAlt,
                                            size: 20,
                                          )),
                                      IconButton(
                                          onPressed: () async {
                                            try {
                                              await client
                                                  .from('category')
                                                  .delete()
                                                  .match(
                                                      {'id': category['id']});
                                              final snackBar = SnackBar(
                                                elevation: 0,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: AwesomeSnackbarContent(
                                                  title: 'Success!',
                                                  message:
                                                      'Berhasil menghapus kategori ${category['category_name']}',

                                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                  contentType:
                                                      ContentType.success,
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                              _getCategory();
                                              setState(() {
                                                listCategory;
                                              });
                                            } catch (err) {
                                              final snackBar = SnackBar(
                                                elevation: 0,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor:
                                                    Colors.transparent,
                                                content: AwesomeSnackbarContent(
                                                  title: 'Error!',
                                                  message:
                                                      'Ada produk yang terkait dengan kategori ${category['category_name']}',
                                                  contentType:
                                                      ContentType.failure,
                                                ),
                                              );
                                              ScaffoldMessenger.of(context)
                                                ..hideCurrentSnackBar()
                                                ..showSnackBar(snackBar);
                                            }
                                          },
                                          icon: const Icon(Icons.delete))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                )
              : dataNotFound()
          : Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.deepPurpleAccent, size: 50),
            ),
    );
  }
}
