import 'package:BirdHealthcare/models/bird_add_model.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BirdAddPage extends StatefulWidget {
  BirdAddPage({
    Key key,
    this.title,
    this.arguments,
  }) : super(key: key);

  final String title;
  final ScreenArguments arguments;

  @override
  _BirdAddPageState createState() => _BirdAddPageState();
}

class _BirdAddPageState extends State<BirdAddPage> {
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

    return ChangeNotifierProvider<BirdAddModel>(
      create: (_) => BirdAddModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: Center(
          child: Consumer<BirdAddModel>(builder: (context, model, child) {
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
                  ElevatedButton(
                    onPressed: () async {
                      // 追加の処理
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
