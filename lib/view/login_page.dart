import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task/controller/user_controller.dart';

import 'package:flutter_task/view/assesments_page.dart';
import 'package:flutter_task/view/signup_page.dart';

import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> loginExistingUser() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    try {
      // 1) Sign in with Firebase Auth
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login failed.")));
        return;
      }

      // 2) Look up Firestore user document using authUid
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('authUid', isEqualTo: firebaseUser.uid)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User record not found in Firestore.")),
        );
        return;
      }

      final doc = querySnapshot.docs.first;
      final String firestoreDocId = doc.id;
      final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // 3) Save to SharedPreferences
      await UserController().setSharedPrefData(
        email: data['email'] ?? email,
        userId: firestoreDocId, // <-- Firestore auto-generated document ID
        loginFlag: true,
        name: data['name'] ?? "",
      );

      // 4) Feedback & navigation
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful!")));

      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AssesmentsPage()),
      );
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(ex.message ?? "Login failed")));
    } catch (ex) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unexpected error: $ex")));
    }

    // Debug logs (optional)
    log(UserController().userId);
    log(UserController().name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 255),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 62),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 34,
                      width: 81,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: Color.fromRGBO(234, 234, 234, 1),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                "assets/image/test.png",
                                height: 22,
                                width: 22,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Eng",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(67, 67, 67, 1),
                              ),
                            ),
                            const SizedBox(width: 6),
                            SvgPicture.asset(
                              "assets/svg/right_line.svg",
                              height: 10,
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 120),
                  SvgPicture.asset("assets/svg/logo.svg"),
                  SizedBox(height: 5),
                  Text(
                    "Login or create your account",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(114, 122, 135, 1),
                    ),
                  ),
                  SizedBox(height: 67),
                  TextField(
                    controller: emailController,
                    cursorColor: const Color.fromARGB(255, 0, 0, 0),

                    decoration: InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(50, 50, 50, 1),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SvgPicture.asset(
                          "assets/svg/email.svg",
                          height: 18,
                          width: 18,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(232, 233, 237, 1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(232, 233, 237, 1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    cursorColor: const Color.fromARGB(255, 0, 0, 0),
                    obscureText: true, // hides the password
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(50, 50, 50, 1),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Icon(
                          Icons.key_rounded,
                          size: 30,
                          color: const Color.fromARGB(202, 0, 0, 0),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(232, 233, 237, 1),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(232, 233, 237, 1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 27),
                  GestureDetector(
                    onTap: () {
                      loginExistingUser();
                    },
                    child: Container(
                      height: 57,
                      width: 190,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(37, 95, 213, 1),
                        borderRadius: BorderRadius.circular(28.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 10),
                          SvgPicture.asset(
                            "assets/svg/right_arrow.svg",
                            height: 13,
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: Container(
                      height: 57,
                      width: 240,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(37, 95, 213, 1),
                        borderRadius: BorderRadius.circular(28.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Create Account",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 10),
                          SvgPicture.asset(
                            "assets/svg/right_arrow.svg",
                            height: 13,
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/svg/loginbottom.svg",
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 27,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/svg/headphone_man.svg",
                  height: 22,
                  width: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  "Support",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
