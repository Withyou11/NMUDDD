import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:typed_data';

import 'Topic_Screen_Admin.dart';
import 'VocabularyManager.dart';

class TopicModel {
  String? image;
  String? topicEng;
  String? topicVie;
  String? topicID;

  TopicModel({this.image, this.topicEng, this.topicVie, this.topicID});

  factory TopicModel.fromMap(map) {
    return TopicModel(
        image: map['image'],
        topicEng: map['topicEng'],
        topicVie: map['topicVie']);
  }
}

class FirebaseUpload extends StatefulWidget {
  final String? topicID;
  const FirebaseUpload({Key? key, required this.topicID}) : super(key: key);

  @override
  _FirebaseUploadState createState() => _FirebaseUploadState();
}

class _FirebaseUploadState extends State<FirebaseUpload> {
  UploadTask? task;
  File? file;
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _topicEngController = TextEditingController();
  final TextEditingController _topicVieController = TextEditingController();
  String url = '';
  String topicID = '';
  bool isLoading = false;
  late TopicModel item = TopicModel(
    image: '',
    topicEng: '',
    topicVie: '',
    topicID: '',
  );
  @override
  void initState() {
    super.initState();
    getTopic();
  }

  Future getTopic() async {
    setState(() => isLoading = true);
    await FirebaseFirestore.instance
        .collection('topic')
        .doc(widget.topicID)
        .get()
        .then((value) {
      this.item = TopicModel.fromMap(value.data());
    }).catchError((err) {
      print('Failure to get data');
    });

    setState(() => {
          _topicEngController.text = item.topicEng.toString(),
          _topicVieController.text = item.topicVie.toString(),
          _imageController.text = item.image.toString(),
          isLoading = false
        });
  }

  Future<void> updateTopic(
      BuildContext context, String image, String topicEng, String topicVie) {
    final doc =
        FirebaseFirestore.instance.collection('topic').doc(widget.topicID);
    return doc
        .update({
          'image': image,
          'topicEng': topicEng,
          'topicVie': topicVie,
        })
        .then((value) => showNotifi(context, "Update topic successfully!"))
        .catchError((e) => print("Failed to update: $e"));
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
                                      const TopicPageAdmin()));
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: const Text(
                          'Topic manager',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: const Color.fromRGBO(13, 209, 33, 1),
                    margin: EdgeInsets.only(left: 10, right: 10),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ButtonWidget(
                          text: 'Select File',
                          icon: Icons.attach_file,
                          onClicked: selectFile,
                        ),
                        SizedBox(height: 8),
                        Text(
                          fileName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),
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
                              'TopicEng',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _topicEngController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: 'Enter TopicEng',
                              hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.black),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'TopicVie',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _topicVieController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: 'Enter TopicVie',
                              hintStyle:
                                  TextStyle(fontSize: 16, color: Colors.black),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Text(
                              'List Vocabulary',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 175,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(8)),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VocabularyManager(
                                            check: true,
                                            topicID: widget.topicID,
                                          )));
                                },
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 243, 242, 242),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('Go to list',
                                            style: TextStyle(fontSize: 16)),
                                        Image(
                                          image: AssetImage(
                                              "assets/images/next.png"),
                                          width: 30,
                                          height: 30,
                                        ),
                                      ],
                                    )),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          showWarningNotifi(context, item);
                                          // setState(() {
                                          //   getTopic();
                                          // });
                                        },
                                        child: Container(
                                            width: 70,
                                            height: 50,
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Image(
                                              image: AssetImage(
                                                  "assets/images/trash.png"),
                                              width: 40,
                                              height: 40,
                                            ))),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Delete Topic',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(137, 136, 136, 1)),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          updateTopic(
                                              context,
                                              _imageController.text,
                                              _topicEngController.text,
                                              _topicVieController.text);
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 50,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
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
                                      'Update',
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

  void DeleteTopic(BuildContext context, TopicModel item) {
    FirebaseFirestore.instance
        .collection('vocabulary')
        .where("topicID", isEqualTo: widget.topicID.toString())
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });

    FirebaseFirestore.instance
        .collection('topic')
        .doc(widget.topicID)
        .delete()
        .then((value) => showSuccessNotifi(context))
        .catchError((err) => print(err.toString()));
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
      content: const Text('A Topic is removed.'),
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

  showWarningNotifi(BuildContext context, TopicModel item) {
    Widget noButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('No'),
    );

    Widget yesButton = TextButton(
      onPressed: () {
        DeleteTopic(context, item);
        setState(() {
          // getTopic();
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TopicPageAdmin()));
        });
      },
      child: Text('Yes'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Warning!',
          style: TextStyle(color: Color.fromRGBO(255, 236, 66, 1))),
      content:
          const Text('Do you want to remove this Topic and its Vocabulary?'),
      actions: [
        yesButton,
        noButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

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
