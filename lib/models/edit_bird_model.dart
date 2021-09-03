import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditBirdModel extends ChangeNotifier {
  void fetchUserData(documentId) async{
    if (documentId.isEmpty) {
      nameController.text = "";
      imageUrlController.text = "";
    } else {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('birds').doc(documentId).get();
      nameController.text = snapshot['name'];
      imageUrlController.text = snapshot['imageUrl'];
    }
  }

  final String? id;
  EditBirdModel(this.id) {
    fetchUserData(this.id);
  }

  final nameController = TextEditingController();
  final imageUrlController = TextEditingController();

  String? name;
  String? imageUrl;
  DateTime? birthDate;

  void setName(String name){
    this.name = name;
    notifyListeners();
  }

  void setImageUrl(String imageUrl){
    this.imageUrl = imageUrl;
    notifyListeners();
  }

  void setBirthDate(DateTime birthDate){
    this.birthDate = birthDate;
    notifyListeners();
  }

  Future updateBird() async {
    this.name = nameController.text;
    this.imageUrl = imageUrlController.text;

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
    await FirebaseFirestore.instance.collection('birds').doc(id).update({
      'name': name,
      'imageUrl': imageUrl,
      'birthDate': birthDate,
    });
  }
}
