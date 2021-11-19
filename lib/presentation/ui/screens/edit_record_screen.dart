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

class EditRecordScreen extends HookConsumerWidget {
  const EditRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _editRecordProvider = ref.watch(editRecordProvider);
    final _selectBirdProvider = ref.watch(selectBirdProvider);
    StateController<DateTime> _selectedCalendarDayProvider =
        ref.watch(selectedCalendarDayProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text(
            '${(_selectBirdProvider.bird?.name ?? '')}の記録(${formatDistanceToNow(_selectedCalendarDayProvider.state)})'),
        elevation: 0,
      ),
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _editRecordProvider.bodyWeightController,
                  decoration: InputDecoration(
                    labelText: "体重",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) {
                    _editRecordProvider.setBodyWeight(double.parse(text));
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _editRecordProvider.foodWeightController,
                  decoration: InputDecoration(
                    labelText: "食事量",
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (text) {
                    _editRecordProvider.setFoodWeight(double.parse(text));
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      _editRecordProvider
                          .updateRecord(_selectedCalendarDayProvider.state);
                      Navigator.of(context).pop(true);
                      final snackBar = SnackBar(
                        backgroundColor: Colors.green,
                        content: Text('記録を更新しました'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } catch (e) {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } finally {
                      _selectBirdProvider.setBird(_selectBirdProvider.bird);
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
