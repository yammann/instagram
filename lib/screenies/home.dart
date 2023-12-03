import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/shared/colors.dart';
import 'package:instagram/shared/post_design.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
     var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    
    return Scaffold(
        backgroundColor: screenwidth > 600 ? null : mobilBackGroundColor,
        appBar: screenwidth > 600
            ? null
            : AppBar(
                backgroundColor: mobilBackGroundColor,
                actions: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.chat_bubble_outline)),
                  IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(Icons.logout)),
                ],
                title: Text("INSTAGRAM")),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Colors.white),);
            }

            if (!snapshot.hasData || snapshot.data == null) {
              // Handle the case where the data is null.
              return Text('No data available');
            }
            return Container(
      margin: screenwidth > 600
          ? EdgeInsets.symmetric(
              vertical: screenheight / 20, horizontal: screenwidth / 5)
          : EdgeInsets.symmetric(vertical: 0, horizontal: 0),
      decoration: BoxDecoration(
          color: mobilBackGroundColor, borderRadius: BorderRadius.circular(12)),
      child:ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return 
                 PostDesign(postData: data,
                 );
                
              }).toList(),
            ),
            );
          },
        ));
  }
}
