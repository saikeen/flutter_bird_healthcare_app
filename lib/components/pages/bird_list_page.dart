import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/bird_list_model.dart';
import 'package:BirdHealthcare/providers/bird_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add_bird_page.dart';
import 'edit_bird_page.dart';

class BirdListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var formatter = DateFormat('yyyy/MM/dd');
    final _provider = ref.watch(birdListProvider);

    // template start
    return Scaffold(
      // organism start
      appBar: AppBar(
        title: Text('愛鳥管理'),
        elevation: 0,
      ),
      // organism end
      // organism start
      body: Center(
        child: Consumer(builder: (context, watch, child) {
          final List<Bird>? birds = _provider.birds;

          if (birds == null) {
            return CircularProgressIndicator();
          }

          final List<Widget> widgets = birds.map((bird) =>
            // molecule start
            Slidable(
              actionPane: SlidableDrawerActionPane(),
              // atom start
              child: ListTile(
                title: Text(bird.name),
                subtitle: Text('生年月日: ${formatter.format(bird.birthDate)}'),
                leading: CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: Image.network(
                      bird.imageUrl,
                    ),
                  ),
                ),
              ),
              // atom end
              // atom start
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: '編集',
                  color: Colors.black45,
                  icon: Icons.edit,
                  onTap: () async {
                    final String? name = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBirdPage(bird)
                      ),
                    );
                    _provider.fetchBirdList();

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
                  onTap: () async {
                    await showConfirmDialog(context, bird, _provider);
                  },
                ),
              ],
              // atom end
            )
            // molecule end
          ).toList();
          return ListView(
            children: widgets,
          );
        }),

      ),
      // organism end
      // organism start
      floatingActionButton: Consumer(builder: (context, watch, child) {
        return FloatingActionButton.extended(
          onPressed: () async => {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddBirdPage(),
                fullscreenDialog: true,
              ),
            ),
            _provider.fetchBirdList()
          },
          label: const Text('追加'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.pink,
        );
      }),
      // organism end
    );
    // template end
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
