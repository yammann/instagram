import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/firebase_servise/auth.dart';
import 'package:instagram/responsive/responsive.dart';
import 'package:instagram/screenies/regester.dart';
import 'package:instagram/shared/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool obscure = true;

  

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: mobilBackGroundColor,
      appBar: AppBar(
        backgroundColor: mobilBackGroundColor,
        title: const Text(
          "Login",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: mobilBackGroundColor,
        margin: screenWidth > 600
            ? EdgeInsets.symmetric(vertical: 70, horizontal: screenWidth / 4)
            : EdgeInsets.all(10),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (value) {
                      var result = EmailValidator.validate(value!);
                      return result ? null : "Enter a valed Email";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailcontroller,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.email),
                        fillColor: Color.fromARGB(255, 92, 92, 92),
                        filled: true,
                        hintText: "Enter your email adres",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      var result = value!.length >= 8;
                      return result ? null : "Enter a valed password";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordcontroller,
                    obscureText: obscure,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: obscure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                        fillColor: Color.fromARGB(255, 92, 92, 92),
                        filled: true,
                        hintText: "Enter your password",
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await AuthMethods().login(
                          email: emailcontroller.text,
                          password: passwordcontroller.text,
                          context: context);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const ResetPassword()));
                      },
                      child: const Text("Forget password ?",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Do not have an account",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Regester()));
                          },
                          child: const Text("Sing up",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)))
                    ],
                  ),
                  //  GestureDetector(
                  //    child: Container(
                  //     decoration: const BoxDecoration(
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: SvgPicture.asset("assets/icons8-google.svg"),
                  //    ),
                  //     onTap: (){
                  //       // googleSignIn.googlelogin();
                  //     },
                  //  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
