import 'package:BirdHealthcare/domain/bird.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditBirdModel extends ChangeNotifier {
  final Bird bird;
  EditBirdModel(this.bird) {
    nameController.text = bird.name;
    imageUrlController.text = bird.imageUrl;
  }

  final nameController = TextEditingController();
  final imageUrlController = TextEditingController();

  String name;
  String imageUrl;

  void setName(String name){
    this.name = name;
    notifyListeners();
  }

  void setImageUrl(String imageUrl){
    this.imageUrl = imageUrl;
    notifyListeners();
  }

  bool isUpdated() {
    return name != null || imageUrl != null;
  }

  Future updateBird() async {
    this.name = nameController.text;
    this.imageUrl = imageUrlController.text;

    // Firestoreに追加
    await FirebaseFirestore.instance.collection('birds').doc(bird.id).update({
      'name': name,
      'imageUrl': imageUrl,
    });
  }
}