import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

import '../functions/auth.dart';
import 'package:parentopia/pages/pages.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User ? currentUser;
  File ? _selectedImage;
  bool editState = false;
  AuthService authservice = AuthService();
  TextEditingController usernameController = TextEditingController();
  // late String username;

  @override
  void initState() {
    super.initState();
    // Initialize the current user when the widget is created
    currentUser = FirebaseAuth.instance.currentUser;
    // usernameController.text = username ;
  }

  @override
  Widget build(BuildContext context) {
    var mediaW = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "Profil",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: FutureBuilder(
          future: authservice.getUserDetails(), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
               return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 3, 155, 229),));
            } else if (snapshot.hasError) {
              return const Text('Error fetching user details');
            } else {
              Map<String, dynamic> userData = snapshot.data!;
              String username = userData['username'];
              String email = userData['email'];
              String profileImage = userData['profileImageUrl'];

              usernameController.text = username;

              var color = Colors.grey[100];
      
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: mediaW,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0,
                          color: const Color.fromRGBO(189, 189, 189, 1),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical:40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: ClipOval(
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: editState
                                    ? _selectedImage != null
                                        ? Image.file(
                                            _selectedImage as File,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          )
                                        : Stack(
                                            children: [
                                              // Image with overlay
                                              SizedBox(
                                                width: mediaW / 2.5,
                                                child: Stack(
                                                  children: [
                                                    Image.network(
                                                      profileImage,
                                                      width: mediaW / 2.5,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Container(
                                                      width: mediaW / 2.5,
                                                      color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Positioned.fill(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                    : Image.network(
                                        profileImage, // or any other default image if needed
                                        width: mediaW / 2.5,
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                              onTap: () => editState ? _pickImage() : (),
                            ),
                        
                            const SizedBox(height: 20,),
                            
                            ElevatedButton(
                              onPressed: () async {
                                if (editState) {
                                  await _updateProfileData();
                                } else {
                                  setState(() {
                                    editState = !editState; 
                                    _selectedImage = null;
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: (editState) ? const Color.fromARGB(246, 126, 180, 250) : Colors.white,// Set the button's background color
                                foregroundColor: (!editState) ? const Color.fromARGB(246, 126, 180, 250) : Colors.white, // Set the text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), // Set border radius
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 15.0), // Set padding
                              ),
                              child: SizedBox(
                                width: mediaW / 2,
                                child: Center(
                                  child: Text(
                                    (!editState) ? 
                                    "Edit Profil" : "Simpan",
                                    style: const TextStyle(
                                      fontSize: 16.0, // Set font size
                                      fontWeight: FontWeight.bold, // Set font weight
                                    ),
                                  ),
                                ),
                              ),
                            ),
              
                            const SizedBox(height: 20,),
                            
                            Container(
                              width: mediaW,
                              decoration: BoxDecoration(
                                color: color,
                                border: Border.all(
                                  width: 0,
                                  color: const Color.fromRGBO(189, 189, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(15)
                                
                              ),
                              child : Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Username",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: Colors.grey[600]
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    editState
                                    ? TextFormField(
                                      controller: usernameController,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15
                                      ),
                                    )
                                    
                                    : Text(
                                      username,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height:20,),
                        
                            Container(
                              width: mediaW,
                              decoration: BoxDecoration(
                                color: color,
                                border: Border.all(
                                  width: 0,
                                  color: const Color.fromRGBO(189, 189, 189, 1),
                                ),
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Email",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: Colors.grey[600]
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      email,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 40,),

                            ElevatedButton(
                              onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const WelcomePage(),
                                    ),
                                    (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],// Set the button's background color
                                foregroundColor: Colors.white, // Set the text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), // Set border radius
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 15.0), // Set padding
                              ),
                              child: SizedBox(
                                width: mediaW,
                                child: const Center(
                                  child: Text(
                                    "Log Out",
                                    style: TextStyle(
                                      fontSize: 16.0, // Set font size
                                      fontWeight: FontWeight.bold, // Set font weight
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        )
      ),
    );
  }

  Future<void> _updateProfileData() async {
    // Get current user UID
    String uid = FirebaseAuth.instance.currentUser!.uid;

    // Downscale the image if available
    img.Image? downscaledImage;
    if (_selectedImage != null) {
      // Load the image
      List<int> imageBytes = await _selectedImage!.readAsBytes();
      img.Image originalImage = img.decodeImage(Uint8List.fromList(imageBytes))!;

      // Define the maximum width or height for the downscaled image
      int maxWidthOrHeight = 700; // Adjust as needed

      // Calculate the new dimensions to maintain the aspect ratio
      int newWidth, newHeight;
      if (originalImage.width > originalImage.height) {
        newWidth = maxWidthOrHeight;
        newHeight = (originalImage.height * maxWidthOrHeight / originalImage.width).round();
      } else {
        newWidth = (originalImage.width * maxWidthOrHeight / originalImage.height).round();
        newHeight = maxWidthOrHeight;
      }

      // Downscale the image
      downscaledImage = img.copyResize(originalImage, width: newWidth, height: newHeight);
    }

    // Update username in Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'username': usernameController.text,
    });

    // Upload image to Firebase Storage
    if (downscaledImage != null) {
      String imagePath = 'users/profile_images/$uid.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(imagePath);

      // Convert downscaledImage to Uint8List
      List<int> downscaledBytes = img.encodeJpg(downscaledImage);
      Uint8List downscaledUint8List = Uint8List.fromList(downscaledBytes);

      UploadTask uploadTask = storageReference.putData(downscaledUint8List);
      await uploadTask.whenComplete(() => null);

      // Get the image download URL
      String imageUrl = await storageReference.getDownloadURL();

      // Update image URL in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'profileImageUrl': imageUrl,
      });
    }

    // Toggle back to non-edit mode
    setState(() {
      editState = !editState;
    });
  }

  Future _pickImage() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if(returnedImage == null) return;
    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }
}