import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/bird_list_model.dart';
import 'package:BirdHealthcare/services/NavigationService.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BirdListPage extends StatefulWidget {
  BirdListPage({
    Key key,
    this.title,
    this.arguments,
  }) : super(key: key);

  final String title;
  final ScreenArguments arguments;

  @override
  _BirdListPageState createState() => _BirdListPageState();
}

class _BirdListPageState extends State<BirdListPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BirdListModel>(
      create: (_) => BirdListModel()..fetchBirdList(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: Consumer<BirdListModel>(builder: (context, model, child) {
            final List<Bird> birds = model.birds;

            if (birds == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = birds.map(
              (bird) => Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(bird.name),
                      subtitle: Text("生年月日: 20xx/xx/xx"),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade200,
                        child: ClipOval(
                          child: Image.network(
                            bird.imageUrl,
                          ),
                        ),
                      ),
                      trailing: Wrap(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => {
                              //タブ内に遷移
                              NavigationService.pushInTab(
                                "/bird_edit",
                                arguments: ScreenArguments(
                                  DateTime.now().toIso8601String(),
                                ),
                              )
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // タップ時の処理
                            },
                          ),
                        ],
                      ),
                    )
                  ]
                )
              )
            ).toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
            //タブ内に遷移
            NavigationService.pushInTab(
              "/bird_registration",
              arguments: ScreenArguments(
                DateTime.now().toIso8601String(),
              ),
            )
          },
          label: const Text('追加'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }
}
