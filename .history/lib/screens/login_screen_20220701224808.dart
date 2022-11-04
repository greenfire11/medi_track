import 'package:flutter/material.dart';
import 'package:medi_track/components/login_textfield.dart';
import 'package:medi_track/screens/homepage_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool notvisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            child: AutofillGroup(
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.signyouin,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  LoginTextField(
                      height: 60.0, width: double.infinity, hint: AppLocalizations.of(context)!.email, controller: emailController,),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: TextField(
                            obscureText: notvisible,
                            controller: passwordController,
                            autofillHints: [AutofillHints.password],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(context)!.password,
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  color: Colors.black,
                                  onPressed: () {
                                    if (notvisible == true) {
                                      setState(() {
                                        notvisible = false;
                                      });
                                    } else {
                                      setState(() {
                                        notvisible = true;
                                      });
                                    }
                                  },
                                )),
                            cursorColor: Colors.black,
                            maxLines: 1),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.forgot,
                        style: TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                  SizedBox(height: 70,),
                  GestureDetector(
                    onTap: () async {
                      
                      try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            print('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            print('The account already exists for that email.');
                          }
                        } catch (e) {
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage2()),
                        );
                    },
                    child: Container(
                      height: 60,
                      width: 140,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
