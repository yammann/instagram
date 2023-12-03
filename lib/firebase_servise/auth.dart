import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/firebase_servise/storage.dart';
import 'package:instagram/models/user.dart';
import 'package:instagram/shared/snackbar.dart';

class AuthMethods {
  regester(
      {required email,
      required password,
      required context,
      required username,
      required age,
      required imgName,
      required imgPaht,
      required title}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      dynamic url=await getProfilImg(imgName: imgName, imgPaht: imgPaht,foldername: "imgProfile");

      CollectionReference userss =
          FirebaseFirestore.instance.collection("users");
      appUser userr = appUser(
       age: age,
       username: username, 
       url: url,
       uID: credential.user!.uid,
       title: title,
       followers:[] ,
       following:[] ,
       );

      userss
      .doc(credential.user!.uid)
      .set(userr.convertToMap());
          
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

  login({required email,
      required password,
      required context,} )async{
    try {
      final credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      
          
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

  Future<appUser> getUserData()async{
    DocumentSnapshot<Map<String,dynamic>> snap=await FirebaseFirestore.instance.collection("users")
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get();
    return appUser.convertSnapToMap(snap);
  }



}
