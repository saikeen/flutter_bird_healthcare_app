import 'package:BirdHealthcare/presentation/models/add_bird_model.dart';
import 'package:BirdHealthcare/presentation/models/bird_list_model.dart';
import 'package:BirdHealthcare/presentation/models/edit_bird_model.dart';
import 'package:BirdHealthcare/presentation/models/select_bird_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final birdListProvider = ChangeNotifierProvider(
  (ref) => BirdListModel()..getBirdList(),
);

final addBirdProvider = ChangeNotifierProvider(
  (ref) => AddBirdModel(),
);

final editBirdProvider = ChangeNotifierProvider(
  (ref) => EditBirdModel(),
);

final selectBirdProvider = ChangeNotifierProvider(
  (ref) => SelectBirdModel(),
);
