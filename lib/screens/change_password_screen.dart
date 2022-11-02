// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:medi_track/components/login_textfield.dart';
import 'package:medi_track/screens/homepage_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medi_track/l10n/l10n.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool notvisible = true;
  bool notvisible2 = true;

  void changePassword(oldPassword, newPassword) async {
    FirebaseAuth auth = await FirebaseAuth.instance;

    try {
      print("one");
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "${auth.currentUser!.email}", password: "$oldPassword");
      print("changing");
      final user = await FirebaseAuth.instance.currentUser;
      user!.updatePassword(newPassword);
      print("changed");
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        final snackbar =
          SnackBar(content: Text(AppLocalizations.of(context)!.dataError));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.transparent,
                child: SizedBox(
                    width: 290,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        "${AppLocalizations.of(context)!.changePass}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 290,
                child: Text(
                  "${AppLocalizations.of(context)!.newPassInfo}",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text("${AppLocalizations.of(context)!.oldPass}"),
              SizedBox(
                height: 5,
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
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: null,
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
                height: 40,
              ),
              Text(AppLocalizations.of(context)!.newPass,),
              SizedBox(
                height: 10,
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
                        obscureText: notvisible2,
                        controller: newPasswordController,
                        autofillHints: [AutofillHints.newPassword],
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: null,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              color: Colors.black,
                              onPressed: () {
                                if (notvisible2 == true) {
                                  setState(() {
                                    notvisible2 = false;
                                  });
                                } else {
                                  setState(() {
                                    notvisible2 = true;
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
                height: 50,
              ),
              GestureDetector(
                onTap: () {
                  print(passwordController.text +
                      " " +
                      newPasswordController.text);
                  changePassword(
                      passwordController.text, newPasswordController.text);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.changePass,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                          fontSize: 17),
                    ),
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
