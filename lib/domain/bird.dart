import 'package:cloud_firestore/cloud_firestore.dart';

class Bird {
  Bird(this.id, this.name, this.imageUrl);
  String id;
  String name;
  String imageUrl;
}