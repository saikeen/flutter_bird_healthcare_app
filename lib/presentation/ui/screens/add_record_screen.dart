import 'package:BirdHealthcare/presentation/providers/bird_provider.dart';
import 'package:BirdHealthcare/presentation/providers/common_provider.dart';
import 'package:BirdHealthcare/presentation/providers/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dart_date/src/dart_date.dart';

String formatDistanceToNow(DateTime date) {
  String formatDistanceToNow = '今日';

  int differenceInDays =
      date.startOfDay.differenceInDays(DateTime.now().startOfDay);

  if (differenceInDays == -2) {
    formatDistanceToNow = '一昨日';
  } else if (differenceInDays == -1) {
    formatDistanceToNow = '昨日';
  } else if (differenceInDays < -2) {
    formatDistanceToNow = '${differenceInDays.abs()}日前';
  } else if (differenceInDays == 1) {
    formatDistanceToNow = '明日';
  } else if (differenceInDays == 2) {
    formatDistanceToNow = '明後日';
  } else if (differenceInDays > 2) {
    formatDistanceToNow = '${differenceInDays.abs()}日後';
  }

  return formatDistanceToNow;
}

class AddRecordScreen extends HookConsumerWidget {
  const AddRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _addRecordProvider = ref.watch(addRecordProvider);
    final _selectBirdProvider = ref.watch(selectBirdProvider);
    StateController<DateTime> _selectedCalendarDayProvider =
        ref.watch(selectedCalendarDayProvider);

    _addRecordProvider.birdId = _selectBirdProvider.id;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text(
            '${_selectBirdProvider.name}の記録(${formatDistanceToNow(_selectedCalendarDayProvider.state)})'),
        elevation: 0,
      ),
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "体重",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) {
                    try {
                      _addRecordProvider.bodyWeight = double.parse(text);
                    } catch (exception) {
                      _addRecordProvider.bodyWeight = 0.0;
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "食事量",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) {
                    try {
                      _addRecordProvider.foodWeight = double.parse(text);
                    } catch (exception) {
                      _addRecordProvider.foodWeight = 0.0;
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.watch(addRecordProvider).addRecord();
                      Navigator.of(context).pop(true);
                      final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('愛鳥を登録しました'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } finally {
                      _selectBirdProvider.setData(
                          _selectBirdProvider.id, _selectBirdProvider.name);
                    }
                  },
                  child: Text('追加する'),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
