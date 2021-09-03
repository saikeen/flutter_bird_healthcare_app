import 'package:BirdHealthcare/models/edit_bird_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final editBirdProvider = ChangeNotifierProvider(
  (ref) => EditBird(),
);

class EditBird extends ChangeNotifier {
  var _bird = EditBirdModel("");
  EditBirdModel get bird => _bird;

  void setBird(id) {
    _bird = EditBirdModel(id);
    notifyListeners();
  }
}
