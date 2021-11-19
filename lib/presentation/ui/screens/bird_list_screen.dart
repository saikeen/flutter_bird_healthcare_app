import 'package:BirdHealthcare/core/domain/bird.dart';
import 'package:BirdHealthcare/presentation/models/bird_list_model.dart';
import 'package:BirdHealthcare/presentation/providers/bird_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../screens/add_bird_screen.dart';
import '../screens/edit_bird_screen.dart';

class BirdListScreen extends HookConsumerWidget {
  const BirdListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _birdListProvider = ref.watch(birdListProvider);
    final _addBirdProvider = ref.watch(addBirdProvider);
    final _editBirdProvider = ref.watch(editBirdProvider);

    final formatter = DateFormat('yyyy/MM/dd');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
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
                      leading: bird.imageUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.orange,
                              backgroundImage: NetworkImage(bird.imageUrl),
                            )
                          : CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.orange,
                              child: FaIcon(
                                FontAwesomeIcons.dove,
                                color: Colors.white,
                              ),
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
                                builder: (context) => EditBirdScreen()),
                          );
                          _birdListProvider.getBirdList();

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
                builder: (context) => AddBirdScreen(),
                fullscreenDialog: true,
              ),
            ),
            _birdListProvider.getBirdList()
          },
          label: const Text('愛鳥を追加'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.yellow[900],
        );
      }),
    );
  }

  Future showConfirmDialog(
    BuildContext context,
    Bird bird,
    BirdListModel model,
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
                model.getBirdList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
