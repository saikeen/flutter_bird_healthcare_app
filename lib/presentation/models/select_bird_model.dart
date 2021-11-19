import 'package:BirdHealthcare/core/domain/bird.dart';
import 'package:flutter/material.dart';

class SelectBirdModel extends ChangeNotifier {
  Bird? bird;

  void setBird(bird) {
    this.bird = bird;
    notifyListeners();
  }
}
