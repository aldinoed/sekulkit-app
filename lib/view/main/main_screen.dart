import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sekulkit/view/auth/profile_page.dart';
import 'package:sekulkit/view/main/category.dart';
import 'package:sekulkit/view/main/home.dart';
import 'package:sekulkit/view/main/product.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _HomePageState();
}

class _HomePageState extends State<MainScreen> {
  int currentTab = 0;
  List<Widget> screens = [
    const Home(),
    const Product(),
    const Category(),
    const ProfilePage(),
  ];
  final PageStorageBucket pageStorageBucket = PageStorageBucket();
  Widget currentScreen = const Home();
  Color onPressed = Colors.deepPurpleAccent;
  Color notPressed = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 75,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[0];
                      currentTab = 0;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_filled,
                        color: currentTab == 0 ? onPressed : notPressed,
                        size: 20,
                      ),
                      Text(
                        'Home',
                        style: TextStyle(
                            color: currentTab == 0 ? onPressed : notPressed,
                            fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 75,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[1];
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.boxes,
                          color: currentTab == 1 ? onPressed : notPressed,
                          size: 20),
                      Text(
                        'Produk',
                        style: TextStyle(
                            color: currentTab == 1 ? onPressed : notPressed,
                            fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 75,
                child: MaterialButton(
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[2];
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_tree_outlined,
                          color: currentTab == 2 ? onPressed : notPressed,
                          size: 20),
                      Text(
                        'Kategori',
                        style: TextStyle(
                            color: currentTab == 2 ? onPressed : notPressed,
                            fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   width: 75,
              //   child: MaterialButton(
              //     onPressed: () {
              //       currentScreen = screens[3];
              //       currentTab = 3;
              //       setState(() {});
              //     },
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Icon(Icons.account_circle_outlined,
              //             color: currentTab == 3 ? onPressed : notPressed,
              //             size: 20),
              //         Text(
              //           'Profil',
              //           style: TextStyle(
              //               color: currentTab == 3 ? onPressed : notPressed,
              //               fontSize: 11),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white70.withOpacity(0.95),
      body:
          // Stack(
          //   children: [
          PageStorage(
        bucket: pageStorageBucket,
        child: currentScreen,
      ),
    );
  }
}
