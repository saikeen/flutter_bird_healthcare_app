import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/bird_list_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'add_bird_page.dart';
import 'edit_bird_page.dart';

final _birdListProvider = ChangeNotifierProvider<BirdListModel>(
  (ref) => BirdListModel()..fetchBirdList(),
);

class BirdListPage extends StatefulWidget {
  @override
  _BirdListPageState createState() => _BirdListPageState();
}

class _BirdListPageState extends State<BirdListPage> {
  var formatter = DateFormat('yyyy/MM/dd');

  @override
  Widget build(BuildContext context) {
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
          final List<Bird>? birds = watch(_birdListProvider).birds;

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
                    watch(_birdListProvider).fetchBirdList();

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
                    await showConfirmDialog(context, bird, watch(_birdListProvider));
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
            watch(_birdListProvider).fetchBirdList()
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
