import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Bottom_Navigation.dart';

class FlashCardModel {
  String? word;
  String? quotes;
  String? vieWord;
  String? vieQuotes;

  FlashCardModel({this.word, this.quotes, this.vieWord, this.vieQuotes});

  factory FlashCardModel.fromMap(map) {
    return FlashCardModel(
      word: map['word'],
      quotes: map['quotes'],
      vieWord: map['vieWord'],
      vieQuotes: map['vieQuotes'],
    );
  }
}

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({Key? key}) : super(key: key);

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  bool isLoading = false;
  int _cur_index = 0;
  late PageController _pageController;
  late List<FlashCardModel> listFlashCard = [];
  List<FlashCardModel> newList = [];

  List<int> fixedListRandom({int len = 5}) {
    List<int> newList1 = [];
    Random random = Random();
    int count = 1;
    while (count <= len) {
      int v = random.nextInt(listFlashCard.length);
      if (newList1.contains(v)) {
        continue;
      } else {
        newList1.add(v);
        count++;
      }
    }
    return newList1;
  }

  getWords() {
    newList.clear();
    List<int> ran = fixedListRandom(len: 5);
    for (var index in ran) {
      newList.add(listFlashCard[index]);
    }
  }

  @override
  void initState() {
    reloadFlashCard();
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
  }

  Future reloadFlashCard() async {
    setState(() => isLoading = true);
    await FirebaseFirestore.instance
        .collection('flashCard')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        FlashCardModel obj = FlashCardModel.fromMap(doc.data());
        listFlashCard.add(obj);
      });
    });
    await getWords();
    setState(() => isLoading = false);
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SizedBox(
            width: double.infinity,
            child: Column(
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
                                    const NavigationBottom()));
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        right: 20,
                      ),
                      child: const Text(
                        'Flash Card',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: size.height * 2 / 3,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : pageView()),
                const SizedBox(height: 20),
                Container(
                  height: 12,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: newList.length,
                    itemBuilder: (context, index) {
                      return buildIndicator(index == _cur_index, size);
                    },
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromRGBO(13, 209, 33, 1),
            onPressed: () {
              setState(() {
                getWords();
              });
            },
            child: const Image(image: AssetImage("assets/images/exchange.png")),
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        width: isActive ? size.width * 1 / 5 : 24,
        decoration: BoxDecoration(
            color:
                isActive ? const Color.fromRGBO(13, 209, 33, 1) : Colors.grey,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
            ]));
  }

  Widget pageView() => PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _cur_index = index;
          });
        },
        itemCount: newList.length,
        itemBuilder: (context, index) {
          //while (newList.isNotEmpty);
          String startLetter =
              newList[index].word != null ? newList[index].word! : '';
          startLetter = startLetter.substring(0, 1);
          String leftLetter =
              newList[index].word != null ? newList[index].word! : '';
          leftLetter = leftLetter.substring(1);
          String quote =
              newList[index].quotes != null ? newList[index].quotes! : '';

          String vieWord =
              newList[index].vieWord != null ? newList[index].vieWord! : '';
          String vieQuotes =
              newList[index].vieQuotes != null ? newList[index].vieQuotes! : '';
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlipCard(
              front: Container(
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
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(3, 6),
                        blurRadius: 6)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: startLetter,
                            style: const TextStyle(
                                fontSize: 89,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  BoxShadow(
                                      color: Colors.black38,
                                      offset: Offset(3, 6),
                                      blurRadius: 6)
                                ]),
                            children: [
                              TextSpan(
                                text: leftLetter,
                                style: const TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.black38,
                                          offset: Offset(3, 6),
                                          blurRadius: 6)
                                    ]),
                              ),
                            ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          '"$quote"',
                          style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              back: Container(
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
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(3, 6),
                        blurRadius: 6)
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          text: vieWord,
                          style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(3, 6),
                                    blurRadius: 6)
                              ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          '"$vieQuotes"',
                          style: const TextStyle(
                            letterSpacing: 1,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }, //--------
      );
}
