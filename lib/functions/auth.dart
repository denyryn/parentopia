import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      // Get current user UID
      String uid = _auth.currentUser!.uid;

      // Fetch user details from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // Return user details as a Map
      return userSnapshot.data();
    } catch (e) {
      log('Error fetching user details: $e');
      return null;
    }
  }
}
