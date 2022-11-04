// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../components/login_textfield.dart';
import 'homepage_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool notvisible=true;
  bool notvisible2=true;
  String emailAddress="";
  String password="";
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
                    AppLocalizations.of(context)!.createAccount,
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
                  Container(
      height: height,
      width: width,
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
            autofillHints: [AutofillHints.email],

              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "$hint",
              ),
              cursorColor: Colors.black,
              maxLines: 1),
        ),
      ),
    );
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
                            autofillHints: [AutofillHints.newPassword],
                            controller: passwordController,
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
                    height: 30,
                  ),
                  SizedBox(height: 70,),
                  GestureDetector(
                    onTap: () async {
                      print(emailController.text);
                      print(passwordController.text);
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
                          AppLocalizations.of(context)!.signup,
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