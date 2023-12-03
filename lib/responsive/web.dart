import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/screenies/addpost.dart';
import 'package:instagram/screenies/favorite.dart';
import 'package:instagram/screenies/home.dart';
import 'package:instagram/screenies/profile.dart';
import 'package:instagram/screenies/search.dart';
import 'package:instagram/shared/colors.dart';

class Web extends StatefulWidget {
  const Web({super.key});

  @override
  State<Web> createState() => _WebState();
}

class _WebState extends State<Web> {
  int currenPage=0;
  PageController _pageController=PageController();
  
  @override
  Widget build(BuildContext context) {
    changePage(currenPage){_pageController.jumpToPage(currenPage);}
    return Scaffold(
      appBar: AppBar(
        title: Text("INSTAGRAM"),
        actions: [
          IconButton(onPressed: (){currenPage=0;setState(() {changePage(currenPage);});}, icon: Icon(Icons.home,color:currenPage==0? primaryColor:secondaryColor,)),
          IconButton(onPressed: (){currenPage=1;setState(() {changePage(currenPage);});},icon: Icon(Icons.search,color:currenPage==1? primaryColor:secondaryColor,)),
          IconButton(onPressed: (){currenPage=2;setState(() {changePage(currenPage);});},icon: Icon(Icons.add_circle,color:currenPage==2? primaryColor:secondaryColor,)),
          IconButton(onPressed: (){currenPage=3;setState(() {changePage(currenPage);});},icon: Icon(Icons.favorite,color:currenPage==3? primaryColor:secondaryColor,)),
          IconButton(onPressed: (){currenPage=4;setState(() {changePage(currenPage);});},icon: Icon(Icons.person_rounded,color:currenPage==4? primaryColor:secondaryColor,)),
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