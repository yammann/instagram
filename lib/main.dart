import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/firebase_options.dart';
import 'package:instagram/provider/user_provide.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/screenies/regester.dart';
import 'package:instagram/screenies/signin.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDQYfenAr5ZrSvKPE7A_LUUu9AlxMgNBR4",
            authDomain: "instagram-aad02.firebaseapp.com",
            projectId: "instagram-aad02",
            storageBucket: "instagram-aad02.appspot.com",
            messagingSenderId: "733498307256",
            appId: "1:733498307256:web:8a023fe572b6c2510ffa4d"));
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>UserProvider() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: StreamBuilder( 
          stream: FirebaseAuth.instance.authStateChanges(), 
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(
                color: Colors.white,
              ),);
            }
            else if(snapshot.hasError){
              return ShowSnackBar(context, "has error");
            }
            else if(snapshot.hasData){
              return Responsive();
            }
            else{
              return Login();
            }
    
          },
          ),
        //  Responsive(),
      ),
    );
  }
}
