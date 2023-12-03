import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screenies/addpost.dart';
import 'package:instagram/screenies/favorite.dart';
import 'package:instagram/screenies/home.dart';
import 'package:instagram/screenies/profile.dart';
import 'package:instagram/screenies/search.dart';
import 'package:instagram/shared/colors.dart';

class Mobil extends StatefulWidget {
  const Mobil({super.key});

  @override
  State<Mobil> createState() => _MobilState();
}

class _MobilState extends State<Mobil> {
  int currenPage =0;
  final PageController _pageController=PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobilBackGroundColor,
        onTap: (index) {
          _pageController.jumpToPage(index);
           setState(() {
            currenPage=index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,color:currenPage==0? primaryColor:secondaryColor,)),
          BottomNavigationBarItem(icon: Icon(Icons.search,color:currenPage==1? primaryColor:secondaryColor,)),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle,color:currenPage==2? primaryColor:secondaryColor,)),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,color:currenPage==3? primaryColor:secondaryColor,)),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded,color:currenPage==4? primaryColor:secondaryColor,)),
        ],
          
      ),
      body: PageView(
        onPageChanged: (index) {
         
        },
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Home(),
          Searche(),
          AddPost(),
          Favorite(),
          Profile(userId: FirebaseAuth.instance.currentUser!.uid,)
        ],
      ),
    );
  }
}