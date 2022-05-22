import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/FlashCardEditing.dart';
import 'package:english_study_app/HomeScreen_Admin.dart';
import 'package:flutter/material.dart';

import 'Bottom_Navigation.dart';
import 'Bottom_Navigation_Admin.dart';

class FlashCardModel {
  String? word;
  String? quotes;
  String? id;

  FlashCardModel({this.word, this.quotes, this.id});

  factory FlashCardModel.fromMap(map) {
    return FlashCardModel(
      word: map['word'],
      quotes: map['quotes'],
    );
  }
}

class FlashCardPageAdmin extends StatefulWidget {
  const FlashCardPageAdmin({Key? key}) : super(key: key);

  @override
  State<FlashCardPageAdmin> createState() => _FlashCardPageAdminState();
}

class _FlashCardPageAdminState extends State<FlashCardPageAdmin> {
  List<FlashCardModel> listFlashCard = [];
  bool isLoading = false;
  bool? isEdit;
  List<FlashCardModel> newList = [];
  final TextEditingController _findController = TextEditingController();
  @override
  void initState() {
    super.initState();
    LoadFlashCard();
  }

  @override
  Future LoadFlashCard() async {
    setState(() => isLoading = true);

    listFlashCard.clear();
    await FirebaseFirestore.instance
        .collection('flashCard')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        FlashCardModel obj = FlashCardModel.fromMap(doc.data());
        obj.id = doc.id;
        newList.add(obj);
        listFlashCard.add(obj);
      });
    });
    setState(() => isLoading = false);
  }

  void Search(String key) {
    newList.clear();
    listFlashCard.forEach((item) {
      if (item.word!.contains(key)) newList.add(item);
    });
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
                      'Flash Card Manager',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Column(
                    children: [
                      const Text(
                        'List Flash Card',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 3,
                        width: 90,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(13, 209, 33, 1),
                            borderRadius: BorderRadius.circular(8)),
                      )
                    ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(4, 10),
                              blurRadius: 8,
                              spreadRadius: -10,
                              color: Color.fromARGB(255, 110, 107, 104))
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextField(
                            controller: _findController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                              fillColor: Colors.transparent,
                              filled: true,
                              hintText: "Search here",
                              hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(137, 136, 136, 1)),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Search(_findController.text);
                            });
                          },
                          child: const Icon(Icons.search_outlined,
                              color: Colors.grey, size: 35),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                  flex: 1,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : listFlashCard.isEmpty
                          ? ListflashCardEmpty()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 1, child: ListflashCard()),
                                Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 1,
                                      color: Colors.black54,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Add New',
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            isEdit = false;
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FlashCardEditing(
                                                            id: '',
                                                            check: isEdit)));
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
                            )),
            ],
          ),
        ),
      ),
    );
  }

  Widget ListflashCardEmpty() => Text('data');
  Widget ListflashCard() => ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: newList.length,
        itemBuilder: (context, index) {
          final item = newList[index];
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(4, 10),
                      blurRadius: 8,
                      spreadRadius: -10,
                      color: Color.fromARGB(255, 110, 107, 104))
                ]),
            child: Card(
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              item.word.toString(),
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              item.quotes.toString(),
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.red),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              showWarningNotifi(context, item);
                              setState(() {
                                LoadFlashCard();
                              });
                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Image(
                                  image: AssetImage(
                                    "assets/images/trash.png",
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Edit',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(13, 209, 33, 1)),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              isEdit = true;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FlashCardEditing(
                                      id: item.id, check: isEdit)));
                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 243, 242, 242),
                                    borderRadius: BorderRadius.circular(8)),
                                child: const Icon(
                                  Icons.edit_rounded,
                                  color: Color.fromRGBO(13, 209, 33, 1),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ]),
            ),
          );
        },
      );
  void DeleteWord(FlashCardModel item) {
    FirebaseFirestore.instance
        .collection('flashCard')
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
      content: const Text('A Flash Card is removed.'),
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

  showWarningNotifi(BuildContext context, FlashCardModel item) {
    Widget noButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('No'),
    );

    Widget yesButton = TextButton(
      onPressed: () {
        DeleteWord(item);
        setState(() {
          LoadFlashCard();
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
}
