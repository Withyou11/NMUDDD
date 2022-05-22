import 'dart:typed_data';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:english_study_app/Game/GuessWord/Menu.dart';
import 'package:english_study_app/Game/GuessWord/Ranking.dart';
import 'package:english_study_app/Game/GuessWord/Storage.dart';
import 'package:english_study_app/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class HomeGame extends StatefulWidget {
  const HomeGame({Key? key}) : super(key: key);

  @override
  State<HomeGame> createState() => _HomeGameState();
}

class _HomeGameState extends State<HomeGame> {
  @override
  void initState() {
    super.initState();
    Sound.soundStr = 'sounds';
    Sound.sound.playLoopedMusic('audio/beautiful-day.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Sound.sound.stopMusic();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
                flex: 1,
                child: Center(
                    child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Score: ' + Storage.score.toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Storage.color1,
                    ),
                  ),
                ))),
            Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Image.asset(
                          'assets/gameImages/gameTitle.png',
                          fit: BoxFit.cover,
                        )),
                    Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: Storage.color1,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Menu()));
                                },
                                child: const Text(
                                  'Play',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 126, 158, 46),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: RawMaterialButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen()));
                                },
                                child: const Text(
                                  'Quit',
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 120.0),
                                  child: InkWell(
                                    onTap: () async{
                                      setState(() {
                                        if(Sound.soundStr == 'sounds'){
                                          Sound.soundStr = 'mute';
                                          Sound.sound.pauseMusic();
                                        }
                                        else{
                                          Sound.soundStr ='sounds';
                                          Sound.sound.playLoopedMusic(
                                              'audio/beautiful-day.mp3');
                                        }
                                      });
                                  
                                    },
                                        // Handle your callback.
                                    child: Ink(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image:  AssetImage(
                                              'assets/gameImages/'+Sound.soundStr+'.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Ranking()));
                                    }, // Handle your callback.
                                    child: Ink(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/gameImages/rank.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: InkWell(
                                    onTap: () {
                                      String step1 =
                                          'Choose Topic you want to play!!!\n';
                                      String step2 =
                                          'With one picture, you can guess the word that was described ^_^';
                                      CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.info,
                                        text: step1 + step2,
                                        backgroundColor: Colors.amber,
                                        confirmBtnColor: Colors.green,
                                      );
                                    }, // Handle your callback.
                                    child: Ink(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/gameImages/infor.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
  
}


