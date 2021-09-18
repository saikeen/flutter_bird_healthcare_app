import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  Record(
      this.id, this.birdId, this.bodyWeight, this.foodWeight, this.createdAt);
  String id;
  String birdId;
  double bodyWeight;
  double foodWeight;
  Timestamp createdAt;
}
