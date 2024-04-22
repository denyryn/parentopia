import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NoteDetailsPage extends StatefulWidget {
  final String? noteId;
  final String title;
  final String description;

  const NoteDetailsPage({Key? key, this.noteId, required this.title, required this.description})
        : super(key: key);
        
  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState();
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String timestamp = '';

  String titleText = '';
  String descriptionText = '';

  @override
  void initState() {
    super.initState();
    // Load existing note data if editing
    if (widget.noteId != null) {
      loadNoteData();
    }
  }

  // Load existing note data if editing
  void loadNoteData() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userId = currentUser.uid;
      final noteDocument = await _firestore.collection('users').doc(userId).collection('notes').doc(widget.noteId).get();

       DateTime _timestamp = DateTime.now(); // Default value

      if (noteDocument.exists && noteDocument.data()!.containsKey('timestamp')) {
        _timestamp = noteDocument['timestamp']?.toDate();
      }

      var formattedTimestamp = DateFormat.yMMMMd().format(_timestamp);

      setState(() {
        timestamp = formattedTimestamp;
      });

      if (noteDocument.exists) {
        setState(() {
          _titleController.text = noteDocument['title'];
          _descController.text = noteDocument['description'];
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 126, 180, 250),
      appBar: AppBar(
        title: Text(
          timestamp,
          style: GoogleFonts.openSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 15,
          right: 15,
          bottom: 30,
        ),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Judul Catatan',
                hintStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Isi catatan',
                  hintStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  color: Colors.white,
                ),
                maxLines: null,
              ),
            ),
            TextButton(
              onPressed: () async {
              // Get the current user ID
              final currentUser = _auth.currentUser;
              if (currentUser != null) {
                final userId = currentUser.uid;

                if (widget.noteId != null) {
                  // Check if the document exists before updating
                  final docSnapshot = await _firestore.collection('users').doc(userId).collection('notes').doc(widget.noteId).get();

                  if (docSnapshot.exists) {
                    // Update existing note
                    _firestore.collection('users').doc(userId).collection('notes').doc(widget.noteId).update({
                      'title': _titleController.text,
                      'description': _descController.text,
                    });
                  } else {
                    // Handle the case where the document does not exist
                    _firestore.collection('users').doc(userId).collection('notes').add({
                      'title': _titleController.text,
                      'description': _descController.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    // You can choose to create a new document or take other actions based on your app's logic.
                  }
                } else {
                  // Save the note to the user's notes collection
                  _firestore.collection('users').doc(userId).collection('notes').add({
                    'title': _titleController.text,
                    'description': _descController.text,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                }

                Navigator.pop(context);
              }
            },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Simpan Catatan',
                style: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 126, 180, 250),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
