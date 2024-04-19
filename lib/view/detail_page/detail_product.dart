import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DetailProduct extends StatefulWidget {
  final productId;
  final categoryId;

  const DetailProduct(
      {Key? key, required this.productId, required this.categoryId})
      : super(key: key);

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
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
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductDetail();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          dataDetail?['product_name'] ?? 'N/A',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: dataDetail?['product_image'] == null ||
              dataDetail?['product_name'] == null
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.deepPurpleAccent, size: 50),
            )
          : Container(
              // padding: EdgeInsets.all(25),
              child: Center(
                child: ListView(
                  children: [
                    dataDetail?['product_image'] == null
                        ? Container()
                        : Container(
                            decoration: BoxDecoration(),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 300,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              dataDetail?['product_image']),
                                          fit: BoxFit.cover)),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.0)),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Image(
                                    image: NetworkImage(
                                        dataDetail?['product_image']),
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    SizedBox(
                      height: 50,
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Deskripsi',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              dataDetail?['description'] ?? 'N/A',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Nama Brand',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              dataDetail?['brand_name'] ?? 'N/A',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Tersedia',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              dataDetail?['quantity'] != null
                                  ? '${dataDetail?['quantity'].toString()}'
                                  : 'N/A',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Harga Satuan',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              dataDetail?['price'] != null
                                  ? 'Rp. ${dataDetail?['price'].toString()},-'
                                  : 'N/A',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Kategori Produk',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              dataCategory?['category_name'] != null
                                  ? '${dataCategory?['category_name']}'
                                  : 'N/A',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
