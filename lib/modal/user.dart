import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String userId;
  final String profileName;
  final String username;
  final String url;
  final String email;
  final String bio;

  UserProfile(
      {this.userId,
      this.profileName,
      this.username,
      this.url,
      this.email,
      this.bio});

  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
        userId: doc.id,
        profileName: doc["displayName"],
        username: doc["username"],
        url: doc["url"],
        email: doc["email"],
        bio: doc["bio"]);
  }
}
