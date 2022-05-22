import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/GameDataTopic.dart';
import 'package:english_study_app/GameTopicAdmin.dart';
import 'package:english_study_app/Topic_Screen_Admin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

class AddDataTopicGame extends StatefulWidget {
  const AddDataTopicGame({Key? key, required this.nameDoc }) : super(key: key);
  final String? nameDoc;
  @override
  State<AddDataTopicGame> createState() => _AddDataTopicGameState();
}

class _AddDataTopicGameState extends State<AddDataTopicGame> {
  final TextEditingController _answerController = TextEditingController();
  UploadTask? task;
  File? file;
  String url = '';
  List<String>? listUser = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> addTopic(
      BuildContext context, String image, String answer, List<String>? list) {
    return FirebaseFirestore.instance
        .collection(widget.nameDoc!).add({
      'answer': answer,
      'image': image,
      'listUser': list,
    }).then((doc) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GameDataTopic(nameId: widget.nameDoc!,)));
    })
        // .then((value) => showNotifi(context, "Add Topic successfully!"))
        .catchError((e) => print("Failed to add: $e"));
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'No File Selected';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SizedBox(
          height: size.height,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GameDataTopic(
                                        nameId: widget.nameDoc!,
                                      )));
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: const Text(
                          'Add Data GameTopic manager',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: const Color.fromRGBO(13, 209, 33, 1),
                    margin: const EdgeInsets.only(left: 10, right: 10),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ButtonWidget(
                          text: 'Select File',
                          icon: Icons.attach_file,
                          onClicked: selectFile,
                        ),
                        SizedBox(height: 20),
                        Text(
                          fileName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        ButtonWidget(
                          text: 'Upload File',
                          icon: Icons.cloud_upload_outlined,
                          onClicked: uploadFile,
                        ),
                        const SizedBox(height: 20),
                        task != null ? buildUploadStatus(task!) : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'Answer For Image',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _answerController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: 'Enter answer for image',
                              hintStyle: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(255, 236, 66, 1),
                                ),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Colors.black,
                                ),
                              )),
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 6),
                        SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          if (url != '' &&
                                              _answerController.text != '') {
                                            addTopic(context, url,
                                                _answerController.text, listUser);
                                          } else {
                                            showNotifi(context,
                                                'Please enter enough information');
                                          }
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 50,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  13, 209, 33, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                              Icons.download_done_outlined,
                                              color: Colors.white,
                                              size: 40),
                                        )),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Add',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(137, 136, 136, 1)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget Separate(double left, double right) => Container(
        margin: EdgeInsets.fromLTRB(left, 0, right, 0),
        height: 5,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(13, 209, 33, 1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 4,
                  spreadRadius: -4,
                  color: Color.fromARGB(255, 110, 107, 104))
            ]),
      );

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    url = urlDownload.toString();
    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
  showNotifi(BuildContext context, String content) {
    Widget okButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('OK',
          style: TextStyle(color: Color.fromRGBO(13, 209, 33, 1))),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Notice',
          style: TextStyle(color: Color.fromRGBO(13, 209, 33, 1))),
      content: Text(content),
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
}

class ButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.icon,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(29, 194, 95, 1),
          minimumSize: Size.fromHeight(50),
        ),
        child: buildContent(),
        onPressed: onClicked,
      );

  Widget buildContent() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          SizedBox(width: 16),
          Text(
            text,
            style: TextStyle(fontSize: 22, color: Colors.white),
          ),
        ],
      );
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
