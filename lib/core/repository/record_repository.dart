import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_date/src/dart_date.dart';

class RecordRepository {
  final _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Object?>> fetchRecords(
      String birdId, DateTime date) async {
    final QuerySnapshot snapshot = await _db
        .collection('records')
        .where('birdId', isEqualTo: birdId)
        .where('createdAt', isGreaterThanOrEqualTo: date.startOfDay)
        .where('createdAt', isLessThanOrEqualTo: date.endOfDay)
        .orderBy('createdAt', descending: false)
        .get();

    return snapshot;
  }
}
