


import 'package:cloud_firestore/cloud_firestore.dart';

class appUser {
  String username;
  String age;
  dynamic url;
  String uID;
  String title;
  List followers;
  List following;

appUser({
  required  this.age,
  required  this.username,
  required  this.url,
  required  this.uID,
  required this.title,
  required this.followers,
  required this.following,
});

Map<String,dynamic> convertToMap(){
  return {
    "username":username,
    "age":age,
    "imgurl":url,
    "uid":uID,
    "title":title,
    "followers":followers,
    "following":following,
  };
}


static convertSnapToMap(DocumentSnapshot<Map<String,dynamic>> snap){
  if(snap.data()!=null){
    Map snapshot=snap.data()! ;
  return appUser(
    age: snapshot["age"],
    username: snapshot["username"],
    url: snapshot["imgurl"],
    uID: snapshot["uid"],
    title: snapshot["title"],
    followers: snapshot["followers"],
    following: snapshot["following"]
    );
  }
  
}

}