import 'package:BirdHealthcare/models/add_record_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addRecordProvider = ChangeNotifierProvider<AddRecordModel>(
  (ref) => AddRecordModel(),
);
