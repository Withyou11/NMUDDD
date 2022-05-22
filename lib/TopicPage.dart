import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Bottom_Navigation.dart';
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

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
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
                            builder: (context) => const NavigationBottom()));
                  },
                  child: Container(child: const Icon(Icons.arrow_back)),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 20,
                  ),
                  child: const Text(
                    'Topic',
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
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : listTopic.isEmpty
                          ? ListTopicEmpty()
                          : ListTopic()),
            ),
          ]),
    )));
  }

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

  Widget ListTopic() => ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
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
                        Button_nextDetail(topic: topic),
                        Text(
                          'View now',
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
}

class Button_nextDetail extends StatelessWidget {
  const Button_nextDetail({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final TopicModel topic;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ListVocabularyPage(
                image: topic.image,
                topicEng: topic.topicEng,
                topicID: topic.topicID)));
      },
      child: Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8)),
          child: const Image(
            image: AssetImage(
              "assets/images/next.png",
            ),
          )),
    );
  }
}
