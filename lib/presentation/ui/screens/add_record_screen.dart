import 'package:BirdHealthcare/presentation/providers/bird_provider.dart';
import 'package:BirdHealthcare/presentation/providers/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class AddRecordScreen extends HookConsumerWidget {
  // TODO: 値の継承ができない状態のため、余裕がある時に修正
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
        backgroundColor: Colors.yellow[900],
        title: Text('${_selectBirdProvider.name}の記録'),
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
