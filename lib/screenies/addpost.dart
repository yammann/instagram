import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/firebase_servise/firestore.dart';
import 'package:instagram/provider/user_provide.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:path/path.dart' show basename;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/shared/colors.dart';
import 'package:provider/provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool secound = false;
  bool isloadin = false;
  Map data={};
  String? imgName;
  Uint8List? imgPaht;
  addImage(ImageSource imgSorc) async {
    final picImag = await ImagePicker().pickImage(source: imgSorc);
    try {
      if (picImag != null) {
        imgPaht = await picImag.readAsBytes();
        setState(() {
          imgName = basename(picImag.path);
          int randum = Random().nextInt(9999999);
          imgName = "$randum$imgName";
        });
      } else {
        ShowSnackBar(context, "no image");
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
    Navigator.pop(context);
  }
 
  final describtioncontroller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData=Provider.of<UserProvider>(context).getUser;
    return secound
        ? Scaffold(
           backgroundColor: mobilBackGroundColor,
            appBar: AppBar(
               backgroundColor: mobilBackGroundColor,
              actions: [
                TextButton(
                    onPressed: () async{
                      setState(() {
                        isloadin=true;
                      });
                      await FirestoreMethods().Posting(
                        profilImg: userData!.url, 
                        username: userData.username, 
                        describtion:describtioncontroller.text, 
                        context: context, 
                        imgPaht: imgPaht, 
                        imgName: imgName);
                        setState(() {
                          isloadin=false;
                          secound=false;
                        });
                        
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(fontSize: 18),
                    ))
              ],
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    imgPaht=null;
                    secound=false;
                  });
                },
                icon: Icon(Icons.arrow_back),
              ),
            ),
            body: Column(
              children: [
                isloadin?LinearProgressIndicator(color: primaryColor,): Divider(thickness: 1,),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(userData!.url),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      height: 60,
                      child: TextField(
                        controller: describtioncontroller,
                        decoration:
                            InputDecoration(hintText: "write a captions......."),
                      ),
                    ),
                    Container(child: Image.memory(imgPaht!,fit: BoxFit.cover,),
                    height: 60,
                    width: 100,)
                  ],
                ),
              ],
            )
            )
        : Scaffold(
            backgroundColor: mobilBackGroundColor,
            appBar: AppBar(
              backgroundColor: mobilBackGroundColor,
              title: Text("Add Post"),
            ),
            body: Center(
              child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.amber[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(20),
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                    label: const Text(
                                      "Camera",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: ()async {
                                      await addImage(ImageSource.camera);
                                      setState(() {
                                        if(imgPaht!=null){
                                          secound=true;
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt_rounded,
                                      size: 40,
                                      color: primaryColor,
                                    )),
                                TextButton.icon(
                                    label: const Text(
                                      "Gallery",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                    ),
                                    onPressed: ()async {
                                       await addImage(ImageSource.gallery);
                                      setState(() {
                                        if(imgPaht!=null){
                                          secound=true;
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      size: 40,
                                      color: primaryColor,
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(fontSize: 20),
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.upload,
                    color: primaryColor,
                    size: 60,
                  )),
            ),
          );
  }
}
