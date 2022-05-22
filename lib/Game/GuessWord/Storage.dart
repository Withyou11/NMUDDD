import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import 'Menu.dart';

class Storage {
  static String chooseGame = '';
  static List<QuestionData> list = [];
  static int score = 0;
  static String doc = '';
  static String uid = '';
  static List<DataTopic> listDataTopic = [];
  static int maxQuestion = 0;
  static int currentQuestion =0;
  static int time = 0;
  static int countQuestion =0;
  static const Color color1 = Color.fromRGBO(13, 209, 33, 1);
  static const Color color2 = Color.fromRGBO(255, 236, 66, 1);
}

class QuestionData {
  String? doc;
  String answer;
  String image;
  List<Object>? listUser;
  QuestionData(
      {this.doc, required this.answer, required this.image, required this.listUser});

  factory QuestionData.fromMap(map) {
    return QuestionData(
        answer: map['answer'], image: map['image'], listUser: map['listUser']);
  }
}
class Score {
  int score;
  String uid;
  int time;
  String? username;
  Score(
      {required this.score, required this.uid, required this.time});

  factory Score.fromMap(map) {
    return Score(
        score: map['Score'], uid: map['uid'], time: map['time']);
  }
}
 class GetDataTopic {
  String? doc;
  String image;
  List<Object> list;
  GetDataTopic({required this.image, required this.list});

  factory GetDataTopic.fromMap(map) {
    return GetDataTopic(image: map['image'], list: map['listUser']);
  }
 }

class UserData {
  String email;
  String username;
  UserData({required this.email, required this.username});

  factory UserData.fromMap(map) {
    return UserData(email: map['email'], username: map['username']);
  }
}

class Music {
  String name ='';
  String audio ='';
  bool status = false;
  Music({required this.name, required this.audio});
}

class Sound {
  static Sound sound = Sound();
  static AudioCache musicCache = AudioCache();
  static AudioPlayer instance = AudioPlayer();
  static String soundStr = 'sounds';
  void playLoopedMusic(String str) async {
    instance = await musicCache.loop(str);
  }

  void pauseMusic() async {
      await instance.pause();
  }
  void continueMusic() async {
      await instance.resume();
  }
  void stopMusic() async {
      await instance.stop();
  }
}