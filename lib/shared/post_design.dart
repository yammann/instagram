import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screenies/comment.dart';
import 'package:instagram/shared/colors.dart';
import 'package:intl/intl.dart';

class PostDesign extends StatefulWidget {
  final postData;

  const PostDesign({
    super.key,
    required this.postData,
  });

  @override
  State<PostDesign> createState() => _PostDesignState();
}

class _PostDesignState extends State<PostDesign> {
   int countComment=0;

  getCountComment() async {
    var snapshot = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.postData["postId"])
        .collection("comments")
        .get();

    setState(() {
      countComment = snapshot.docs.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountComment();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            NetworkImage(widget.postData["profilImg"]),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(widget.postData["username"]),
                  ],
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: screenwidth > 600 ? screenheight / 1.5 : screenheight / 2,
            child: Image.network(
              widget.postData["postImg"],
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border_outlined)),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentPage(
                                data: widget.postData,
                              ),
                            ));
                      },
                      icon: Icon(Icons.chat)),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.send)),
                ],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.save_alt)),
            ],
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.postData["describtion"]),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.postData["liks"].length} ${widget.postData["liks"].length > 1 ? "likes" : "like"} ",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 5,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentPage(
                              data: widget.postData,
                            ),
                          ));
                    },
                    child: Text(
                      "view all ${countComment} comment",
                      style: TextStyle(color: Colors.white),
                    )),
                SizedBox(
                  height: 5,
                ),
                Text(DateFormat.yMMMd()
                    .format(widget.postData["datePublished"].toDate())),
              ],
            ),
          ),
          Divider(
            thickness: 2,
            color: primaryColor,
          )
        ],
      ),
    );
  }
}
