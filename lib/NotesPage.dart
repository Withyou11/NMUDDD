// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:intl/intl.dart';
import 'package:english_study_app/EditNotePage.dart';
import 'package:english_study_app/NoteDetailPage.dart';

import 'Bottom_Navigation.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class NotePageModel {
  String? title;
  DateTime? dateCreate;
  String? id;

  NotePageModel({this.title, this.dateCreate, this.id});

  factory NotePageModel.fromMap(map) {
    return NotePageModel(title: map['title'], dateCreate: map['time'].toDate());
  }
}

class _NotesPageState extends State<NotesPage> {
  User? user = FirebaseAuth.instance.currentUser;
  late List<NotePageModel> listNote = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    LoadNote();
  }

  Future LoadNote() async {
    setState(() => isLoading = true);

    listNote.clear();
    await FirebaseFirestore.instance
        .collection('notes')
        .where("uid", isEqualTo: user?.uid.toString())
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        NotePageModel obj = NotePageModel.fromMap(doc.data());
        obj.id = doc.id;
        listNote.add(obj);
      });
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NavigationBottom()));
                    },
                    child: Container(child: const Icon(Icons.arrow_back)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      right: 20,
                    ),
                    child: const Text(
                      'My Notes',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : listNote.isEmpty
                          ? Text(
                              'No Notes',
                              style: TextStyle(
                                  color: Color.fromRGBO(13, 209, 33, 1),
                                  fontSize: 24),
                            )
                          : buildNotes(),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromRGBO(13, 209, 33, 1),
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );
            // refreshNotes();
            setState(() {
              LoadNote();
            });
          },
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(8),
        itemCount: listNote.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          final note = listNote[index];

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailPage(noteId: note.id!),
              ));

              setState(() {
                LoadNote();
              });
            },
            child: NoteCardWidget(note: note, index: index),
          );
        },
      );
}

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final NotePageModel note;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.dateCreate!);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 4),
            Text(
              note.title.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
