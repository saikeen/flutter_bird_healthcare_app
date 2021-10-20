import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditBirdModel extends ChangeNotifier {
  var _id = "";
  var _name = "";
  var _birthDate = DateTime.now();
  var _imageUrl = "";
  final nameController = TextEditingController();

  String get id => _id;
  String get name => _name;
  DateTime get birthDate => _birthDate;
  String get imageUrl => _imageUrl;
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

  void setBird(id, name, birthDate, imageUrl) {
    _id = id;
    _name = name;
    nameController.text = name;
    _birthDate = birthDate;
    _imageUrl = imageUrl;
    this.imageFile = null;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setBirthDate(DateTime birthDate) {
    _birthDate = birthDate;
    notifyListeners();
  }

  Future updateBird() async {
    if (this.name.isEmpty) {
      throw '名前が入力されていません';
    }

    if (this.birthDate == null) {
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
    } else {
      imageUrl = this.imageUrl;
    }

    // Firestoreに追加
    await FirebaseFirestore.instance.collection('birds').doc(this.id).update({
      'name': this.name,
      'imageUrl': imageUrl,
      'birthDate': this.birthDate,
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
