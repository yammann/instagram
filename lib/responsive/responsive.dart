import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/provider/user_provide.dart';
import 'package:instagram/responsive/mobile.dart';
import 'package:instagram/responsive/web.dart';
import 'package:provider/provider.dart';

class Responsive extends StatefulWidget {
  const Responsive({super.key});

  @override
  State<Responsive> createState() => _ResponsiveState();
}

class _ResponsiveState extends State<Responsive> {

  getDataFromDB()async{
    UserProvider userProvider= Provider.of(context,listen: false);
    await userProvider.refreshUser();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromDB();
  }

  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Web();
        } else {
          return Mobil();
        }
      },
    );
  }
}
