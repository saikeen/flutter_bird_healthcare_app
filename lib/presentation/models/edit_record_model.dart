import 'package:BirdHealthcare/core/repository/record_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditRecordModel extends ChangeNotifier {
  var _id = "";
  var _birdId = "";
  var _bodyWeight = 0.0;
  var _foodWeight = 0.0;
  var _note = "";

  final bodyWeightController = TextEditingController();
  final foodWeightController = TextEditingController();
  final noteController = TextEditingController();

  String get id => _id;
  String get birdId => _birdId;
  double get bodyWeight => _bodyWeight;
  double get foodWeight => _foodWeight;
  String get note => _note;
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void getRecord(String birdId, DateTime date) async {
    RecordRepository _recordRepository = RecordRepository();
    final records = await _recordRepository.fetchRecordsForDay(birdId, date);

    if (records.docs.length > 0) {
      final record = records.docs.first;
      _id = record.id;
      _birdId = birdId;
      _bodyWeight = record['bodyWeight'];
      _foodWeight = record['foodWeight'];
      _note =
          record.data().toString().contains('note') ? record.get('note') : '';
      bodyWeightController.text = record['bodyWeight'].toString();
      foodWeightController.text = record['foodWeight'].toString();
      noteController.text =
          record.data().toString().contains('note') ? record.get('note') : '';
    } else {
      _id = "";
      _birdId = birdId;
      bodyWeightController.text = "";
      foodWeightController.text = "";
      noteController.text = "";
    }

    notifyListeners();
  }

  void setBodyWeight(double bodyWeight) {
    _bodyWeight = bodyWeight;
    notifyListeners();
  }

  void setFoodWeight(double foodWeight) {
    _foodWeight = foodWeight;
    notifyListeners();
  }

  void setNote(String note) {
    _note = note;
    notifyListeners();
  }

  Future updateRecord(DateTime date) async {
    if (this.birdId == null || this.birdId == "") {
      throw '????????????????????????????????????';
    }

    if (this.bodyWeight == null) {
      throw '????????????????????????????????????';
    }

    if (this.foodWeight == null) {
      throw '???????????????????????????????????????';
    }

    if (this.id.isEmpty) {
      await FirebaseFirestore.instance.collection('records').add({
        'birdId': birdId,
        'bodyWeight': bodyWeight,
        'foodWeight': foodWeight,
        'note': note,
        'createdAt': date,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('records')
          .doc(this.id)
          .update({
        'birdId': birdId,
        'bodyWeight': bodyWeight,
        'foodWeight': foodWeight,
        'note': note,
      });
    }
  }
}
