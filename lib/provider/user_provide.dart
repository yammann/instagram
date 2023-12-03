

import 'package:flutter/foundation.dart';
import 'package:instagram/firebase_servise/auth.dart';
import 'package:instagram/models/user.dart';

class UserProvider with ChangeNotifier{
  appUser? _appUser;
  appUser?  get  getUser=>_appUser; 

  refreshUser()async{
    appUser user=await AuthMethods().getUserData();
    _appUser=user;
    notifyListeners();
  }
}