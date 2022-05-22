import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:english_study_app/EditNotePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/NotesPage.dart';

class NoteDetailPage extends StatefulWidget {
  final String noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class NoteModel {
  String? title;
  String? des;
  DateTime? dateCreate;
  String? id;

  NoteModel({this.title, this.des, this.dateCreate, this.id});

  factory NoteModel.fromMap(map) {
    return NoteModel(
        title: map['title'], des: map['des'], dateCreate: map['time'].toDate());
  }
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  NoteModel? note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() => isLoading = true);
    LoadNote();
    setState(() => isLoading = false);
  }

  Future LoadNote() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.noteId)
        .get()
        .then((value) {
      {
        this.note = NoteModel.fromMap(value.data());
      }

      this.note?.id = widget.noteId;
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [editButton(), deleteButton()],
          iconTheme: const IconThemeData(color: Color.fromRGBO(13, 209, 33, 1)),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : note == null
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      children: [
                        Text(
                          note!.title.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat.yMMMd().format(note!.dateCreate!),
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note!.des.toString(),
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        )
                      ],
                    ),
                  ),
      );

  Widget editButton() => IconButton(
      icon: Icon(
        Icons.edit_outlined,
        color: Color.fromRGBO(13, 209, 33, 1),
      ),
      onPressed: () async {
        if (isLoading) return;

        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AddEditNotePage(note: note),
        ));

        setState(() {
          LoadNote();
        });
      });

  Widget deleteButton() => IconButton(
        icon: Icon(
          Icons.delete,
          color: Color.fromRGBO(13, 209, 33, 1),
        ),
        onPressed: () {
          DeleteNote(note!);
        },
      );

  void DeleteNote(NoteModel item) {
    FirebaseFirestore.instance
        .collection('notes')
        .doc(item.id)
        .delete()
        .then((value) {
      print('delete success');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => NotesPage()));
    }).catchError((err) => print(err.toString()));
  }
}
