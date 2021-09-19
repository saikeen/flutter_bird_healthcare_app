import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBirdModel extends ChangeNotifier {
  String? name;
  DateTime? birthDate;
  File? imageFile;
  bool isLoading = false;

  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future addBird() async {
    if (name == null || name == "") {
      throw '名前が入力されていません';
    }

    if (birthDate == null) {
      throw '生年月日が選択されていません';
    }

    final doc = FirebaseFirestore.instance.collection('birds').doc();

    String? imageUrl;
    if (imageFile != null) {
      // storageにアップロード
      final task = await FirebaseStorage.instance
          .ref('birds/${doc.id}')
          .putFile(imageFile!);
      imageUrl = await task.ref.getDownloadURL();
    }

    // Firestoreに追加
    await doc.set({
      'name': name,
      'birthDate': birthDate,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }
}
