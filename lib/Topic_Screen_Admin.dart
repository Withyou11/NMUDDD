import 'package:english_study_app/FirebaseUpload.dart';
import 'package:english_study_app/TopicManager_Create_Admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Bottom_Navigation.dart';
import 'Bottom_Navigation_Admin.dart';
import 'HomeScreen_Admin.dart';
import 'ListVocabularyPage.dart';

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

class TopicPageAdmin extends StatefulWidget {
  const TopicPageAdmin({Key? key}) : super(key: key);

  @override
  State<TopicPageAdmin> createState() => _TopicPageAdminState();
}

class _TopicPageAdminState extends State<TopicPageAdmin> {
  late List<TopicModel> listTopic = [];
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
        .collection('topic')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        TopicModel obj = TopicModel.fromMap(doc.data());
        obj.topicID = doc.id;
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
                                const NavigationBottomAdmin()));
                  },
                  child: Container(child: const Icon(Icons.arrow_back)),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: const Text(
                    'Topic manager',
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
                      const Text(
                        'List Topic',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
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
                                                              TopicManagerCreateAdmin()));
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
                            color: Colors.black,
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
                                topic.topicEng.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                topic.topicVie.toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade600),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    FirebaseUpload(topicID: topic.topicID)));
                          },
                          child: Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 243, 242, 242),
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Color.fromRGBO(13, 209, 33, 1),
                              )),
                        ),
                        Text(
                          'Manager',
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade300),
                        )
                      ],
                    )
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
              children: const [
                Text(
                  'List topic is Empty',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(13, 209, 33, 1),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '"(^-^)"',
                  style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(13, 209, 33, 1),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      );
}
