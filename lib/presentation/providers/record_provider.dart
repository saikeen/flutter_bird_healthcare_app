import 'package:BirdHealthcare/presentation/models/add_record_model.dart';
import 'package:BirdHealthcare/presentation/models/edit_record_model.dart';
import 'package:BirdHealthcare/presentation/models/record_list_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'bird_provider.dart';

final futureRecordsForWeekProvider = FutureProvider((ref) async {
  final _selectBirdProvider = ref.watch(selectBirdProvider);
  return RecordListModel()
      .getRecordsForWeek((_selectBirdProvider.bird?.id ?? ''), DateTime.now());
});

final recordListProvider = ChangeNotifierProvider(
  (ref) => RecordListModel(),
);

final addRecordProvider = ChangeNotifierProvider(
  (ref) => AddRecordModel(),
);

final editRecordProvider = ChangeNotifierProvider(
  (ref) => EditRecordModel(),
);
