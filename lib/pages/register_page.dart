import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parentopia/main.dart';

class FRegisterPage extends StatelessWidget {
  const FRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
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
            icon:const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          "Daftar Parentopia",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
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
                      "Sudah siap jadi orang tua yang baik?",
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
                            controller: _usernameController,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person, size:18),
                              filled: true,
                              fillColor: Colors.white,
                              isDense: true,
                              labelText: "Username",
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.grey[900], // Modify hint text color
                                fontSize: 16, // Modify hint text size
                                fontWeight: FontWeight.w400, // Modify hint text weight
                              ),
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
                                await _register();
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
                              "Daftar",
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

  Future<void> _register() async {
    try {
      // Trim inputs
      String trimmedEmail = _emailController.text.trim();
      String trimmedPassword = _passwordController.text.trim();
      String trimmedUsername = _usernameController.text.trim();

      // Check for empty fields
      if (trimmedEmail.isEmpty || trimmedPassword.isEmpty || trimmedUsername.isEmpty) {
        log('Registration failed: Please fill in all fields');
        // Handle the error (e.g., show an error message to the user)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed: Please fill in all fields'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Validate email format
      if (!_isValidEmail(trimmedEmail)) {
        log('Registration failed: Please enter a valid email address');
        // Handle the error (e.g., show an error message to the user)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed: Please enter a valid email address'),
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      );

      // Store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': trimmedUsername,
        'profileImageUrl': "https://firebasestorage.googleapis.com/v0/b/parentopia-cc4ab.appspot.com/o/users%2Fblank_profile%2Fblank_profile.jpg?alt=media&token=efbc516d-bcb2-453a-a86c-f96b1f223681",
        'email': trimmedEmail,
        // Add more fields as needed
      });

      // Navigate to the home screen or perform any other actions
      // after successful registration.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );

      log('Registration successful');
    } on FirebaseAuthException catch (e) {
      log('Registration failed: ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.message}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  bool _isValidEmail(String email) {
    // Implement your email validation logic here
    // You can use regular expressions or other methods to validate the email format
    // For example:
    // return RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(email);
    return true; 
  }

}