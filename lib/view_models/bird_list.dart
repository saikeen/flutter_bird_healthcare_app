import 'package:BirdHealthcare/domain/bird.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BirdListViewModel extends ChangeNotifier {
  List<Bird>? birds;

  void fetchBirdList() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('birds')
        .orderBy('createdAt', descending: false)
        .get();

    final List<Bird> birds = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String name = data['name'];
      final String? imageUrl = data['imageUrl'];
      final DateTime birthDate = data['birthDate'].toDate();
      return Bird(id, name, imageUrl, birthDate);
    }).toList();

    this.birds = birds;
    notifyListeners();
  }

  Future delete(Bird bird) {
    return FirebaseFirestore.instance.collection('birds').doc(bird.id).delete();
  }
}
