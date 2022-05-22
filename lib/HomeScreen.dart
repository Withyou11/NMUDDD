import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/FlashCardManager.dart';
import 'package:english_study_app/FlashCardScreen.dart';
// import 'package:english_study_app/Game/GuessWord/HomeGame.dart';
import 'package:english_study_app/LoginScreen.dart';
import 'package:english_study_app/NotesPage.dart';
import 'package:english_study_app/SignUpScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'Bottom_Navigation.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'Game/GuessWord/HomeGame.dart';
import 'Game/GuessWord/Storage.dart';
import 'History_Storage.dart';
import 'TopicPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tạo đối tượng Authentication:
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  //
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  String? selectLanguage1;
  String? selectLanguage2;
  final translator = GoogleTranslator();
  String? value;
  final items = ["Tiếng Việt", "English"];
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ));
  _translateLang() {
    String s1 = "en";
    String s2 = "vi";
    if (selectLanguage1 == "Tiếng Việt" && selectLanguage2 == "Tiếng Việt") {
      s1 = "vi";
      s2 = "vi";
    } else if (selectLanguage1 == "English" && selectLanguage2 == "English") {
      s1 = "en";
      s2 = "en";
    } else if (selectLanguage1 == "Tiếng Việt" &&
        selectLanguage2 == "English") {
      s1 = "vi";
      s2 = "en";
    } else {
      s1 = "en";
      s2 = "vi";
    }
    if (fromController.toString().isNotEmpty ||
        fromController.toString() == "") {
      translator
          .translate(fromController.text, from: s1, to: s2)
          .then((result) {
        setState(() {
          toController.text = result.toString();
        });
        addSearchedtoStorage(fromController.text, toController.text);
      });
    }
  }

  Future<void> addSearchedtoStorage(String fromSearch, String toSearch) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference addStorage =
        FirebaseFirestore.instance.collection('searched');
    return addStorage.add({
      'uid': user?.uid,
      'fromSearch': fromSearch,
      'toSearch': toSearch,
      'timeSearch': DateTime.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 213, 235, 247),
        body: SafeArea(
            child: Stack(children: <Widget>[
          //insert image background
          Container(
            height: 380,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [
                    0.1,
                    0.9
                  ],
                  colors: [
                    Color.fromRGBO(13, 209, 33, 1),
                    Color.fromRGBO(255, 236, 66, 1)
                  ]),
            ),
          ),
          //insert icon logout
          SafeArea(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Logout currentUser
                          signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
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
                      const SizedBox(
                        width: 40,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          child: TextField(
                            controller: fromController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Enter Text',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 8, 15, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintStyle: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) =>
                                setState(() => toController.text = ""),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: TextField(
                            controller: toController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'translated Text',
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 8, 15, 5),
                              fillColor: const Color.fromRGBO(243, 237, 237, 1),
                              filled: true,
                              hintStyle: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) =>
                                setState(() => toController.text = ""),
                          ),
                        ),
                        const SizedBox(height: 10),
                        //Option tranlate
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(18, 27, 240, 1),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, right: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectLanguage1,
                                    items: items.map(buildMenuItem).toList(),
                                    onChanged: (value) =>
                                        setState(() => selectLanguage1 = value),
                                    hint: const Text(
                                      "English",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _translateLang,
                              child: Container(
                                width: 80,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(4, 18),
                                          blurRadius: 17,
                                          spreadRadius: -10,
                                          color: Color.fromARGB(
                                              255, 110, 107, 104))
                                    ]),
                                child: const Icon(
                                  Icons.compare_arrows_rounded,
                                  size: 46,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(18, 27, 240, 1),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 14, right: 4),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectLanguage2,
                                    items: items.map(buildMenuItem).toList(),
                                    onChanged: (value) =>
                                        setState(() => selectLanguage2 = value),
                                    hint: const Text(
                                      "Tiếng Việt",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        //
                        Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 14.0,
                                mainAxisSpacing: 14.0,
                                children: <Widget>[
                              CategoryCard(
                                pathImg: "assets/images/game.png",
                                title: "Play game",
                                Press: () async {
                                   await FirebaseFirestore.instance
                                      .collection('Rank')
                                      .where('uid', isEqualTo: Storage.uid)
                                      .get()
                                      .then((QuerySnapshot snapshot) {
                                    snapshot.docs.forEach((doc) {
                                      Storage.doc = doc.id;
                                      Score obj = Score.fromMap(doc.data());
                                      Storage.score = obj.score;
                                      Storage.time = obj.time;
                                    });
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomeGame()),
                                  );
                                },
                              ),
                              CategoryCard(
                                pathImg: "assets/images/flash_card.png",
                                title: "Flash card",
                                Press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FlashCardScreen()),
                                  );
                                },
                              ),
                              CategoryCard(
                                pathImg: "assets/images/topic.png",
                                title: "Topic",
                                Press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const TopicPage()),
                                  );
                                },
                              ),
                              CategoryCard(
                                pathImg: "assets/images/note.png",
                                title: "Note",
                                Press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NotesPage()),
                                  );
                                },
                              ),
                              CategoryCard(
                                pathImg: "assets/images/library.png",
                                title: "My Library",
                                Press: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyStoragePage()),
                                  );
                                },
                              ),
                            ]))
                        //
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ])));
  }

  signOut() async {
    await _firebaseAuth.signOut();
  }
}

class CategoryCard extends StatelessWidget {
  final pathImg;
  final title;
  final Press;
  const CategoryCard({
    Key? key,
    this.pathImg,
    this.title,
    this.Press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        //  ClipRRect(
        // borderRadius: BorderRadius.circular(8),
        // child:
        Container(
      // padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 248, 245, 245),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
                offset: Offset(4, 18),
                blurRadius: 17,
                spreadRadius: -10,
                color: Color.fromARGB(255, 110, 107, 104))
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: Press,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Image(
                    image: AssetImage(pathImg),
                    width: 120,
                    height: 120,
                    alignment: Alignment.center),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
      // ),
    );
  }
}
