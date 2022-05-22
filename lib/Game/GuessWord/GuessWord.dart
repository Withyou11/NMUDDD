import 'dart:async';

import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:english_study_app/Game/GuessWord/Menu.dart';
import 'package:english_study_app/Game/GuessWord/Storage.dart';
import 'messageBox.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class GuessWord extends StatefulWidget {
  const GuessWord({Key? key}) : super(key: key);
  @override
  _GuessWord createState() => _GuessWord();
}

class _GuessWord extends State<GuessWord> {
  
  //choosing the game word
  String answerCurrent = "";
  int checkAnswer = 0;
  static int keyHelp = 5;
  int countQuestion = Storage.countQuestion;
  int score = Storage.score;
  List<String> listAnswer = [];
  List<Word> listKeyBoard = [];
  List<Word> listChar = [];
  List<String> list = [];
  //Create a list that contains the Alphabet, or you can just copy and paste it
  List<String> alphabets = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z"
  ];
   //Timer
  int seconds = 0;
  Timer? time;
  bool timeRun = true;
  void startTimer(){
    time=Timer.periodic(const Duration(seconds: 1), (timer) { 
      if(!mounted) {
        return;
      }
      if(timeRun ){
        setState(() {
          seconds++;
        }); 
      }
      else{
        time?.cancel();
      }
    });
        
  }    
  @override
  void initState() {
    startTimer();
    checkAnswer = 0;
    Game.tries = 0;
    Game.selectedChar.clear();
    listChar.clear();
    countQuestion++;
    Storage.countQuestion++;
    Storage.currentQuestion=countQuestion;
    for (int i = 0; i < Storage.list.length; i++) {
      listAnswer.add(Storage.list[i].answer);
    }
    answerCurrent = listAnswer[countQuestion - 1].toUpperCase();
    for (int i = 0; i < answerCurrent.length; i++) {
      listKeyBoard.add(Word(word: answerCurrent[i], index: i));
    }
    listChar = List.from(listKeyBoard);
    for (int i = answerCurrent.length; i < 16; i++) {
      alphabets.shuffle();
      while (answerCurrent.contains(alphabets[0])) {
        alphabets.shuffle();
      }
      listKeyBoard.add(Word(word: alphabets[0], index: i));
    }
    listKeyBoard.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
          CoolAlert.show(
          context: context,
          type: CoolAlertType.confirm,
          text: "You want to exit?",
          confirmBtnColor: Colors.amber,
          backgroundColor: Storage.color1,
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          onConfirmBtnTap: (){

              setState(() {
                  timeRun = false;
                  Storage.countQuestion = 0;
                  updatedTime(seconds);
                });
                Navigator.of(context).pop();
               Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Menu()));
            }           
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Storage.color1,
        body: Column(children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: figureImage(Game.tries)),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text('Score: '+Storage.score.toString(),
                        style: const TextStyle(
                            color: Colors.yellow,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(204, 173, 205, 210),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Question $countQuestion',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 214, 118, 49),
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Expanded(flex: 2, child: UIIconLeft()),
                          Expanded(flex: 6, child: UIImageLoad()),
                          Expanded(flex: 2, child: UIIconRight()),
                        ],
                      )),
                  Expanded(
                    flex: 2,
                    child: UIAnswer(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(flex: 2, child: GameKeyBoard()),
        ]),
      ),
    );
  }

  Widget UIIconLeft() {
   return Center(
     child: buildTimer(),
   );
  }

  Widget UIImageLoad() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 2,
          color: Colors.green,
        ),
      ),
      child: Image.network(
        Storage.list[countQuestion - 1].image,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget UIIconRight() {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: GestureDetector(
                child: Image.asset(
                  './assets/gameImages/'+Sound.soundStr+'1.png',
                  height: 45,
                  width: 45,
                ),
                onTap: () async{
                    setState(() {
                    if (Sound.soundStr == 'sounds') {
                      Sound.soundStr = 'mute';
                      Sound.sound.pauseMusic();
                    } else {
                      Sound.soundStr = 'sounds';
                      Sound.sound.playLoopedMusic('audio/beautiful-day.mp3');
                    }
                  });
                },
              ),
            )),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: Center(
                child: GestureDetector(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 0),
                          child: Image.asset(
                            './assets/gameImages/help.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 30),
                            width: 15,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              ),
                            ),
                            child: Text(
                              keyHelp.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            )),
                      ],
                    ),
                    onTap: () async {
                      if (keyHelp > 0) {
                        setState(() {
                          keyHelp--;
                          checkAnswer++;
                          Random rd = Random();
                          int index = rd.nextInt(answerCurrent.length);
                          String temp = answerCurrent[index];
                          Word word = Word(word: temp, index: index);
                          while (true) {
                            if (check(Game.selectedChar, word.index)) {
                              index = rd.nextInt(answerCurrent.length);
                              temp = answerCurrent[index];
                              word = Word(word: temp, index: index);
                            } else {
                              Game.selectedChar.add(word);
                              AudioCache().play('audio/correct.mp3');
                              break;
                            }
                          }
                          if (answerCurrent.length == checkAnswer) {
                            setState(() {
                              score += 50;
                              updatedScore(score);
                            });
                            showDialog(
                                context: context,
                                builder: (_) => const MessageBox(
                                      sessionCompleted: true,
                                    ),
                                barrierDismissible: false);
                          }
                        });
                      }
                    }),
              ),
            )),
        Expanded(
          flex: 1,
          child: Padding(
              padding: const EdgeInsets.only(right: 0),
              child: GestureDetector(
                child: Image.asset(
                  './assets/gameImages/info.png',
                  height: 40,
                  width: 40,
                ),
                onTap: () {
                  String step =
                      'With one picture, you can guess the word that was described ^_^';
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.info,
                    text: step,
                    backgroundColor: Colors.amber,
                    confirmBtnColor: Colors.green,
                  );
                },
              )),
        )
      ],
    );
  }

  Widget UIAnswer() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Visibility(
        visible: true,
        child: SizedBox(
            height: answerCurrent.length * 50,
            width: answerCurrent.length * 50,
            child: GridView.count(
              crossAxisCount: answerCurrent.length,
              mainAxisSpacing: 5.0,
              crossAxisSpacing: 5.0,
              children: listChar
                  .map((e) => letter(
                      e.word.toUpperCase(), check(Game.selectedChar, e.index)))
                  .toList(),
            )),
      ),
    );
  }

  Widget GameKeyBoard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SizedBox(
          child: GridView.count(
              crossAxisCount: 8,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              padding: const EdgeInsets.all(8.0),
              children: listKeyBoard.map((e) {
                return RawMaterialButton(
                  onPressed: check(Game.selectedChar, e.index)
                      ? null
                      : () async {
                          setState(() {
                            Game.selectedChar.add(e);
                            if (!listChar.contains(e)) {
                              Game.tries++;
                              AudioCache().play('audio/wrong.mp3');
                            }
                            if (listChar.contains(e)) {
                              checkAnswer++;
                              AudioCache().play('audio/correct.mp3');
                            }
                            if (answerCurrent.length == checkAnswer) {
                              setState(() {
                                score += 50;
                                updatedScore(score);
                                updatedImageCompleted(countQuestion-1);
                                updatedQuestionCompleted();
                                timeRun = false;
                                updatedTime(seconds);
                              });
                              showDialog(
                                  context: context,
                                  builder: (_) => const MessageBox(
                                        sessionCompleted: true,
                                      ),
                                  barrierDismissible: false);
                            }
                            if (Game.tries == 3) {
                              setState(() {
                                countQuestion = 1;
                              });
                              showDialog(
                                  context: context,
                                  builder: (_) => const MessageBox(
                                        sessionCompleted: false,
                                      ),
                                  barrierDismissible: false);
                            }
                          });
                        },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    e.word,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 12, 47, 53),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  fillColor: check(Game.selectedChar, e.index)
                      ? Color.fromARGB(221, 79, 117, 111)
                      : Storage.color2,
                );
              }).toList())),
    );
  }
  Widget buildTime() {
    return Text("$seconds",
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.yellow,
        ));
  }

  Widget buildTimer() => SizedBox(
        width: 50,
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.green),
              strokeWidth: 6,
            ),
            Center(
              child: buildTime(),
            )
          ],
        ),
      );
}

