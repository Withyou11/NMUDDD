import 'package:flutter/material.dart';

class Controller extends ChangeNotifier {
  int totalLetters =0, letterAnswer =0;


  setUp({required int total}){
    totalLetters = total;
    print('total: $totalLetters');
    notifyListeners();
  }
}