import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/provider/user_provide.dart';
import 'package:instagram/shared/colors.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:provider/provider.dart';

class SearshProfile extends StatefulWidget {
  final String userId;

  const SearshProfile({super.key, required this.userId});

  @override
  State<SearshProfile> createState() => _SearshProfileState();
}

class _SearshProfileState extends State<SearshProfile> {
  int countPost = 0;

  getPostCount() async {
    var snap = await FirebaseFirestore.instance
        .collection("posts")
        .where("uId", isEqualTo: widget.userId)
        .get();
    setState(() {
      countPost = snap.docs.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostCount();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserProvider>(context).getUser;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: mobilBackGroundColor,
      appBar: AppBar(
        backgroundColor: mobilBackGroundColor,
        title: Text(userData!.username),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: NetworkImage(userData.url),
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            countPost.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Post"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            userData.followers.length.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Followers"),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            userData.following.length.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Following"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              width: double.infinity,
              child: Text(userData.title)),
          Divider(
            color: Colors.grey,
            thickness: 0.1,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: screenWidth / 2.2,
                  height: 45,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[400])),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Follow"),
                        ],
                      )),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 0.1,
          ),
          FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("posts")
                .where("uId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Image.network(
                          snapshot.data!.docs[index]["postImg"],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}