bool check(List<Word> list, int index) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].index == index) {
      return true;
    }
  }
  return false;
}

class AppColor {
  static Color primaryColor = Colors.white;
  static Color primaryColorDark = Color.fromARGB(255, 113, 128, 47);
}

class Game {
  static int tries = 0;
  static List<Word> selectedChar = [];
}

class Word {
  String word;
  int index;
  Word({required this.word, required this.index});
}

Widget figureImage(int index) {
  int x = 3 - index;
  return Image.asset(
    'assets/gameImages/heart$x.png',
    fit: BoxFit.cover,
    width: 250,
    height: 100,
  );
}

Widget letter(String character, bool hidden) {
  return Container(
      decoration: BoxDecoration(
        color: Storage.color1,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: hidden,
            child: Text(
              character,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
              ),
            ),
          ),
        ],
      ));
}

void updatedScore(int score) async {
  await FirebaseFirestore.instance
      .collection('Rank')
      .doc(Storage.doc)
      .update({'Score': score}).then((_) => print('Updated'));
}
void updatedImageCompleted(int index) async {
  Storage.list[index].listUser!.add(Storage.uid);
  await FirebaseFirestore.instance
      .collection(Storage.chooseGame)
      .doc(Storage.list[index].doc)
      .update({'listUser': Storage.list[index].listUser!})
      .then((_) => print('Updated'))
      .catchError((e) => print(e));
}
void updatedQuestionCompleted() async {
  for(int i=0;i<Storage.listDataTopic.length;i++){
    if(Storage.listDataTopic[i].name==Storage.chooseGame) {
      await FirebaseFirestore.instance
        .collection('DataMenu')
        .doc(Storage.listDataTopic[i].doc)
        .update({'completedQuestion': ++Storage.listDataTopic[i].completedQuestion})
        .then((_) => print('Updated'))
        .catchError((e) => print(e));
    }
  }
}

void updatedTime(int time) async {
  Storage.time += time;
  await FirebaseFirestore.instance
      .collection('Rank')
      .doc(Storage.doc)
      .update({'time': Storage.time}).then((_) => print('Updated'));
}
