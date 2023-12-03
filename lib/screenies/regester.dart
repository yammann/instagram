import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/firebase_servise/auth.dart';
import 'package:instagram/screenies/signin.dart';
import 'package:instagram/shared/colors.dart';
import 'package:instagram/shared/snackbar.dart';
import 'package:path/path.dart' show basename;

class Regester extends StatefulWidget {
  const Regester({super.key});

  @override
  State<Regester> createState() => _RegesterState();
}

class _RegesterState extends State<Regester> {
  bool obscure = true;
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailcontroler = TextEditingController();
  final passwordcontroler = TextEditingController();
  final namecontroler = TextEditingController();
  final titlecontroler = TextEditingController();
  final agecontroler = TextEditingController();

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

  creatUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      AuthMethods().regester(
          email: emailcontroler.text,
          password: passwordcontroler.text,
          context: context,
          username: namecontroler.text,
          age: agecontroler.text,
          imgName: imgName,
          imgPaht: imgPaht,
          title: titlecontroler.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ShowSnackBar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailcontroler.dispose();
    passwordcontroler.dispose();
    agecontroler.dispose();
    namecontroler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: mobilBackGroundColor,
      appBar: AppBar(
        backgroundColor: mobilBackGroundColor,
        title: const Text(
          "Regester",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        margin: screenWidth > 600
            ? EdgeInsets.symmetric(horizontal: screenWidth / 4)
            : EdgeInsets.all(0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(100, 100, 100, 1)),
                      child: Stack(
                        children: [
                          imgPaht == null
                              ? const CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 80,
                                  backgroundImage:
                                      AssetImage("assets/personel.png"),
                                )
                              : CircleAvatar(
                                  backgroundColor: primaryColor,
                                  radius: 80,
                                  backgroundImage: MemoryImage(imgPaht!)),
                          Positioned(
                              bottom: -10,
                              right: -10,
                              child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.amber[50],
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            height: 200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton.icon(
                                                    label: const Text(
                                                      "Camera",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    onPressed: () {
                                                      addImage(
                                                          ImageSource.camera);
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
                                                          color: Colors.black,
                                                          fontSize: 18),
                                                    ),
                                                    onPressed: () {
                                                      addImage(
                                                          ImageSource.gallery);
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
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: primaryColor,
                                  )))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        return value!.isEmpty ? "Can not be empty" : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: namecontroler,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          fillColor: Color.fromARGB(255, 92, 92, 92),
                          filled: true,
                          hintText: "Enter your name",
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
                        return value!.isEmpty ? "Can not be empty" : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: titlecontroler,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          fillColor: Color.fromARGB(255, 92, 92, 92),
                          filled: true,
                          hintText: "Enter your title",
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
                        return value!.isEmpty ? "Can not be empty" : null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: agecontroler,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.date_range_outlined),
                          fillColor: Color.fromARGB(255, 92, 92, 92),
                          filled: true,
                          hintText: "Enter your age",
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
                        var result = EmailValidator.validate(value!);
                        return result ? null : "Enter a valed Email";
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: emailcontroler,
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
                      controller: passwordcontroler,
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
                          fillColor: const Color.fromARGB(255, 92, 92, 92),
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
                        if (_formkey.currentState!.validate()) {
                          if (imgName != null && imgPaht != null) {
                            await creatUser();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ));
                          } else {
                            ShowSnackBar(
                                context, "you dont choese any picture");
                          }
                        } else {
                          ShowSnackBar(context, "Complete the information");
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Regester",
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "You have an account",
                          style: TextStyle(fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ));
                            },
                            child: const Text("Sing in",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
