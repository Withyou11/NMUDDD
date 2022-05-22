import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/FlashCardManager.dart';
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

class FlashCardEditing extends StatefulWidget {
  final String? id;
  final bool? check;
  const FlashCardEditing({Key? key, required this.id, required this.check})
      : super(key: key);
  @override
  State<FlashCardEditing> createState() => _FlashCardEditingState();
}

class _FlashCardEditingState extends State<FlashCardEditing> {
  bool _visibilityEdit = false;
  bool _visibilityAdd = false;
  late FlashCardModel item = FlashCardModel(
    word: '',
    quotes: '',
    vieWord: '',
    vieQuotes: '',
  );
  bool isLoading = false;
  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _vieWordController = TextEditingController();
  final TextEditingController _quotesController = TextEditingController();
  final TextEditingController _vieQuotesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.check == true) {
      reLoadFlashCard();
      _visibilityEdit = true;
    } else {
      _visibilityAdd = true;
    }
  }

  Future reLoadFlashCard() async {
    setState(() => isLoading = true);
    await FirebaseFirestore.instance
        .collection('flashCard')
        .doc(widget.id)
        .get()
        .then((value) {
      this.item = FlashCardModel.fromMap(value.data());
    }).catchError((err) {
      print('Failure to get data flash card');
    });

    setState(() => {
          _wordController.text = item.word.toString(),
          _vieWordController.text = item.vieWord.toString(),
          _quotesController.text = item.quotes.toString(),
          _vieQuotesController.text = item.vieQuotes.toString(),
          isLoading = false
        });
  }

  Future<void> addFlashCard(
      String word, String quotes, String vieWord, String vieQuotes) {
    CollectionReference addStorage =
        FirebaseFirestore.instance.collection('flashCard');
    return addStorage
        .add({
          'word': word,
          'quotes': quotes,
          'vieWord': vieWord,
          'vieQuotes': vieQuotes
        })
        .then((value) => showNotifi(context, "Add Flash Card successfully!"))
        .catchError((e) => print("Failed to add: $e"));
  }

  Future<void> updateFlashCard(
      String word, String quotes, String vieWord, String vieQuotes) {
    final docCard =
        FirebaseFirestore.instance.collection('flashCard').doc(widget.id);
    return docCard
        .update({
          'word': word,
          'quotes': quotes,
          'vieWord': vieWord,
          'vieQuotes': vieQuotes
        })
        .then((value) => showNotifi(context, "Update Flash Card successfully!"))
        .catchError((e) => print("Failed to update: $e"));
  }

  void ClearAll() {
    _wordController.text = '';
    _vieWordController.text = '';
    _quotesController.text = '';
    _vieQuotesController.text = '';
  }

  void Clear(TextEditingController _ClearController) {
    _ClearController.text = '';
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
                                      const FlashCardPageAdmin()));
                        },
                        child: Container(child: const Icon(Icons.arrow_back)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          right: 20,
                        ),
                        child: const Text(
                          'Flash Card Manager',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
                            'Edit/Add Flash Card',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            height: 3,
                            width: 120,
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
                                controller: _wordController,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 5, 0, 5),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  hintText: "Insert English Word",
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
                                Clear(_wordController);
                              },
                              child: const Icon(Icons.close_outlined,
                                  color: Colors.red, size: 35),
                            )
                          ],
                        ),
                      ),
                    ],
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
                                controller: _vieWordController,
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 5, 0, 5),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  hintText: "Vietnamese Word",
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
                                Clear(_vieWordController);
                              },
                              child: const Icon(Icons.close_outlined,
                                  color: Colors.red, size: 35),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 10, 20),
                    child: const Text(
                      'Add an English quotes and its translation to make it easy for user to understand',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(13, 209, 33, 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
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
                    child: TextField(
                      // expands: true,
                      maxLines: 6,
                      controller: _quotesController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Insert English quotes",
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(137, 136, 136, 1)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
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
                    child: TextField(
                      maxLines: 6,
                      controller: _vieQuotesController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Insert Vietnamese quotes",
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(137, 136, 136, 1)),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            Visibility(
                              visible: _visibilityEdit,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        {
                                          if (_wordController.text != '' &&
                                              _quotesController.text != '' &&
                                              _vieWordController.text != '' &&
                                              _vieQuotesController.text != '') {
                                            updateFlashCard(
                                                _wordController.text,
                                                _quotesController.text,
                                                _vieWordController.text,
                                                _vieQuotesController.text);
                                          } else {
                                            showNotifi(context,
                                                'Please enter enough information');
                                          }
                                        }
                                      },
                                      child: Container(
                                          width: 70,
                                          height: 50,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  13, 209, 33, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                              Icons.download_done_outlined,
                                              color: Colors.white,
                                              size: 40)),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Update',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(137, 136, 136, 1)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _visibilityAdd,
                              child: Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (_wordController.text != '' &&
                                            _quotesController.text != '' &&
                                            _vieWordController.text != '' &&
                                            _vieQuotesController.text != '') {
                                          addFlashCard(
                                              _wordController.text,
                                              _quotesController.text,
                                              _vieWordController.text,
                                              _vieQuotesController.text);
                                          ClearAll();
                                        } else {
                                          showNotifi(context,
                                              'Please enter enough information');
                                        }
                                      },
                                      child: Container(
                                          width: 70,
                                          height: 50,
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  13, 209, 33, 1),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: const Icon(
                                              Icons.add_box_outlined,
                                              color: Colors.white,
                                              size: 40)),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Create',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(137, 136, 136, 1)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ClearAll();
                              },
                              child: Container(
                                  width: 70,
                                  height: 50,
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: const Image(
                                      image: AssetImage(
                                          "assets/images/exchange.png"))),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Clear all',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red),
                            ),
                          ],
                        )
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
