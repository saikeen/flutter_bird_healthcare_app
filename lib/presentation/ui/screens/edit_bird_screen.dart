import 'package:BirdHealthcare/presentation/providers/bird_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EditBirdScreen extends HookConsumerWidget {
  const EditBirdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _editBirdProvider = ref.watch(editBirdProvider);
    final birthDate = useState(_editBirdProvider.birthDate);

    final formatter = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('愛鳥編集'),
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
                      child: (() {
                        if (_editBirdProvider.imageFile != null) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage:
                                Image.file(_editBirdProvider.imageFile!).image,
                          );
                        } else if (_editBirdProvider.imageUrl.isNotEmpty) {
                          return CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage:
                                  NetworkImage(_editBirdProvider.imageUrl));
                        } else {
                          return CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey.shade200,
                              child: FaIcon(
                                FontAwesomeIcons.images,
                                color: Colors.grey,
                              ));
                        }
                      })(),
                      onTap: () async {
                        await _editBirdProvider.pickImage();
                      },
                    ),
                    TextField(
                      controller: _editBirdProvider.nameController,
                      decoration: InputDecoration(
                        hintText: '愛鳥の名前',
                      ),
                      onChanged: (text) {
                        _editBirdProvider.setName(text);
                      },
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
                              onChanged: (date) {}, onConfirm: (date) {
                            birthDate.value = date;
                            _editBirdProvider.setBirthDate(date);
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
                          _editBirdProvider.startLoading();
                          await _editBirdProvider.updateBird();
                          Navigator.of(context).pop(_editBirdProvider.name);
                        } catch (e) {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(e.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } finally {
                          _editBirdProvider.endLoading();
                        }
                      },
                      child: Text('更新する'),
                    )
                  ],
                ),
              ),
              if (_editBirdProvider.isLoading)
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
