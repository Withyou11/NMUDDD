import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_study_app/Game/GuessWord/Ranking.dart';

import 'GuessWord.dart';
import 'Menu.dart';
import 'Storage.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final bool sessionCompleted;
  const MessageBox({required this.sessionCompleted, Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String text ="";
    String buttonText = "";
    if(sessionCompleted==true){
      if(Storage.currentQuestion<Storage.maxQuestion){
        text = 'Well Done!';
        buttonText = 'New Word';
      }
      else{
        text = 'Congratulations!!!';
        buttonText = 'Go Home';
      }
    }
    else{
       text = 'Sorry!Try Again';
       buttonText = 'Go Home';
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        backgroundColor: Colors.amber,
        title: Text('$text', style: Theme.of(context).textTheme.headline2, ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
              ),
              onPressed: () async {
                if(sessionCompleted){
                  if (Storage.currentQuestion < Storage.maxQuestion) {
                    await FirebaseFirestore.instance
                        .collection('Rank')
                        .where('uid', isEqualTo: Storage.uid)
                        .get()
                        .then((QuerySnapshot snapshot) {
                      snapshot.docs.forEach((doc) {
                        Score obj = Score.fromMap(doc.data());
                        Storage.score = obj.score;
                        
                      });
                    });
                    Navigator.of(context).pop();
                     Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const GuessWord()));
                  }
                  else {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const Menu()));
                  }
                 
                }
                else{
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>  const Menu()));
                }
               
              }, 
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text('$buttonText', style: Theme.of(context).textTheme.headline1?.copyWith(
                  fontSize: 30
                ) ,),
              ))
    
        ],
      ),
    );
  }
}
