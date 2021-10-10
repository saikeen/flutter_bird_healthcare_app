import 'package:BirdHealthcare/view_models/add_bird.dart';
import 'package:BirdHealthcare/view_models/bird_list.dart';
import 'package:BirdHealthcare/view_models/edit_bird.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final birdListProvider = ChangeNotifierProvider(
  (ref) => BirdListViewModel()..fetchBirdList(),
);

final addBirdProvider = ChangeNotifierProvider(
  (ref) => AddBirdViewModel(),
);

final editBirdProvider = ChangeNotifierProvider(
  (ref) => EditBirdViewModel(),
);
