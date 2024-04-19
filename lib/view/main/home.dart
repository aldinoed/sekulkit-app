import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:sekulkit/view/auth/login.dart';
import 'package:sekulkit/view/subhome/out_of_stock_product_page.dart';
import 'package:sekulkit/widgets/card_overview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int? totalProduct = null;
  int? outOfStock = null;
  int? totalInventoryValue = null;
  int? totalOfCategory = null;
  bool isLoaded = false;

  _getTotalProduct() async {
    final response = await client.from('product').select('product_name');
    totalProduct = response.length;
    setState(() {});
  }

  _getTotalCategory() async {
    final response = await client.from('category').select('*');
    totalOfCategory = response.length;
    setState(() {});
  }

  _getTotalInventoryValue() async {
    final total = await client.rpc('calculate_inventory_value');
    totalInventoryValue = total;
    setState(() {});
  }

  _getOutOfStock() async {
    final response = await client
        .from('product')
        .select('product_name')
        .match({'quantity': 0});
    outOfStock = response.length.toInt();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTotalProduct();
    _getOutOfStock();
    _getTotalInventoryValue();
    _getTotalCategory();
    setState(() {
      isLoaded = true;
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
          'Overview',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: isLoaded == true &&
              (totalProduct != null ||
                  outOfStock != null ||
                  totalInventoryValue != null ||
                  totalOfCategory != null)
          ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      CardOverview(
                        title: 'Jumlah Produk',
                        value: totalProduct.toString(),
                        colorThemeCard:Colors.deepPurple.shade300,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return OutOfStockProduct();
                          }));
                        },
                        child: CardOverview(
                          title: 'Stok Habis',
                          value: outOfStock.toString(),
                          colorThemeCard: Colors.red.shade400,
                        ),
                      ),
                      CardOverview(
                        title: 'Nilai Inventaris',
                        value: totalInventoryValue != null
                            ? 'Rp. ${totalInventoryValue.toString()},-'
                            : 'Rp. 0,-',
                        colorThemeCard: Colors.orangeAccent.shade200,
                      ),
                      CardOverview(
                        title: 'Jumlah Kategori',
                        value: totalOfCategory.toString(),
                        colorThemeCard: Colors.purple.shade200,
                      ),
                    ],
                  )
                ],
              ),
            )
          : Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.deepPurpleAccent, size: 50),
            ),
    );
  }
}
