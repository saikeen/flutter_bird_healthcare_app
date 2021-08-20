import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/edit_bird_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditBirdPage extends StatefulWidget {
  EditBirdPage(this.bird);
  final Bird bird;

  @override
  _EditBirdPageState createState() => _EditBirdPageState();
}

class _EditBirdPageState extends State<EditBirdPage> {
  DateTime birthDate = DateTime.now();
  var formatter = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBirdModel>(
      create: (_) => EditBirdModel(widget.bird),
      child: Scaffold(
        appBar: AppBar(
          title: Text('愛鳥編集'),
          elevation: 0,
        ),
        body: Center(
          child: Consumer<EditBirdModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: model.nameController,
                    decoration: InputDecoration(
                      hintText: '愛鳥の名前',
                    ),
                    onChanged: (text) {
                      model.setName(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: model.imageUrlController,
                    decoration: InputDecoration(
                      hintText: '愛鳥の画像URL',
                    ),
                    onChanged: (text) {
                      model.setImageUrl(text);
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(formatter.format(birthDate)),
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
                          setState(() {
                            birthDate = date;
                          });
                          model.setBirthDate(date);
                        },
                        currentTime: birthDate, locale: LocaleType.jp);
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
                    onPressed: model.isUpdated() ? () async {
                      // 追加の処理
                      try {
                        await model.updateBird();
                        Navigator.of(context).pop(model.name);
                      } catch(e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    } : null,
                    child: Text('更新する'),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
