import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/HomeScreen.dart';
import 'package:english_study_app/TopicManager_Create_Admin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:typed_data';

import 'FirebaseUpload.dart';

class VocaModel {
  String? vocaEng;
  String? vocaVie;
  String? type;
  String? id;

  VocaModel({this.vocaEng, this.vocaVie, this.type, this.id});

  factory VocaModel.fromMap(map) {
    return VocaModel(
        vocaEng: map['vocaEng'], vocaVie: map['vocaVie'], type: map['type']);
  }
}

class VocabularyManager extends StatefulWidget {
  final bool? check;
  final String? topicID;
  const VocabularyManager({
    Key? key,
    required this.check,
    required this.topicID,
  }) : super(key: key);

  @override
  State<VocabularyManager> createState() => _VocabularyManagerState();
}

class _VocabularyManagerState extends State<VocabularyManager> {
  bool _visibilityEdit = false;
  bool _visibilityAdd = true;
  final TextEditingController _vocaEngController = TextEditingController();
  final TextEditingController _vocaVieController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  List<VocaModel> listVoca = [];
  bool isLoading = false;
  String vocaID = '';

  @override
  void initState() {
    super.initState();
    reLoadVoca();
  }

  Future<void> addVoca(BuildContext context, String vocaEng, String vocaVie,
      String type, String topicID) {
    CollectionReference addStorage =
        FirebaseFirestore.instance.collection('vocabulary');
    return addStorage.add({
      'vocaEng': vocaEng,
      'vocaVie': vocaVie,
      'type': type,
      'topicID': topicID
    }).then((value) {
      _vocaEngController.text = '';
      _vocaVieController.text = '';
      _typeController.text = '';
      showNotifi(context, "Add Vocabulary successfully!");
    }).catchError((e) => print("Failed to add: $e"));
  }

  Future<void> updateVoca(BuildContext context, String vocaEng, String vocaVie,
      String type, String vocaID) {
    _visibilityAdd = true;
    _visibilityEdit = false;
    _vocaEngController.text = '';
    _vocaVieController.text = '';
    _typeController.text = '';
    final doc = FirebaseFirestore.instance
        .collection('vocabulary')
        .doc(vocaID.toString());
    return doc.update(
        {'vocaEng': vocaEng, 'vocaVie': vocaVie, 'type': type}).then((value) {
      vocaID = '';
      showNotifi(context, "Update Vocabulary successfully!");
    }).catchError((e) => print("Failed to update: $e"));
  }

  Future reLoadVoca() async {
    setState(() => isLoading = true);

    listVoca.clear();
    await FirebaseFirestore.instance
        .collection('vocabulary')
        .where("topicID", isEqualTo: widget.topicID.toString())
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        VocaModel obj = VocaModel.fromMap(doc.data());
        obj.id = doc.id;
        listVoca.add(obj);
      });
    });
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('List Vocabulary',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          width: double.infinity,
                          height: 300,
                          child: 
                          // listVoca.isEmpty
                          //     ? const Center(
                          //         child: Text('List vocabulary is Empty',
                          //             style: TextStyle(
                          //                 color: Color.fromRGBO(13, 209, 33, 1),
                          //                 fontSize: 18)))
                          //     : 
                              Listvoca(),
                          // child: ,
                        ),
                        const Text('Form:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        TextField(
                          controller: _vocaEngController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: 'Insert VocaEng',
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
                        SizedBox(height: 10),
                        TextField(
                          controller: _vocaVieController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: 'Insert VocaVie',
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
                        const SizedBox(height: 10),
                        TextField(
                          controller: _typeController,
                          decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintText: 'Insert type',
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
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Stack(
                              children: [
                                Visibility(
                                  visible: _visibilityEdit,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            updateVoca(
                                                context,
                                                _vocaEngController.text,
                                                _vocaVieController.text,
                                                _typeController.text,
                                                vocaID);
                                            setState(() {
                                              reLoadVoca();
                                            });
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
                                            color: Color.fromRGBO(
                                                137, 136, 136, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: _visibilityAdd,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            if (_vocaEngController.text != '' &&
                                                _vocaVieController.text != '' &&
                                                _typeController.text != '') {
                                              addVoca(
                                                  context,
                                                  _vocaEngController.text,
                                                  _vocaVieController.text,
                                                  _typeController.text,
                                                  widget.topicID.toString());
                                            } else {
                                              showNotifi(context,
                                                  'Please enter enough information');
                                            }
                                            setState(() {
                                              reLoadVoca();
                                            });
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
                                        'Create',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromRGBO(
                                                137, 136, 136, 1)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
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

  Widget Listvoca() => ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: listVoca.length,
        itemBuilder: (context, index) {
          final voca = listVoca[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            voca.vocaEng.toString() +
                                ' (' +
                                voca.type.toString() +
                                ')',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          Text(
                            voca.vocaVie.toString(),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            showWarningNotifi(context, voca);
                            // setState(() {
                            //   reLoadVoca();
                            // });
                          },
                          child: Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Image(
                                image: AssetImage("assets/images/trash.png"),
                                width: 15,
                                height: 15,
                              ))),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(243, 237, 237, 1),
                        ),
                        child: GestureDetector(
                            onTap: () {
                              vocaID = voca.id.toString();
 
                              _visibilityAdd = false;
                              _visibilityEdit = true;
                              _vocaEngController.text = voca.vocaEng!;
                              _vocaVieController.text = voca.vocaVie!;
                              _typeController.text = voca.type!;
                            },
                            child: const Icon(Icons.edit_rounded,
                                color: Color.fromRGBO(13, 209, 33, 1),
                                size: 30)),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
  void DeleteWord(VocaModel item, BuildContext context) {
    FirebaseFirestore.instance
        .collection('vocabulary')
        .doc(item.id)
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
      content: const Text('A Vocabulary is removed.'),
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

  showWarningNotifi(BuildContext context, VocaModel item) {
    Widget noButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('No'),
    );

    Widget yesButton = TextButton(
      onPressed: () {
        DeleteWord(item, context);
        setState(() {
          reLoadVoca();
        });
        Navigator.of(context).pop();
      },
      child: Text('Yes'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Warning!',
          style: TextStyle(color: Color.fromRGBO(255, 236, 66, 1))),
      content: const Text('Do you want to remove this word?'),
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
