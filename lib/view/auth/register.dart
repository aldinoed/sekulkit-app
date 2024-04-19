import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sekulkit/utils/constant.dart';

import '../../widgets/textfield.dart';
import '../main/home.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool isLoading = false;
  TextEditingController np = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> _getToken(String np) async {
    final response = await client
        .from('token')
        .select('*')
        .match({'token_code': np, 'is_registered': false});
    if (response.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 80, top: 20),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(7)),
                    child: const Image(
                      image: AssetImage('assets/logo.png'),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: textField('Token', np, false)),
                  Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: textField('Email', email, false)),
                  Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: textField('Password', passwordController, false)),
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
                              if (await _getToken(np.text)) {
                                final response = await client.auth.signUp(
                                    password: passwordController.text,
                                    email: email.text);
                                if (response != null) {
                                  await client
                                      .from('token')
                                      .update({'is_registered': true}).match(
                                          {'token_code': np.text});
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Success!',
                                      message: 'Registrasi berhasil silahkan periksa email Anda',
                                      contentType: ContentType.success,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return const Login();
                                  }));
                                } else {
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'Error!',
                                      message: 'Registrasi gagal',
                                      contentType: ContentType.failure,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                }
                              } else {
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Failed!',
                                    message: 'Token tidak terdaftar',
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
                                "Daftar",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Sudah punya akun?',
                          textAlign: TextAlign.right,
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Login();
                              }));
                            },
                            child: const Text(
                              ' Masuk',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
