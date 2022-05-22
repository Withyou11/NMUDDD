import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/GameTopicAdmin.dart';
import 'package:english_study_app/LoginScreen.dart';
import 'package:english_study_app/SignUpScreen.dart';
import 'package:english_study_app/Topic_Screen_Admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'Bottom_Navigation.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'FlashCardManager.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  // Tạo đối tượng Authentication:
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  late int topicQuantity;
  late int flashcardQuantity;
  late int vocaQuantity;
  late int gameTopic;
  @override
  void initState() {
    super.initState();
    GetStatistic();
  }

  @override
  Future<void> GetStatistic() async {
    setState(() {
      isLoading = true;
    });
    topicQuantity = await FirebaseFirestore.instance
        .collection('topic')
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.size;
    }).catchError((err) => 0);

    flashcardQuantity = await FirebaseFirestore.instance
        .collection('flashCard')
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.size;
    }).catchError((err) => 0);

    vocaQuantity = await FirebaseFirestore.instance
        .collection('vocabulary')
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.size;
    }).catchError((err) => 0);

    gameTopic =  await FirebaseFirestore.instance
        .collection('getTopicGame')
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.size;
    }).catchError((err) => 0);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                signOut();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.logout),
                              ),
                            ),
                            const Text(
                              'Eudora',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 40)
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(child: Separate(20, 5)),
                          Expanded(child: Separate(5, 5)),
                          Expanded(child: Separate(5, 20))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                'OverView',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: 240,
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(4, 18),
                                        blurRadius: 17,
                                        spreadRadius: -10,
                                        color:
                                            Color.fromARGB(255, 110, 107, 104))
                                  ]),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                            child: blockInOverView(
                                                'Topic', topicQuantity)),
                                        Expanded(
                                            child: blockInOverView(
                                                'Vocabulary', vocaQuantity)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                            child: blockInOverView('Flashcard',
                                                flashcardQuantity)),
                                        Expanded(
                                          child: blockInOverView(
                                                'GameTopic', gameTopic)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(
                                'Manager',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(4, 18),
                                        blurRadius: 17,
                                        spreadRadius: -10,
                                        color:
                                            Color.fromARGB(255, 110, 107, 104))
                                  ]),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TopicPageAdmin()));
                                        },
                                        child: ItemManager('Topic')),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const FlashCardPageAdmin()));
                                        },
                                        child: ItemManager('Flashcard')),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const GameTopicAdmin()));
                                        },
                                        child: ItemManager('GameTopic')),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              ));
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

  Widget blockInOverView(title, content) => Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(13, 209, 33, 1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(4, 18),
                  blurRadius: 17,
                  spreadRadius: -10,
                  color: Color.fromARGB(255, 110, 107, 104))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(255, 236, 66, 1)),
            ),
            Container(
              height: 1,
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(15, 4, 15, 0),
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                content.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );

  Widget ItemManager(title) => Container(
        height: 50,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 211, 105),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(4, 18),
                  blurRadius: 17,
                  spreadRadius: -10,
                  color: Color.fromARGB(255, 110, 107, 104))
            ]),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 50,
            height: double.maxFinite,
            decoration: const BoxDecoration(
                color: Color.fromRGBO(13, 209, 33, 1),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8))),
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 35,
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Text(
                    title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 4),
                      child: Text(
                        'Manager',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ]),
      );
  signOut() async {
    await _firebaseAuth.signOut();
  }
}
