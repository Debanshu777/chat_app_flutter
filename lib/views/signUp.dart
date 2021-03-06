import 'package:chat_app_flutter/helper/helperfunctions.dart';
import 'package:chat_app_flutter/modal/user.dart';
import 'package:chat_app_flutter/services/auth.dart';
import 'package:chat_app_flutter/services/database.dart';
import 'package:chat_app_flutter/views/BaseView.dart';
import 'package:chat_app_flutter/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController displayNameTextEditingController =
      new TextEditingController();
  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  final formkey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  signMeUp() async {
    if (formkey.currentState.validate()) {
      HelperFunctions.saveuserNameSharedPreference(
          usernameTextEditingController.text);
      HelperFunctions.saveuserEmailSharedPreference(
          emailTextEditingController.text);
      setState(() {
        isLoading = true;
      });
      UserProfile user = await authMethods.signUpWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text);
      Map<String, String> userInfoMap = {
        "userId": user.userId,
        "displayName": displayNameTextEditingController.text,
        "username": usernameTextEditingController.text,
        "url": "",
        "email": emailTextEditingController.text,
        "bio": "",
      };
      databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunctions.saveuserLoggedInSharedPreference(true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BaseView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty || val.length < 4
                                    ? "Please Provide valid Display name"
                                    : null;
                              },
                              controller: displayNameTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("Full name"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty || val.length < 4
                                    ? "Please Provide valid Username"
                                    : null;
                              },
                              controller: usernameTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("Username"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                              decoration: textFieldInputDecoration("Email"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                obscureText: true,
                                validator: (val) {
                                  return val.length > 6
                                      ? null
                                      : "Please Provide atleast 6+ characters";
                                },
                                controller: passwordTextEditingController,
                                style: simpleTextStyle(),
                                decoration:
                                    textFieldInputDecoration("Password")),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              color: Color(0xff007EF4),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text("Sign Up", style: mediumTextStyle()),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have a account? ",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              )),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text("Log In Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
