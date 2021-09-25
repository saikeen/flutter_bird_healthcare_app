import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/view_models/bird_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../main.dart';
import '../add_bird_page/add_bird_page.dart';
import '../edit_bird_page/edit_bird_page.dart';

class BirdListPage extends HookConsumerWidget {
  final formatter = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _birdListProvider = ref.watch(birdListProvider);
    final _addBirdProvider = ref.watch(addBirdProvider);
    final _editBirdProvider = ref.watch(editBirdProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('愛鳥管理'),
        elevation: 0,
      ),
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          final List<Bird>? birds = _birdListProvider.birds;

          if (birds == null) {
            return CircularProgressIndicator();
          }

          final List<Widget> widgets = birds
              .map((bird) => Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    child: ListTile(
                      leading: bird.imageUrl != null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: NetworkImage(bird.imageUrl!),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.grey.shade200,
                              child: Text(bird.name,
                                  style: TextStyle(fontSize: 7),
                                  overflow: TextOverflow.ellipsis),
                            ),
                      title: Text(bird.name),
                      subtitle:
                          Text('生年月日: ${formatter.format(bird.birthDate)}'),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: '編集',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () async {
                          _editBirdProvider.setBird(bird.id, bird.name,
                              bird.birthDate, bird.imageUrl.toString());
                          final String? name = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditBirdPage()),
                          );
                          _birdListProvider.fetchBirdList();

                          if (name != null) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('$nameを編集しました'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                      IconSlideAction(
                        caption: '削除',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () async {
                          await showConfirmDialog(
                              context, bird, _birdListProvider);
                        },
                      ),
                    ],
                  ))
              .toList();
          return ListView(
            children: widgets,
          );
        }),
      ),
      floatingActionButton: Consumer(builder: (context, watch, child) {
        return FloatingActionButton.extended(
          onPressed: () async => {
            _addBirdProvider.imageFile = null,
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBirdPage(),
                fullscreenDialog: true,
              ),
            ),
            _birdListProvider.fetchBirdList()
          },
          label: const Text('追加'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.pink,
        );
      }),
    );
  }

  Future showConfirmDialog(
    BuildContext context,
    Bird bird,
    BirdListViewModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("削除の確認"),
          content: Text("『${bird.name}』を削除しますか？"),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                await model.delete(bird);
                Navigator.of(context, rootNavigator: true).pop();
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${bird.name}を削除しました'),
                );
                model.fetchBirdList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
