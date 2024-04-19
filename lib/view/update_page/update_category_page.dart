import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:sekulkit/widgets/textfield.dart';

class UpdateCategory extends StatefulWidget {
  final String categoryId;

  const UpdateCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  TextEditingController categoryNameController = TextEditingController();
  Map<String, dynamic>? categoryData;

  _getCategory(String id) async {
    categoryData =
        await client.from('category').select('*').match({'id': id}).single();
    categoryNameController.text = categoryData?['category_name'];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Update Kategori',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: categoryData?['category_name'] == null
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.deepPurpleAccent, size: 50),
            )
          : Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    height: MediaQuery.of(context).size.height / 2.5,
                    padding: const EdgeInsets.all(30),
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child: textField('Nama Kategori',
                                categoryNameController, false)),
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
                                    try {
                                      dynamic res = await client
                                          .from('category')
                                          .update({
                                        'category_name':
                                            categoryNameController.text
                                      }).eq('id', widget.categoryId);
                                      final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Success!',
                                          message:
                                          'Berhasil update kategori ${categoryNameController.text}',
                                          contentType: ContentType.success,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      Navigator.pop(context);
                                    } catch (err) {
                                      final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: 'Error!',
                                          message:
                                          'Ada error : $err',
                                          contentType: ContentType.failure,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    }
                                  },
                                  child: const Center(
                                    child: Text(
                                      "Update",
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