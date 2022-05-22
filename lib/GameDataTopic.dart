import 'package:english_study_app/AddDataTopicGame.dart';
import 'package:english_study_app/AddTopicGameManager.dart';
import 'package:english_study_app/FirebaseUpload.dart';
import 'package:english_study_app/GameTopicAdmin.dart';
import 'package:english_study_app/TopicManager_Create_Admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Bottom_Navigation.dart';
import 'Bottom_Navigation_Admin.dart';
import 'HomeScreen_Admin.dart';
import 'ListVocabularyPage.dart';

class GameData {
  String? image;
  String? answer;
  String? id;

  GameData({this.image,this.answer});

  factory GameData.fromMap(map) {
    return GameData(image: map['image'], answer: map['answer']);
  }
}

class GameDataTopic extends StatefulWidget {
  const GameDataTopic({Key? key, required this.nameId}) : super(key: key);
  final String? nameId;
  @override
  State<GameDataTopic> createState() => _GameDataTopicState();
}

class _GameDataTopicState extends State<GameDataTopic> {
  late List<GameData> listTopic = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    reLoadTopic();
  }

  @override
  Future reLoadTopic() async {
    setState(() => isLoading = true);
    await FirebaseFirestore.instance
        .collection(widget.nameId!)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        GameData obj = GameData.fromMap(doc.data());
        obj.id = doc.id;
        listTopic.add(obj);
      });
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const GameTopicAdmin()));
                  },
                  child: Container(child: const Icon(Icons.arrow_back)),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: const Text(
                    'DataTopic manager',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Text(
                        'List Data of ' + widget.nameId!,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 3,
                        width: 64,
                        color: const Color.fromRGBO(13, 209, 33, 1),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.black54,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : listTopic.isEmpty
                                ? ListTopicEmpty()
                                : Column(
                                    children: [
                                      Expanded(flex: 1, child: ListTopic()),
                                      Column(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black54,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                'New Topic',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                             AddDataTopicGame(nameDoc: widget.nameId!,)));
                                                },
                                                child: const Image(
                                                    image: AssetImage(
                                                        "assets/images/plus.png")),
                                                style: ElevatedButton.styleFrom(
                                                  shape: CircleBorder(),
                                                  padding: EdgeInsets.all(20),
                                                  primary: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                      ),
                    ],
                  )),
            ),
          ]),
    )));
  }

  Widget ListTopic() => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listTopic.length,
        itemBuilder: (context, index) {
          final topic = listTopic[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: SizedBox.fromSize(
                              child: Image.network(topic.image.toString(),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.answer.toString(),
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          );
        },
      );

  Widget ListTopicEmpty() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Column(
              children:  [
                const Text(
                  'List topic is Empty',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(13, 209, 33, 1),
                      fontWeight: FontWeight.bold),
                ),
                const Text(
                  '"(^-^)"',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(13, 209, 33, 1),
                      fontWeight: FontWeight.bold),
                ),
              const SizedBox(
                  height: 450,
                ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'New DataTopic',
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AddDataTopicGame(
                                  nameDoc: widget.nameId!,
                                )));
                      },
                      child: const Image(
                          image: AssetImage("assets/images/plus.png")),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        primary: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
