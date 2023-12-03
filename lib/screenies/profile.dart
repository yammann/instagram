
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/shared/colors.dart';

class Profile extends StatefulWidget {
  final userId;

  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late int countPost;
  late int followers;
  late int following;
  Map userData = {};
  late bool isfollow;

  late bool isloadin;

  getData() async {
    setState(() {
      isloadin = true;
    });
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("users")
          .doc(widget.userId)
          .get();

      userData = snapshot.data()!;

      followers = userData["followers"].length;
      following = userData["following"].length;
      isfollow = userData["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);
      var snap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uId", isEqualTo: widget.userId)
          .get();

      countPost = snap.docs.length;
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      isloadin = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return isloadin
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          )
        : Scaffold(
            backgroundColor: mobilBackGroundColor,
            appBar: AppBar(
              backgroundColor: mobilBackGroundColor,
              title: Text(userData["username"]),
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
                          backgroundImage: NetworkImage(userData["imgurl"]),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                  userData["followers"].length.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                  userData["following"].length.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                    child: Text(userData["title"])),
                Divider(
                  color: Colors.grey,
                  thickness: 0.1,
                ),
                FirebaseAuth.instance.currentUser!.uid == widget.userId
                    ? Container(
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
                                      MaterialStateProperty.all(primaryColor),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("Edit Profile"),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: screenWidth / 2.2,
                              height: 45,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.red[400])),
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
                                      Text("Logout"),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            isfollow
                                ? Container(
                                    width: screenWidth / 2.2,
                                    height: 45,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.red[400])),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.userId)
                                              .update({
                                            "followers":
                                                FieldValue.arrayRemove([
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                            ])
                                          });

                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "following": FieldValue.arrayRemove(
                                                [widget.userId])
                                          });

                                          setState(() {
                                            getData();
                                            isfollow = !isfollow;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text("Unfollow"),
                                          ],
                                        )),
                                  )
                                : Container(
                                    width: screenWidth / 2.2,
                                    height: 45,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.blue[400])),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(widget.userId)
                                              .update({
                                            "followers": FieldValue.arrayUnion([
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                            ])
                                          });

                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .update({
                                            "following": FieldValue.arrayUnion(
                                                [widget.userId])
                                          });

                                          setState(() {
                                            getData();
                                            isfollow = !isfollow;
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
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
                      .where("uId", isEqualTo: widget.userId)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(



    onDoubleTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  child: Container(
                                    width: 200,
                                    height: 150,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: ()async {
                                            Navigator.pop(context);
                                           FirebaseFirestore.instance
                                           .collection("posts")
                                           .doc(snapshot.data!.docs[index]["postId"])
                                           .delete();
                                           setState(() {
                                             
                                           });
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                "Delete post",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Icon(
                                                Icons.delete_forever_rounded,
                                                size: 25,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(fontSize: 25),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },




                                child: Image.network(
                                  snapshot.data!.docs[index]["postImg"],
                                  fit: BoxFit.cover,
                                ),
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
