import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/edit_bird_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBirdPage extends StatelessWidget {
  final Bird bird;
  EditBirdPage(this.bird);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditBirdModel>(
      create: (_) => EditBirdModel(bird),
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
