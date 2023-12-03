import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:instagram/screenies/profile.dart';
import 'package:instagram/shared/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/shared/snackbar.dart';

class Searche extends StatefulWidget {
  const Searche({super.key});

  @override
  State<Searche> createState() => _SearcheState();
}

class _SearcheState extends State<Searche> {
  final searshController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobilBackGroundColor,
      appBar: AppBar(
        backgroundColor: mobilBackGroundColor,
        title: TextField(
          onChanged: (value) {
            setState(() {});
          },
          controller: searshController,
          decoration: InputDecoration(labelText: "Search for a user"),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .where("username", isEqualTo: searshController.text)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ShowSnackBar(context, "has error");
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                              userId: snapshot.data!.docs[index]["uid"]),
                        ));
                  },
                  title: Text(snapshot.data!.docs[index]["username"]),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(snapshot.data!.docs[index]["imgurl"]),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      ),
    );
  }
}
