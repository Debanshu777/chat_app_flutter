import 'package:chat_app_flutter/services/auth.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/views/chatRooms.dart';
import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/helperfunctions.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  signIn() {
    if (formkey.currentState.validate()) {
      HelperFunctions.saveuserEmailSharedPreference(
          emailTextEditingController.text);
      databaseMethods
          .getUserByEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveuserNameSharedPreference(
            snapshotUserInfo.documents[0].data()["name"]);
      });
      setState(() {
        isLoading = true;
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        if (value != null) {
          HelperFunctions.saveuserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRooms()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)
                                ? null
                                : "Please Provide vaild email";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFeildInputDecoration("Email")),
                      TextFormField(
                          obscureText: true,
                          validator: (val) {
                            return val.length > 6
                                ? null
                                : "Please Provide atleast 6+ characters";
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFeildInputDecoration("Password")),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Forgot Password",
                      style: simpleTextStyle(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          const Color(0xff007EF4),
                          const Color(0xff2A75BC),
                        ]),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text("Sign In", style: mediumTextStyle()),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Sign In with Google",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have a account? ",
                      style: mediumTextStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Register Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline,
                            )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
