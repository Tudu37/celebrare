
import 'package:flutter/material.dart';

class ProviderState extends ChangeNotifier{

  int currentFrame =0;
  int finalFrame = 0;

  void UpdateFrame(int frame){
    currentFrame = frame;
    notifyListeners();
  }
  void UpdateFinalFrame(int frame){
    finalFrame = frame;
    notifyListeners();
  }

}