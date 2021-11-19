import 'package:BirdHealthcare/core/domain/bird.dart';
import 'package:BirdHealthcare/core/repository/bird_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BirdListModel extends ChangeNotifier {
  List<Bird> birds = [];

  void getBirdList() async {
    BirdRepository _birdRepository = BirdRepository();
    final birds = await _birdRepository.fetchBirds();

    final List<Bird> birdList = birds.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String name = data['name'];
      final String imageUrl = data['imageUrl'];
      final DateTime birthDate = data['birthDate'].toDate();
      return Bird(id, name, imageUrl, birthDate);
    }).toList();

    this.birds = birdList;
    notifyListeners();
  }

  Future delete(Bird bird) {
    return FirebaseFirestore.instance.collection('birds').doc(bird.id).delete();
  }
}
