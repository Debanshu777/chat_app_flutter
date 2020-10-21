import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  getUserByUsername(String username) async {
    return await firestore
        .collection("users")
        .where("username", isGreaterThanOrEqualTo: username)
        .get();
  }

  getUserByEmail(String userEmail) async {
    return await firestore
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }

  uploadUserInfo(userMap) {
    firestore.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String charRoomId, chatroomMap) {
    firestore
        .collection("chatroom")
        .doc(charRoomId)
        .set(chatroomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    firestore
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    return firestore
        .collection("chatroom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }

  getChatRooms(String userName) async {
    return firestore
        .collection("chatroom")
        .where("users", arrayContains: userName)
        .snapshots();
  }
}
