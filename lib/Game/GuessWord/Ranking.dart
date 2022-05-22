import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/Game/GuessWord/Storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  State<Ranking> createState() => _RankingState();
}


class _RankingState extends State<Ranking> {
  late List<Score> listRank = [];
  bool isLoading = false;
  int numberRank = 1;
  String imageRank ='';
  @override
  void initState() {
    super.initState();
    reLoadRank();
    listRank.clear();
  }

  @override
  Future reLoadRank() async {
    setState(() => isLoading = true);

    await FirebaseFirestore.instance
        .collection('Rank')
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        Score obj = Score.fromMap(doc.data());
        listRank.add(obj);
      });
    });
    for(int i = 0;i<listRank.length;i++){
      await FirebaseFirestore.instance
          .collection('users')
          .doc(listRank[i].uid)
          .get()
          .then((DocumentSnapshot snapshot) {
          UserData obj = UserData.fromMap(snapshot.data());
          listRank[i].username = obj.username;
        });
    }
    listRank.sort((a,b) {
      if(a.score < b.score){
        return 1;
      }
      else if(a.score == b.score && a.time > b.time){
        return 1;
      }
      return -1;
    });
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(flex: 1, child: Container(
            alignment: Alignment.center,
            child: Center(child: Image.asset('assets/gameImages/Ranking.gif', fit: BoxFit.cover,)))),
          Expanded(flex: 2, child:  Scaffold(
            backgroundColor: Colors.white,
                body: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : listRanking()),
          )
        ],
      ),
    );
  }
  Widget listRanking() {
    return SingleChildScrollView(
        child: Column(
          children: listRank.map((e) {
            return Container(
              height: 90,
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Storage.color1,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      width: 2,
                      color: Colors.red,
                    ),
                  ),
              child:Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 70,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Storage.color2,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 2,
                          color: Colors.transparent,
                        ),
                      
                      ),
                      child: setImage(),
                    )),
                   Expanded(flex: 2, child: Column(
                     children: [
                       Expanded(                        
                         flex: 1,
                         child: Center(child: Text('NO '+(numberRank++).toString()+'. '+e.username!.toUpperCase(), 
                         style: const TextStyle(color: Colors.white,
                         fontSize: 18,
                         fontWeight: FontWeight.bold,
                         ),))),
                       Expanded(
                         flex: 1,
                         child: Center(child: Text('Score: '+e.score.toString(),style: const TextStyle(
                           color: Storage.color2,
                           fontWeight: FontWeight.bold,
                           fontSize: 20,
                         ),))),
                     ],
                   )),
                   Expanded(flex: 1, child: Center(child: Center(
                     child: Column(
                       children: [
                         const Padding(
                           padding: EdgeInsets.only(top: 10.0),
                           child: Text('Time (s)',style: TextStyle(
                             color: Color.fromARGB(255, 40, 111, 187),
                           ),),
                         ),
                         Container(
                           height: 40,
                           width: 40,
                           margin: const EdgeInsets.only(top: 5.0),
                           decoration: BoxDecoration(
                              color: Colors.cyanAccent,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                width: 2,
                                color: Colors.white,
                              ),
                            ),
                          child: Center(child: Text(e.time.toString())),
                         ),
                       ],
                     ),
                   ))),
                ],
              ), 
            );
          }).toList(),
        ),
      );
  }
  Widget setImage(){
    if(numberRank==1){
      imageRank = 'assets/gameImages/rank1.png';
    }
    else if(numberRank==2){
      imageRank = 'assets/gameImages/rank2.png';
    }
    else if(numberRank==3){
      imageRank = 'assets/gameImages/rank3.png';
    }
    else{
      imageRank = 'assets/gameImages/avatar.png';
    }
    return Image.asset(imageRank,fit: BoxFit.cover,);
  }
}
