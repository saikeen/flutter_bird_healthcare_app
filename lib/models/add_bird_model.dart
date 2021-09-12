import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBirdModel extends ChangeNotifier {
  String? name;
  String? imageUrl;
  DateTime? birthDate;
  File? imageFile;

  final picker = ImagePicker();

  Future addBird() async {
    if (name == null || name == "") {
      throw '名前が入力されていません';
    }

    if (imageUrl == null || imageUrl == "") {
      throw '画像URLが入力されていません';
    }

    if (birthDate == null) {
      throw '生年月日が選択されていません';
    }

    // Firestoreに追加
    await FirebaseFirestore.instance.collection('birds').add({
      'name': name,
      'imageUrl': imageUrl,
      'birthDate': birthDate,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }
}
