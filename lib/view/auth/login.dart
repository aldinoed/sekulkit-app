import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sekulkit/utils/constant.dart';
import 'package:sekulkit/view/auth/register.dart';
import 'package:sekulkit/view/main/main_screen.dart';
import 'package:sekulkit/widgets/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  String? idUser;
  TextEditingController email = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<String?> userLogin(
      {required final String email, required final String password}) async {
    final response =
        await client.auth.signInWithPassword(password: password, email: email);
    final user = response.user;
    idUser = user?.id;
    return user?.id;
    // idUser = user?.email;
    // return response.user?.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [Container(
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
                      child: textField('Email', email, false)),
                  Container(
                      margin: EdgeInsets.only(bottom: 30),
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
                              setState(() {
                                isLoading = true;
                              });
                              try{
                                await userLogin(
                                    email: email.text,
                                    password: passwordController.text);
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Success!',
                                    message:
                                    'Berhasil login.',
                                    contentType: ContentType.success,
                                  ),
                                );
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                      return MainScreen();
                                    }));
                              }catch(err){
                                final snackBar = SnackBar(
                                  elevation: 0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.transparent,
                                  content: AwesomeSnackbarContent(
                                    title: 'Error!',
                                    message:
                                    '$err',
                                    contentType: ContentType.success,
                                  ),
                                );
                              }
                            },
                            child: const Center(
                              child: Text(
                                "Masuk",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'Belum punya akun?',
                          textAlign: TextAlign.right,
                        ),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Register();
                              }));
                            },
                            child: const Text(
                              ' Daftar',
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
        ),]
      ),
    );
  }
}
