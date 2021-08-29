import 'package:BirdHealthcare/models/bird_list_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final birdListProvider = ChangeNotifierProvider<BirdListModel>(
  (ref) => BirdListModel()..fetchBirdList(),
);
