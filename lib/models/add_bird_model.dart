import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddBirdModel extends ChangeNotifier {
  String name;
  String imageUrl;
  DateTime birthDate;

  Future addBird() async {
    if (name == null || name == "") {
      throw '名前が入力されていません';
    }

    if (imageUrl == null || imageUrl == "") {
      throw '画像URLが入力されていません';
    }

    // Firestoreに追加
    await FirebaseFirestore.instance.collection('birds').add({
      'name': name,
      'imageUrl': imageUrl,
      'birthDate': birthDate,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}