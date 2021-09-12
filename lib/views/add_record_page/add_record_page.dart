import 'package:BirdHealthcare/providers/add_record_provider.dart';
import 'package:BirdHealthcare/providers/select_bird_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class AddRecordPage extends HookConsumerWidget {
  final numbars = List<String>.generate(100, (index) => '$index');
  final firstDecimalPlaceNumbers =
      List<String>.generate(10, (index) => '$index');
  final formatter = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _addRecordProvider = ref.watch(addRecordProvider);
    final _selectBirdProvider = ref.watch(selectBirdProvider);

    _addRecordProvider.birdId = _selectBirdProvider.id;

    final selectDecimalNumbarOfBodyWeight = useState('0.0');
    final selectDecimalNumbarOfFoodWeight = useState('0.0');
    final selectNumbar = useState('0');
    final selectFirstDecimalPlaceNumber = useState('0');

    return Scaffold(
      appBar: AppBar(
        title: Text('${_selectBirdProvider.name}の記録'),
        elevation: 0,
      ),
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(selectDecimalNumbarOfBodyWeight.value),
                ElevatedButton(
                  onPressed: () async {
                    final String selectDecimalNumbar = await showModalPicker(
                        context, selectNumbar, selectFirstDecimalPlaceNumber);

                    selectDecimalNumbarOfBodyWeight.value = selectDecimalNumbar;
                    _addRecordProvider.bodyWeight =
                        double.parse(selectDecimalNumbar);
                  },
                  child: Text('体重を選択'),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(selectDecimalNumbarOfFoodWeight.value),
                ElevatedButton(
                  onPressed: () async {
                    final String selectDecimalNumbar = await showModalPicker(
                        context, selectNumbar, selectFirstDecimalPlaceNumber);

                    selectDecimalNumbarOfFoodWeight.value = selectDecimalNumbar;
                    _addRecordProvider.foodWeight =
                        double.parse(selectDecimalNumbar);
                  },
                  child: Text('食事量を選択'),
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

  Future showModalPicker(
      BuildContext context, selectNumbar, selectFirstDecimalPlaceNumber) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          color: Colors.white,
          child: Column(
            children: [
              TextButton(
                child: const Text('閉じる'),
                onPressed: () => Navigator.of(context).pop(selectNumbar.value +
                    '.' +
                    selectFirstDecimalPlaceNumber.value),
              ),
              const Divider(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        looping: true,
                        itemExtent: 30,
                        scrollController:
                            FixedExtentScrollController(initialItem: 0),
                        onSelectedItemChanged: (index) {
                          selectNumbar.value = numbars[index];
                        },
                        children:
                            numbars.map((numbar) => new Text(numbar)).toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 30,
                        scrollController:
                            FixedExtentScrollController(initialItem: 0),
                        onSelectedItemChanged: (index) {
                          selectFirstDecimalPlaceNumber.value =
                              firstDecimalPlaceNumbers[index];
                        },
                        children: firstDecimalPlaceNumbers
                            .map((numbar) => new Text(numbar))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
