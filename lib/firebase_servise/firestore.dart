import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram/firebase_servise/storage.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  String postId = Uuid().v1();
  Posting({
    required profilImg,
    required username,
    required describtion,
    required context,
    required imgPaht,
    required imgName,
  }) async {
    try {
      dynamic postImg = await getProfilImg(
          imgName: imgName,
          imgPaht: imgPaht,
          foldername: "imgPost/${FirebaseAuth.instance.currentUser!.uid}");

      CollectionReference posts =
          FirebaseFirestore.instance.collection("posts");

      Post post = Post(
          username: username,
          describtion: describtion,
          profilImg: profilImg,
          uId: FirebaseAuth.instance.currentUser!.uid,
          postId: postId,
          postImg: postImg,
          datePublished: DateTime.now(),
          liks: []);

      posts.doc(postId).set(post.convertToMap());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ShowSnackBar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
  }

  Commenting(
      {required postId,
      required url,
      required commentTextController,
      required username,
      required uID,
      required context}) async {
    if (commentTextController.isNotEmpty) {
      dynamic commentId = Uuid().v1();
      await FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("comments")
          .doc(commentId)
          .set({
        "commenterProImg": url,
        "commenterUserName": username,
        "commentText": commentTextController,
        "datePublished": DateTime.now(),
        "commenterId": uID,
        "commentId": commentId,
      });
    }
    else{
      ShowSnackBar(context, "this comment is empty");
    }
  }
}
