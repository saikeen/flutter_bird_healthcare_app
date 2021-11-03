import 'package:BirdHealthcare/presentation/models/add_record_model.dart';
import 'package:BirdHealthcare/presentation/models/edit_record_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addRecordProvider = ChangeNotifierProvider(
  (ref) => AddRecordModel(),
);

final editRecordProvider = ChangeNotifierProvider(
  (ref) => EditRecordModel(),
);
