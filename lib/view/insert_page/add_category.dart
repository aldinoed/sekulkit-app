// import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sekulkit/utils/constant.dart';
import 'dart:math' as math;

import 'package:sekulkit/widgets/textfield.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryNameController = TextEditingController();

  // List<Wid>
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Tambah Kategori',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(20)),
              height: MediaQuery.of(context).size.height / 2.5,
              padding: EdgeInsets.all(30),
              margin: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: textField(
                          'Nama Kategori', categoryNameController, false)),
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    elevation: 3,
                    child: Container(
                        // width: 150,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.deepPurple),
                        child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.transparent,
                          child: InkWell(
                            splashColor: Colors.deepPurple[200],
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              List<Map<String, dynamic>> dataExisted =
                                  await client
                                      .from('category')
                                      .select('category_name')
                                      .eq('category_name',
                                          categoryNameController.text);
                              if (dataExisted.isNotEmpty) {
                                // AwesomeDialog(
                                //         context: context,
                                //         dialogType: DialogType.error,
                                //         title: 'Failed',
                                //         desc: 'Gagal Menambahkan Kategori',
                                //         animType: AnimType.topSlide,
                                //         btnCancelOnPress: () {},
                                //         btnCancelText: 'Tutup')
                                //     .show();
                              } else {
                                final res = await client
                                    .from('category')
                                    .insert({
                                  'category_name': categoryNameController.text
                                });
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Success!',
                                    message:
                                        'Berhasil menambahkan kategori ${categoryNameController.text}',

                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                    contentType: ContentType.success,
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                                Navigator.pop(context);
                                // AwesomeDialog(
                                //         context: context,
                                //         dialogType: DialogType.success,
                                //         title: 'Success',
                                //         desc: 'Berhasil Menambahkan Kategori',
                                //         btnOkOnPress: () {},
                                //         btnOkText: 'Tutup')
                                //     .show();
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ClipRadian extends CustomClipper<Path> {
  double degreeToRadian(num degree) => degree * (math.pi / 180);

  @override
  Path getClip(Size size) {
    double width = size.width;
    double height = size.height / 2.5;

    Path path = Path();

    path.arcTo(Rect.fromLTWH(0, 0, width, height), degreeToRadian(0),
        degreeToRadian(180), true);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
