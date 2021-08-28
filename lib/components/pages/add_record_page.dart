import 'package:BirdHealthcare/models/add_record_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';

final _addRecordProvider = ChangeNotifierProvider<AddRecordModel>(
  (ref) => AddRecordModel(),
);

class AddRecordPage extends StatefulWidget {
  @override
  _AddRecordPageState createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> {
  DateTime birthDate = DateTime.now();
  var formatter = DateFormat('yyyy/MM/dd');

  final numbars = List<String>.generate(100, (index) => '$index');
  final firstDecimalPlaceNumbers = List<String>.generate(10, (index) => '$index');
  String selectDecimalNumbarOfBodyWeight = '0.0';
  String selectDecimalNumbarOfFoodWeight = '0.0';

  @override
  Widget build(BuildContext context) {
    // template start
    return Scaffold(
        // organism start
        appBar: AppBar(
          title: Text('記録登録'),
          elevation: 0,
        ),
        // organism end
        // organism start
        body: Center(
          child: Consumer(builder: (context, watch, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // molecule start
                  // atom start
                  Text(selectDecimalNumbarOfBodyWeight),
                  // atom end
                  // atom start
                  ElevatedButton(
                    onPressed: () async {
                      final String selectDecimalNumbar = await showModalPicker(context);

                      if (selectDecimalNumbar != null) {
                        setState(() {
                          selectDecimalNumbarOfBodyWeight = selectDecimalNumbar;
                        });
                      }
                    }, child: Text('体重を選択'),
                  ),
                  // atom end
                  // molecule end
                  SizedBox(
                    height: 16,
                  ),
                  // molecule start
                  // atom start
                  Text(selectDecimalNumbarOfFoodWeight),
                  // atom end
                  // atom start
                  ElevatedButton(
                    onPressed: () async {
                      final String selectDecimalNumbar = await showModalPicker(context);

                      if (selectDecimalNumbar != null) {
                        setState(() {
                          selectDecimalNumbarOfFoodWeight = selectDecimalNumbar;
                        });
                      }
                    }, child: Text('食事量を選択'),
                  ),
                  // atom end
                  // molecule end
                  SizedBox(
                    height: 16,
                  ),
                  // atom start
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await watch(_addRecordProvider).addRecord();
                        Navigator.of(context).pop(true);
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('愛鳥を登録しました'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } catch(e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('追加する'),
                  ),
                  // atom end
                ],
              ),
            );
          }),
        ),
        // organism end
      );
    // template end
  }

  Future showModalPicker(
    BuildContext context,
  ) {
    String selectNumbar = '0';
    String selectFirstDecimalPlaceNumber = '0';

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
                onPressed: () => Navigator.of(context).pop(selectNumbar + '.' + selectFirstDecimalPlaceNumber),
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
                          setState(() {
                            selectNumbar = numbars[index];
                          });
                        },
                        children: numbars
                            .map((numbar) => new Text(numbar))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 30,
                        scrollController:
                            FixedExtentScrollController(initialItem: 0),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectFirstDecimalPlaceNumber = firstDecimalPlaceNumbers[index];
                          });
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
