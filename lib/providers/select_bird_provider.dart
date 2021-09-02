import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectBirdProvider = ChangeNotifierProvider(
  (ref) => SelectBird(),
);

class SelectBird extends ChangeNotifier {
  var _id = '';
  var _name = '';
  String get id => _id;
  String get name => _name;

  void setData(id, name) {
    _id = id;
    _name = name;
    notifyListeners();
  }
}
