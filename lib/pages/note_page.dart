// ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';

import 'package:parentopia/pages/pages.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  var color =const Color.fromARGB(246, 126, 180, 250);
  var textColor = Colors.white;

  final _auth = FirebaseAuth.instance;
  late CollectionReference<Map<String, dynamic>> userNotesCollection;

  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    // Initialize the user's notes collection
    String? userId = _auth.currentUser?.uid;
    userNotesCollection =
        FirebaseFirestore.instance.collection('users').doc(userId).collection('notes');
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserNotes() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await userNotesCollection
    .orderBy('timestamp', descending: true)  // Add this line to order by timestamp in ascending order
    .get();
    return querySnapshot.docs;
  }

  Future<void> _refresh() async {
    // Perform the refreshing logic here, e.g., fetch the latest notes
    List<QueryDocumentSnapshot<Map<String, dynamic>>> refreshedNotes =
      await getUserNotes();

    setState(() {
      // Update the state or fetch new data
      refreshedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        color: color,
        key: _refreshKey,
        onRefresh: _refresh,
        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
          future: getUserNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: color),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 150.0),
                      child: Center(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/Note_figure_1.png",
                              width: 250,
                            ),
                            Text(
                              "Ayo tinggalkan jejak kebahagiaan\n keluarga kita di Parentopia!",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );

            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> notes = snapshot.data!;
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: false,
                    elevation: 0,
                    backgroundColor: Colors.white,
                    expandedHeight: 100.0,
                    leading: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded
                      ),
                      color: Colors.black,
                      onPressed: () {
                        Navigator.pop(context);
                    }),
                        
                    flexibleSpace: Center(
                      child: Text(
                        "Your Journey",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var noteData = notes[index].data();
                        var timestamp = noteData['timestamp']?.toDate() ?? DateTime.now();
                        // Format the timestamp
                        var formattedTimestamp = DateFormat.yMMMMd().format(timestamp);
        
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 0.5,
                                                blurRadius: 1,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            color: color,
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          width: MediaQuery.of(context).size.width,
                                          height: 100,
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => NoteDetailsPage(
                                                    noteId: notes[index].id, // Pass the ID of the note
                                                    title: noteData['title'],
                                                    description: noteData['description'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 20.0,
                                                right: 10.0,
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        noteData['title'],
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 15,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      Text(
                                                        ((noteData['description']).length <= 35)
                                                        ? (noteData['description'])
                                                        : (noteData['description']).substring(0, 35) + '...',
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize: 12,
                                                          color: textColor
                                                        ),
                                                      ),
                                                      Text(
                                                        formattedTimestamp,
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: 11,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      const SizedBox(),
                                                      IconButton(
                                                        padding: const EdgeInsets.all(0),
                                                        icon: const Icon(IconlyBold.delete),
                                                        iconSize: 17,
                                                        color: textColor,
                                                        onPressed: () async {
                                                          // Add your logic here to delete the note
                                                          var noteReference = userNotesCollection.doc(notes[index].id);
                                                          await noteReference.delete();
                                                          setState(() {
                                                            // Assuming notes is a List in the state
                                                            notes.removeAt(index);
                                                          });
                                                          log("Delete button pressed");
                                                        },
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      childCount: notes.length,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: color,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteDetailsPage(
                noteId: DateTime.now().millisecondsSinceEpoch.toString(), // Use timestamp as noteId
                title: "", // You can provide default values or leave them empty for a new note
                description: "",
              ),
            ),
          );
        },
        child: const Icon(
          IconlyBold.plus,
          color: Colors.white,
        ),
      ),
    );
  }
}
