import 'package:BirdHealthcare/providers/edit_bird_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EditBirdPage extends HookConsumerWidget {
  final formatter = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final birthDate = useState(DateTime.now());
    final _editBirdProvider = ref.watch(editBirdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('愛鳥編集'),
        elevation: 0,
      ),
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _editBirdProvider.bird.nameController,
                  decoration: InputDecoration(
                    hintText: '愛鳥の名前',
                  ),
                  onChanged: (text) {
                    _editBirdProvider.bird.setName(text);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _editBirdProvider.bird.imageUrlController,
                  decoration: InputDecoration(
                    hintText: '愛鳥の画像URL',
                  ),
                  onChanged: (text) {
                    _editBirdProvider.bird.setImageUrl(text);
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                Text(formatter.format(birthDate.value)),
                TextButton(
                  onPressed: () {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(2010, 1, 1),
                      maxTime: DateTime(2021, 12, 31),
                      onChanged: (date) {
                        print('change $date');
                      },
                      onConfirm: (date) {
                        print('confirm $date');
                        birthDate.value = date;
                        _editBirdProvider.bird.setBirthDate(date);
                      },
                      currentTime: birthDate.value, locale: LocaleType.jp);
                  },
                  child: Text(
                    '生年月日を入力',
                    style: TextStyle(color: Colors.blue),
                  )
                ),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // 追加の処理
                    try {
                      await _editBirdProvider.bird.updateBird();
                      Navigator.of(context).pop(_editBirdProvider.bird.name);
                    } catch(e) {
                      final snackBar = SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(e.toString()),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Text('更新する'),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
