import 'package:BirdHealthcare/components/pages/edit_bird_page.dart';
import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/bird_list_model.dart';
import 'package:BirdHealthcare/services/NavigationService.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
        body: Center(
          child: Consumer<BirdListModel>(builder: (context, model, child) {
            final List<Bird> birds = model.birds;

            if (birds == null) {
              return CircularProgressIndicator();
            }

            final List<Widget> widgets = birds.map(
              (bird) => Slidable(
                actionPane: SlidableDrawerActionPane(),
                child: ListTile(
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
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: '編集',
                    color: Colors.black45,
                    icon: Icons.edit,
                    onTap: () async {
                      final String name = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBirdPage(bird)
                        ),
                      );

                      model.fetchBirdList();

                      if (name != null) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('$nameを編集しました'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                  IconSlideAction(
                    caption: '削除',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      // タップ時の処理
                    },
                  ),
                ],
              )
            ).toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
        floatingActionButton: Consumer<BirdListModel>(builder: (context, model, child) {
            return FloatingActionButton.extended(
              onPressed: () async => {
                //タブ内に遷移
                await NavigationService.pushInTab(
                  "/add_bird",
                  arguments: ScreenArguments(
                    DateTime.now().toIso8601String(),
                    fullscreenDialog: true,
                  ),
                ),
                model.fetchBirdList()
              },
              label: const Text('追加'),
              icon: const Icon(Icons.add),
              backgroundColor: Colors.pink,
            );
          }
        ),
      ),
    );
  }
}
