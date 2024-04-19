import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../utils/constant.dart';
import '../../widgets/textfield.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String productName = '';
  List<Map<String, dynamic>>? category;
  late String selectedCategory;
  late String extensionImage;

  // late VoidCallback _textEditingListener;

  void onUpload(String imageUrl) {
    setState(() {
      _imageUrl = imageUrl;
    });
    print(_imageUrl);
  }

  String? _imageUrl;

  void _updateProductName() {
    setState(() {
      productName = productNameController.text;
    });
  }

  @override
  void dispose() {
    // _textEditingListener.call();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Tambah Produk',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 0.5),
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child:
                      textField('Nama Produk', productNameController, false)),
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: DropdownButtonFormField(
                  // value: category[0]['id'],
                  decoration: InputDecoration(
                    hintText: 'Kategori Produk',
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.deepPurpleAccent),
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
                  child: textField('Deskripsi Produk', descController, false)),
              Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: textField('Harga Produk', priceController, true)),
              Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: textField('Jumlah Produk', quantityController, true)),
              Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: textField('Brand Produk', brandNameController, false)),
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
                                  border: Border.all(color: Colors.black45)),
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: _imageUrl != null
                                  ? Image.network(
                                      _imageUrl!,
                                      width: 80,
                                      height: 80,
                                    )
                                  : const Icon(Icons.add_a_photo_outlined),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 3,
                              child: Container(
                                  width: 120,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: Colors.grey[100],
                                      border: Border.all(width: 1)),
                                  child: Material(
                                    borderRadius: BorderRadius.circular(2),
                                    color: Colors.transparent,
                                    child: InkWell(
                                      splashColor: Colors.deepPurple[200],
                                      borderRadius: BorderRadius.circular(2),
                                      onTap: () async {
                                        final ImagePicker picker =
                                            ImagePicker();
                                        final XFile? image =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
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
                                            .uploadBinary(path, imageBytes,
                                                fileOptions: FileOptions(
                                                    upsert: true,
                                                    contentType:
                                                        'image/$imageExtension'));
                                        final String imageUrl = client.storage
                                            .from('product_assets')
                                            .getPublicUrl(path);
                                        setState(() {});
                                        onUpload(imageUrl);
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Upload foto produk",
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
                          List<Map<String, dynamic>> dataExisted = await client
                              .from('product')
                              .select('product_name')
                              .eq('product_name', productNameController.text);
                          if (dataExisted.isNotEmpty) {
                            final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                    title: 'Gagal!',
                                    message: 'Data sudah ada',
                                    contentType: ContentType.failure));
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          } else {
                            if (selectedCategory == null) {
                              final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                      title: 'Gagal!',
                                      message: 'Kategori belum dipilih',
                                      contentType: ContentType.failure));
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(snackBar);
                            }
                            dynamic response =
                                await client.from('product').insert({
                              'product_name': productNameController.text,
                              'brand_name': brandNameController.text,
                              'quantity': quantityController.text,
                              'price': priceController.text,
                              'product_image': _imageUrl,
                              'category_id': selectedCategory,
                              'extension': extensionImage,
                              'description': descController.text
                            });
                            final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                    title: 'Success!',
                                    message:
                                        'Berhasil menambahkan produk ${productNameController.text}',
                                    contentType: ContentType.success));
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                            response ?? Navigator.pop(context);
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
        ),
      ),
    );
  }
}

String _cleanString(String input) {
  return input.replaceAll(' ', '_');
}
