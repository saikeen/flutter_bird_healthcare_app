import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRecordModel extends ChangeNotifier {
  String? birdId;
  double? bodyWeight;
  double? foodWeight;

  Future addRecord() async {
    if (birdId == null || birdId == "") {
      throw '愛鳥が選択されていません';
    }

    if (bodyWeight == null) {
      throw '体重が入力されていません';
    }

    if (foodWeight == null) {
      throw '食事量が入力されていません';
    }

    await FirebaseFirestore.instance.collection('records').add({
      'birdId': birdId,
      'bodyWeight': bodyWeight,
      'foodWeight': foodWeight,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
