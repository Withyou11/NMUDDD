import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/NotesPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:english_study_app/NoteDetailPage.dart';


class AddEditNotePage extends StatefulWidget {
  final NoteModel? note;

  const AddEditNotePage({
    Key? key, 
    this.note,
    //this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}


class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late String id;

  @override
  void initState() {
    super.initState();

    title = widget.note?.title ?? '';
    description = widget.note?.des ?? '';
    id = widget.note?.id ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
          iconTheme: IconThemeData(color: Color.fromRGBO(13, 209, 33, 1)),
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            title: title,
            description: description,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Color.fromRGBO(13, 209, 33, 1) : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) =>
    NotesPage()));
  }
  }

  Future<void> updateNote() {
    CollectionReference updateNote =
        FirebaseFirestore.instance.collection('notes');
    return updateNote.doc(widget.note?.id).update
        ({
          'title': title,
          'des': description,
          'time': DateTime.now()
        })
        .then((value) => print('Update successfully!'))
        .catchError((e) => print("Failed to update"));
  }

  showSuccessNotifi(BuildContext context) {
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('OK',
          style: TextStyle(color: Color.fromRGBO(13, 209, 33, 1))),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Successfully!',
          style: TextStyle(color: Color.fromRGBO(13, 209, 33, 1))),
      content: const Text('This note is removed out of your note list.'),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Future addNote() async {
    FirebaseFirestore ref = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference addStorage = FirebaseFirestore.instance.collection('notes');

    return addStorage.add({
      'uid': user?.uid,
      'title': title,
      'des': description,
      'time': DateTime.now()
    });
  }
}

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 16),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(color: Colors.black),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );
}
