import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Bottom_Navigation.dart';
import 'TopicPage.dart';

class VocaModel {
  String? vocaEng;
  String? vocaVie;
  String? type;

  VocaModel({this.vocaEng, this.vocaVie, this.type});

  factory VocaModel.fromMap(map) {
    return VocaModel(
        vocaEng: map['vocaEng'], vocaVie: map['vocaVie'], type: map['type']);
  }
}

class ListVocabularyPage extends StatefulWidget {
  final String? image;
  final String? topicEng;
  final String? topicID;
  const ListVocabularyPage({
    Key? key,
    required this.image,
    required this.topicEng,
    required this.topicID,
  }) : super(key: key);

  @override
  State<ListVocabularyPage> createState() => _ListVocabularyPageState();
}

class _ListVocabularyPageState extends State<ListVocabularyPage> {
  List<VocaModel> listVoca = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    reLoadVoca();
  }

  @override
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
        listVoca.add(obj);
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
                                      builder: (context) => const TopicPage()));
                            },
                            child:
                                Container(child: const Icon(Icons.arrow_back)),
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
                      Center(
                        child: Text(
                          widget.topicEng.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.black54,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(child: ImageTopic()),
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : listVoca.isEmpty
                                    ? ListVocaEmpty()
                                    : Listvoca()),
                      ),
                    ]))));
  }

  Widget ImageTopic() => Container(
        height: 140,
        width: 140,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(widget.image.toString(), fit: BoxFit.cover),
        ),
      );

  Widget ListVocaEmpty() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Column(
              children: const [
                Text(
                  'List vocabulary is Empty',
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

  Widget Listvoca() => ListView.builder(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: listVoca.length, //Thay thế listVoca
        itemBuilder: (context, index) {
          final voca = listVoca[index]; //Thay thế listVoca
          return Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          voca.vocaEng.toString() +
                              ' (' +
                              voca.type.toString() +
                              ')',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          voca.vocaVie.toString(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    // Button_save(),
                    GestureDetector(
                      onTap: () {
                        addVocatoStorage(voca.vocaEng.toString(),
                            voca.vocaVie.toString(), voca.type.toString());
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Image(
                            image: AssetImage(
                              "assets/images/save.png",
                            ),
                          )),
                    )
                  ]),
            ),
          );
        },
      );

  Future<void> addVocatoStorage(String vocaEng, String vocaVie, String type) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference addStorage =
        FirebaseFirestore.instance.collection('storage');
    return addStorage
        .add({
          'uid': user?.uid,
          'vocaEng': vocaEng,
          'vocaVie': vocaVie,
          'type': type,
          'timeSave': DateTime.now()
        })
        .then((value) => showNotifi(context))
        .catchError((e) => print("Failed to add voca: $e"));
    //Should check duplicate vocabulary before user add new one to storage
  }

  showNotifi(BuildContext context) {
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
      content: const Text('A word is moved into your storage.'),
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
