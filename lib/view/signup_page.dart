import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task/controller/user_controller.dart';

import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Future<void> createAccountFirebase() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();
    final String name = nameController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all the fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    try {
      // 1) Create Firebase Auth user
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account creation failed.")),
        );
        return;
      }

      // 2) Create Firestore user document (auto-generated id)
      final CollectionReference usersCol = FirebaseFirestore.instance
          .collection('users');

      DocumentReference docRef;
      try {
        docRef = await usersCol.add({
          'authUid':
              firebaseUser
                  .uid, // keep auth uid in the document for later lookup
          'email': email,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (firestoreErr) {
        // If Firestore write fails, remove the newly created auth user to avoid orphaned accounts
        try {
          await firebaseUser.delete();
        } catch (_) {
          // deletion might fail depending on state; log it or ignore
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to create user record: $firestoreErr"),
          ),
        );
        return;
      }

      // 3) Save to SharedPreferences using your UserController
      await UserController().setSharedPrefData(
        email: email,
        userId:
            docRef.id, // <-- THIS IS THE FIRESTORE AUTO-GENERATED DOCUMENT ID
        loginFlag: true,
        name: name,
      );

      // 4) Feedback & navigation (adjust as you prefer)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully!")),
      );

      // Option A: go straight to main/home page
      Navigator.of(context).pop();

      // Option B (if you prefer to return to login screen): Navigator.pop(context);
    } on FirebaseAuthException catch (ex) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ex.message ?? "Something went wrong")),
      );
    } catch (ex) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unexpected error: $ex")));
    }

    log(UserController().userId);
    log(UserController().name);
  }

  void clearController() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 255),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.08,
              vertical: screenHeight * 0.07,
            ),
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
                SizedBox(height: screenHeight * 0.10),
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
                SizedBox(height: 30),
                TextField(
                  controller: nameController,
                  cursorColor: const Color.fromARGB(255, 0, 0, 0),

                  decoration: InputDecoration(
                    hintText: "Enter name",
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(50, 50, 50, 1),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: const Color.fromARGB(202, 0, 0, 0),
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
                SizedBox(height: screenHeight * 0.02),

                TextField(
                  controller: emailController,
                  cursorColor: const Color.fromARGB(255, 0, 0, 0),

                  decoration: InputDecoration(
                    hintText: "Enter email",
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
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  controller: passwordController,
                  cursorColor: const Color.fromARGB(255, 0, 0, 0),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Enter password",
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
                SizedBox(height: screenHeight * 0.02),
                TextField(
                  controller: confirmPasswordController,
                  cursorColor: const Color.fromARGB(255, 0, 0, 0),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Confirm password",
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

                SizedBox(height: screenHeight * 0.035),

                GestureDetector(
                  onTap: () {
                    createAccountFirebase();
                    clearController();
                  },

                  child: Container(
                    height: screenHeight * 0.07,
                    width: screenWidth * 0.55,
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
                            fontSize: screenWidth * 0.045,
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

          Positioned(
            bottom: 0,
            child: SvgPicture.asset(
              "assets/svg/loginbottom.svg",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: screenHeight * 0.03,
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
