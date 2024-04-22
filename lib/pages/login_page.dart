import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parentopia/main.dart';

class FLoginPage extends StatelessWidget {
  const FLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var mediaW = MediaQuery.of(context).size.width;
    var mediaH = MediaQuery.of(context).size.height;
    var color = const Color.fromRGBO(126, 179, 250, 100);

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
          title: Text(
            "Masuk Parentopia",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          )
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          // reverse: true,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Text(
                        "Tetap menjadi orang tua yang baik :D",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/Login_figure.png",
                        width: mediaW/1.15,
                      ),
                    ),
                  ],
                ),
                
                Container(
                  margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  height: mediaH/1.99,
                  width: mediaW,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: _emailController,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.email_rounded, size:18),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Email",
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.grey[900], // Modify hint text color
                                  fontSize: 16, // Modify hint text size
                                  fontWeight: FontWeight.w400, // Modify hint text weight
                                ),
                                isDense: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_rounded, size: 18),
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "Password",
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.grey[900], // Modify hint text color
                                  fontSize: 16, // Modify hint text size
                                  fontWeight: FontWeight.w400, // Modify hint text weight
                                ),
                                isDense: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                                focusedBorder: const  OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40,),
                            ElevatedButton(
                              onPressed: () async {
                                 await _login();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(42, 115, 197, 100), // Set the background color
                                foregroundColor: Colors.white, // Set the text color
                                fixedSize: Size(mediaW/1.5, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                "Masuk",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      );
  }

  Future<void> _login() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        // Sign in the user with email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // If login is successful, you can perform additional actions like updating user information
        User? user = userCredential.user;
        if (user != null) {
          // Update user information in Firestore if needed
          // Example: _updateUserInfo(user.uid);
          log('Login successful: ${user.uid}');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ),
              (route) => false,
            );
        }
      } else {
        // Handle empty email or password
        // log('Please enter valid email and password');

        // Show SnackBar to notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter valid email and password'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle login errors
      if (e is FirebaseAuthException) {
        // Check specific error codes
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          // Handle incorrect email or password
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Incorrect email or password'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Handle other authentication errors
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Authentication error: ${e.message}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Handle other non-authentication errors
        log('Login error: $e');
      }
    }
  }
}