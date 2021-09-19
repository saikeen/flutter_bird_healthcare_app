import 'package:BirdHealthcare/providers/add_bird_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AddBirdPage extends HookConsumerWidget {
  final formatter = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthDate = useState(DateTime.now());
    final _addBirdProvider = ref.watch(addBirdProvider);

    _addBirdProvider.birthDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('愛鳥登録'),
        elevation: 0,
      ),
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    GestureDetector(
                      child: SizedBox(
                        width: 100,
                        height: 160,
                        child: _addBirdProvider.imageFile != null
                            ? Image.file(_addBirdProvider.imageFile!)
                            : Container(
                                color: Colors.grey,
                              ),
                      ),
                      onTap: () async {
                        print("反応！");
                        await _addBirdProvider.pickImage();
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: '愛鳥の名前',
                      ),
                      onChanged: (text) {
                        _addBirdProvider.name = text;
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(formatter.format(birthDate.value)),
                    TextButton(
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2010, 1, 1),
                              maxTime: DateTime(2021, 12, 31),
                              onConfirm: (date) {
                            birthDate.value = date;
                            _addBirdProvider.birthDate = date;
                          },
                              currentTime: birthDate.value,
                              locale: LocaleType.jp);
                        },
                        child: Text(
                          '生年月日を入力',
                          style: TextStyle(color: Colors.blue),
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          _addBirdProvider.startLoading();
                          await _addBirdProvider.addBird();
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
                          _addBirdProvider.endLoading();
                        }
                      },
                      child: Text('追加する'),
                    )
                  ],
                ),
              ),
              if (_addBirdProvider.isLoading)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          );
        }),
      ),
    );
  }
}
