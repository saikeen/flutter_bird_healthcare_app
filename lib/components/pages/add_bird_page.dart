import 'package:BirdHealthcare/models/add_bird_model.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddBirdPage extends StatefulWidget {
  AddBirdPage({
    Key key,
    this.title,
    this.arguments,
  }) : super(key: key);

  final String title;
  final ScreenArguments arguments;

  @override
  _AddBirdPageState createState() => _AddBirdPageState();
}

class _AddBirdPageState extends State<AddBirdPage> {
  DateTime birthDate = DateTime.now();
  var formatter = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      print("arguments");
      print(ModalRoute.of(context).settings.arguments);
    }
    if (widget.arguments != null) {
      print("widget.arguments");
      print(widget.arguments);
    }

    return ChangeNotifierProvider<AddBirdModel>(
      create: (_) => AddBirdModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: Center(
          child: Consumer<AddBirdModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: '愛鳥の名前',
                    ),
                    onChanged: (text) {
                      model.name = text;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '愛鳥の画像URL',
                    ),
                    onChanged: (text) {
                      model.imageUrl = text;
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
                          model.birthDate = date;
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
                    onPressed: () async {
                      try {
                        await model.addBird();
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
