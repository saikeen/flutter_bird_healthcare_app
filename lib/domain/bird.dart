import 'package:cloud_firestore/cloud_firestore.dart';

class Bird {
  Bird(this.id, this.name, this.imageUrl, this.birthDate);
  String id;
  String name;
  String imageUrl;
  DateTime birthDate;
}