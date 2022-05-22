import 'package:audioplayers/audioplayers.dart';
import 'package:english_study_app/Game/GuessWord/GuessWord.dart';
import 'package:english_study_app/Game/GuessWord/HomeGame.dart';
import 'Storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';


class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool? isLoading;
  @override
  void initState() {
    super.initState();
    print(Storage.uid);
    Storage.listDataTopic.clear();
    Storage.countQuestion = 0;
    loadData();
  }

  @override
  Future loadData() async {
    setState(() => isLoading = true);
    
    await FirebaseFirestore.instance
        .collection('DataMenu')
        .where('uid', isEqualTo: Storage.uid)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print(doc.id);
        DataTopic obj = DataTopic.fromMap(doc.data());
        obj.doc=doc.id;
        Storage.listDataTopic.add(obj);
      });
    });
    
    for(int i=0;i< Storage.listDataTopic.length;i++){
      int count = 0;
      await FirebaseFirestore.instance
        .collection( Storage.listDataTopic[i].name)
        .get()
        .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) { 
        count++;
        Storage.listDataTopic[i].maxQuestion = count;
        });
    });
    for(int i=0;i< Storage.listDataTopic.length;i++){
        await FirebaseFirestore.instance
          .collection('DataMenu')
          .doc(Storage.listDataTopic[i].doc)
          .update({'maxQuestion': Storage.listDataTopic[i].maxQuestion})
          .then((_) => print('Updated'))
          .catchError((e) => print(e));
    }
    setState(() => isLoading = false);
  }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
         Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeGame()));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Choose Topic to Practice'),
            backgroundColor: Colors.green,
          ),
          body: isLoading!
              ? const Center(child: CircularProgressIndicator())
              : listData()),
    );
  }

  Widget listData() => SingleChildScrollView(
        child: Column(
          children: Storage.listDataTopic.map((e) {
            return Container(
              margin: const EdgeInsets.only(top: 10, left: 50, right: 50),
              decoration: BoxDecoration(
                color: Storage.color1,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 2,
                      color: Colors.green,
                    ),
                  ),
              child: RawMaterialButton(
                onPressed: () async {
                  if (e.completedQuestion != e.maxQuestion) {
                    Storage.list.clear();
                    bool isGo = false;
                    Storage.chooseGame = e.name;
                    print(Storage.list.length);
                    await FirebaseFirestore.instance
                        .collection(Storage.chooseGame)
                        .get()
                        .then((QuerySnapshot snapshot) {
                      snapshot.docs.forEach((doc) {
                        QuestionData obj = QuestionData.fromMap(doc.data());
                        obj.doc = doc.id;
                        if (!check(obj)) {
                          Storage.list.add(obj);
                        }
                      });
                    });
                    Storage.maxQuestion=Storage.list.length;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GuessWord()));
                  }
                  else{
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      text: "You passed this topic",
                      backgroundColor: Colors.amber,
                      confirmBtnColor: Colors.green,
                    );
                    AudioCache().play('audio/completed.mp3');
                  }
                },
                  child: Center(
                      child: Column(
                    children: [
                      Center(
                        child: Image.network(
                          e.image,
                          fit: BoxFit.cover,
                          height: 150,
                          width: 150,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          e.name.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          e.completedQuestion.toString() +
                              '/' +
                              e.maxQuestion.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )),
                ),
              
            );
          }).toList(),
        ),
      );
}

class DataMenu {}

class DataTopic {
  String? doc;
  String name;
  int completedQuestion;
  int maxQuestion;
  String image;
  String uid;
  DataTopic(
      {required this.name,
      required this.completedQuestion,
      required this.maxQuestion,
      required this.image,
      required this.uid});

  factory DataTopic.fromMap(map) {
    return DataTopic(
        name: map['name'],
        completedQuestion: map['completedQuestion'],
        maxQuestion: map['maxQuestion'],
        image: map['image'],
        uid: map['uid']);
  }
}

bool check(QuestionData obj) {
  for (int i = 0; i < obj.listUser!.length; i++) {
    if (obj.listUser![i] == Storage.uid) {
      return true;
    }
  }
  return false;
}
