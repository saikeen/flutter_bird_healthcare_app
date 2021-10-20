import 'package:BirdHealthcare/domain/record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dart_date/dart_date.dart';

class SelectBirdModel extends ChangeNotifier {
  var _id = '';
  var _name = '';
  String get id => _id;
  String get name => _name;

  void setData(id, name) {
    _id = id;
    _name = name;

    DateTime today = DateTime.now();
    this.fetchRecordList(today.startOfISOWeek, today.endOfISOWeek);

    notifyListeners();
  }

  List<Record>? records;

  fetchRecordList(DateTime startDate, DateTime endDate) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('records')
        .where('birdId', isEqualTo: this.id)
        .where('createdAt', isGreaterThanOrEqualTo: startDate)
        .where('createdAt', isLessThanOrEqualTo: endDate)
        .orderBy('createdAt', descending: false)
        .get();

    final List<Record> records = snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final String id = document.id;
      final String birdId = data['birdId'];
      final double bodyWeight = data['bodyWeight'].toDouble();
      final double foodWeight = data['foodWeight'].toDouble();
      final Timestamp createdAt = data['createdAt'];
      return Record(id, birdId, bodyWeight, foodWeight, createdAt);
    }).toList();

    this.records = records;
    notifyListeners();
  }
}
