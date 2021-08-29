import 'package:BirdHealthcare/models/add_bird_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addBirdProvider = ChangeNotifierProvider<AddBirdModel>(
  (ref) => AddBirdModel(),
);
