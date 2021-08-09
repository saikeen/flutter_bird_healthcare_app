import 'package:BirdHealthcare/domain/bird.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BirdListModel extends ChangeNotifier {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
                                                                .collection('birds')
                                                                .orderBy('createdAt', descending: false)
                                                                .snapshots();

  List<Bird> birds;

  void fetchBirdList(){
    _usersStream.listen((QuerySnapshot snapshot) {
      final List<Bird> birds = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        final String name = data['name'];
        final String imageUrl = data['imageUrl'];
        return Bird(name, imageUrl);
      }).toList();
      this.birds = birds;
      notifyListeners();
    });
  }
}