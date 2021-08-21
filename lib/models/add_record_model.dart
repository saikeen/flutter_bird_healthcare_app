import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddRecordModel extends ChangeNotifier {
  double bodyWeight;
  double foodWeight;

  Future addRecord() async {
    if (bodyWeight == null || bodyWeight == 0) {
      throw '体重が入力されていません';
    }

    if (foodWeight == null || foodWeight == 0) {
      throw '食事量が入力されていません';
    }

    // Firestoreに追加
    // await FirebaseFirestore.instance.collection('birds').add({
    //   'bodyWeight': bodyWeight,
    //   'foodWeight': foodWeight,
    //   'createdAt': FieldValue.serverTimestamp(),
    // });
  }
}