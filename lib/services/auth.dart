import 'package:chat_app_flutter/helper/helperfunctions.dart';
import 'package:chat_app_flutter/modal/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserProfile _userFromFirebaseUser(User user) {
    return user != null
        ? UserProfile(
            userId: user.uid,
            profileName: user.displayName,
            username: user.displayName,
            url: user.photoURL,
            email: user.email,
            bio: "")
        : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
      );
      print(e.toString());
    }
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential result =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return result;
  }

  Future getCurrentUser() async {
    User _user = _auth.currentUser;
    print("User: ${_user.displayName ?? "None"}");
    return _user;
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
      );
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
      );
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      HelperFunctions.saveuserEmailSharedPreference("");
      HelperFunctions.saveuserNameSharedPreference("");
      HelperFunctions.saveuserLoggedInSharedPreference(false);
      return await _auth.signOut();
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
      );
      print(e.toString());
    }
  }
}
