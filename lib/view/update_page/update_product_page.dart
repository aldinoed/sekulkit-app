import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/constant.dart';
import '../../widgets/textfield.dart';

class UpdateProduct extends StatefulWidget {
  final productId;
  final categoryId;

  const UpdateProduct(
      {Key? key, required this.productId, required this.categoryId})
      : super(key: key);

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String productName = '';
  List<Map<String, dynamic>>? category;
  late String selectedCategory;
  late String extensionImage;
  Map<String, dynamic>? dataDetail;
  Map<String, dynamic>? dataCategory;
  bool isLoaded = false;

  _getProductDetail() async {
    dataDetail = await client
        .from('product')
        .select('*')
        .eq('id', widget.productId)
        .single();
    dataCategory = await client
        .from('category')
        .select('category_name')
        .eq('id', widget.categoryId)
        .single();
    setState(() {
      productNameController.text = dataDetail?['product_name'];
      descController.text = dataDetail?['description'];
      priceController.text = dataDetail!['price'].toString();
      quantityController.text = dataDetail!['quantity'].toString();
      brandNameController.text = dataDetail?['brand_name'];
      selectedCategory = widget.categoryId;
      // _imageUrl = dataDetail?['product_image'];
    });
  }

  // late VoidCallback _textEditingListener;

  void onUpload(String imageUrl) {
    _imageUrl = imageUrl;
    setState(() {});
  }

  String? _imageUrl;

  void _updateProductName() {
    setState(() {
      productName = productNameController.text;
    });
  }

  @override
  void dispose() {
    productNameController.removeListener(_updateProductName);
    productNameController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategory() async {
    category = await client.from('category').select('*');
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productNameController.addListener(_updateProductName);
    _fetchCategory();
    _getProductDetail();

    setState(() {
      // isLoaded = true;
    });
    // print('Ini' + dataDetail['product_name']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Update Produk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: dataDetail == null || dataCategory == null
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.deepPurpleAccent, size: 50),
            )
          : Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.5),
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.only(
                  bottom: 25, left: 30, right: 30, top: 25),
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: textField(
                            'Nama Produk', productNameController, false)),
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: DropdownButtonFormField(
                        value: selectedCategory,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        items: category?.map((e) {
                          return DropdownMenuItem(
                            value: e['id'],
                            child: Text(e['category_name']),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            print(newValue);
                            selectedCategory = newValue as String;
                          });
                        },
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: textField(
                            'Deskripsi Produk', descController, false)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child:
                            textField('Harga Produk', priceController, true)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: textField(
                            'Jumlah Produk', quantityController, true)),
                    Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        child: textField(
                            'Brand Produk', brandNameController, false)),
                    productName.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 30),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        border:
                                            Border.all(color: Colors.black45)),
                                    width: 80,
                                    height: 80,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: _imageUrl != null
                                        ? Image.network(
                                            _imageUrl!,
                                            width: 80,
                                            height: 80,
                                          )
                                        : const Icon(
                                            Icons.add_a_photo_outlined),
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 3,
                                    child: Container(
                                        width: 120,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: Colors.grey[100],
                                            border: Border.all(width: 1)),
                                        child: Material(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashColor: Colors.deepPurple[200],
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            onTap: () async {
                                              final ImagePicker picker =
                                                  ImagePicker();
                                              final XFile? image =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (image == null) return;
                                              final imageExtension = image.path
                                                  .split('.')
                                                  .last
                                                  .toLowerCase();
                                              setState(() {
                                                extensionImage = imageExtension;
                                              });

                                              final imageBytes =
                                                  await image.readAsBytes();
                                              final path = _cleanString(
                                                  productNameController.text);
                                              await client.storage
                                                  .from('product_assets')
                                                  .uploadBinary(
                                                      path, imageBytes,
                                                      fileOptions: FileOptions(
                                                          upsert: true,
                                                          contentType:
                                                              'image/$imageExtension'));
                                              final String imageUrl = client
                                                  .storage
                                                  .from('product_assets')
                                                  .getPublicUrl(path);
                                              onUpload(imageUrl);
                                              setState(() {});
                                            },
                                            child: const Center(
                                              child: Text(
                                                "Update foto produk",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
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
                                dynamic response;
                                try {
                                  if (dataDetail?['product_name'] !=
                                          productNameController.text &&
                                      _imageUrl == null) {
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Error!',
                                        message: 'Foto wajib diupload',

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.failure,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  } else if (dataDetail?['product_name'] !=
                                          productNameController.text &&
                                      _imageUrl != null) {
                                    await client.from('product').update({
                                      'product_name':
                                          productNameController.text,
                                      'brand_name': brandNameController.text,
                                      'quantity': quantityController.text,
                                      'price': priceController.text,
                                      'product_image': _imageUrl,
                                      'category_id': selectedCategory,
                                      'extension': extensionImage,
                                      'description': descController.text
                                    }).eq('id', widget.productId);
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Success!',
                                        message: 'Berhasil update produk',

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    Navigator.pop(context);
                                  } else {
                                    await client.from('product').update({
                                      'product_name':
                                          productNameController.text,
                                      'brand_name': brandNameController.text,
                                      'quantity': quantityController.text,
                                      'price': priceController.text,
                                      'category_id': selectedCategory,
                                      'description': descController.text
                                    }).eq('id', widget.productId);
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Success!',
                                        message:
                                            'Berhasil update produk ${productNameController.text}',
                                        contentType: ContentType.success,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    response ?? Navigator.pop(context);
                                  }
                                } catch (err) {
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Error!',
                                      message: 'Error : $err',
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
              ),
            ),
    );
  }
}

String _cleanString(String input) {
  return input.replaceAll(' ', '_');
}
