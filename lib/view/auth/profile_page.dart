import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '';
import '../../utils/constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // final ek = client.auth.currentUser;
  dynamic email;
  dynamic nama;

  Future<void> _getUserSession() async {
    email = await client.auth.currentUser?.email;
    setState(() {
      // print( currentSessionUser['id']);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.05),
      body: email != null
          ? Center(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 1.7,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      child: Text('Email : ${email}', style: const TextStyle(fontSize: 16),),
                    )
                  ],
                ),
              ),
            )
          : Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.deepPurpleAccent, size: 50),
            ),
    );
  }
}
