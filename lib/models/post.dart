import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String describtion;
  final dynamic profilImg;
  final String uId;
  final String postId;
  final String postImg;
  final DateTime datePublished;
  final List liks;

  Post(
      {required this.username,
      required this.describtion,
      required this.profilImg,
      required this.uId,
      required this.postId,
      required this.postImg,
      required this.datePublished,
      required this.liks});

  Map<String, dynamic> convertToMap() {
    return {
      "username": username,
      "describtion": describtion,
      "profilImg": profilImg,
      "uId": uId,
      "postId": postId,
      "postImg": postImg,
      "datePublished": datePublished,
      "liks": liks,
    };
  }

  static convertSnapToMap(DocumentSnapshot<Map<String, dynamic>> snap) {
    Map snapshot = snap.data()!;
    return Post(
        describtion: snapshot["describtion"],
        username: snapshot["username"],
        profilImg: snapshot["profilImg"],
        uId: snapshot["uId"],
        postId: snapshot["postId"],
        postImg: snapshot["postImg"],
        datePublished: snapshot["datePublished"],
        liks: snapshot["liks"]);
  }
}
