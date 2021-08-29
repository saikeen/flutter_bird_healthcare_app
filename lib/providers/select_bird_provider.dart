import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final selectBirdProvider = ChangeNotifierProvider(
  (ref) => SelectBird(),
);

class SelectBird extends ChangeNotifier {
  var _name = '';
  String get name => _name;

  void setName(name) {
    _name = name;
    notifyListeners();
  }
}
