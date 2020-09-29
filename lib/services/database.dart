import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    return await Firestore.instance
        .collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  uploadUserInfo(userMap) {
    Firestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String charRoomId, chatroomMap) {
    Firestore.instance
        .collection("chatroom")
        .document(charRoomId)
        .setData(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
