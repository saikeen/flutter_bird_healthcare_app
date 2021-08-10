import 'package:BirdHealthcare/domain/bird.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BirdAddModel extends ChangeNotifier {
  String name;
  String imageUrl;  

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
      'createdAt': Timestamp.now(),
    });
  }
}