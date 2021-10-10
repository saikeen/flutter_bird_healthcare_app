import 'package:BirdHealthcare/view_models/add_record.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addRecordProvider = ChangeNotifierProvider(
  (ref) => AddRecordViewModel(),
);
