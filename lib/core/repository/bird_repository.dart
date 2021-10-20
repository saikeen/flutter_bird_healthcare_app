import 'package:cloud_firestore/cloud_firestore.dart';

class BirdRepository {
  final _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> fetchBirds() async {
    final QuerySnapshot snapshot = await _db
        .collection('birds')
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot;
  }
}
