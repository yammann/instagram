import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_servise/firestore.dart';
import 'package:instagram/provider/user_provide.dart';
import 'package:instagram/shared/colors.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CommentPage extends StatefulWidget {
  final Map data;
  const CommentPage({super.key, required this.data});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    final commenterData = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobilBackGroundColor,
      appBar: AppBar(
        backgroundColor: mobilBackGroundColor,
        title: Text("Comment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("posts")
                  .doc(widget.data["postId"])
                  .collection("comments")
                  .orderBy("datePublished")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  // Handle the case where the data is null.
                  return Text('No data available');
                }
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                    child: CircleAvatar(
                                      radius: 33,
                                      backgroundImage:
                                          NetworkImage(data["commenterProImg"]),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 200,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${data["commenterUserName"]}    ${data["commentText"]}",maxLines: 1,overflow: TextOverflow.ellipsis,),
                                        Text(DateFormat.yMMMMd().format(
                                            data["datePublished"].toDate())),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.favorite))
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(3),
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(commenterData!.url)),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: commentTextController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () async {
                              await FirestoreMethods().Commenting(
                                  commentTextController:
                                      commentTextController.text,
                                  postId: widget.data["postId"],
                                  url: commenterData.url,
                                  username: commenterData.username,
                                  uID: commenterData.uID,
                                  context: context);
                              commentTextController.clear();
                            },
                            icon: Icon(Icons.send)),
                        fillColor: Color.fromARGB(255, 92, 92, 92),
                        filled: true,
                        hintText: "Comment as UserName",
                        hintStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
