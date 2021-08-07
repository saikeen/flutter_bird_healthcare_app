import 'dart:ui';

import 'package:BirdHealthcare/services/NavigationService.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';

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
    final birds = [
      Bird(
        name: "BirdName01",
        imgUrl: 'https://3.bp.blogspot.com/-Ncn2Gj8Aq9k/WwJZjGt-FBI/AAAAAAABMF0/5Uco6MFSragyb_xcDgrfuUFZMfx9diW2gCLcBGAs/s400/bird_okameinkogray.png',
      ),
      Bird(
        name: 'BirdName02',
        imgUrl: 'https://1.bp.blogspot.com/-dkBk4bYQrTk/XVKfloSYxiI/AAAAAAABUC8/j6K3SGQG0WMxKFn71LzznPz0SPgI5ufGQCLcBGAs/s400/bird_sekisei_inko_blue.png',
      ),
      Bird(
        name: 'BirdName03',
        imgUrl: 'https://1.bp.blogspot.com/-Nqqq-_PR3oc/Xb-Z7SW7EhI/AAAAAAABV-c/Y_sr_rTdjBAYdWhInk3wS7U_4z2tTMKaQCNcBGAsYHQ/s400/bird_inko_sakura.png',
      ),
      Bird(
        name: 'BirdName04',
        imgUrl: 'https://1.bp.blogspot.com/-pzkUACogq0E/X5OcHr5ZnSI/AAAAAAABb5Q/xb-j2PQXgu03_vypUL1XNOYv4bhpWEFgQCNcBGAsYHQ/s400/bird_mameruriha_inko_blue.png',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: birds.map((bird) =>
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(bird.name),
                    subtitle: Text("生年月日: 20xx/xx/xx"),
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: NetworkImage(bird.imgUrl)
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
                ],
              )
            )
          ).toList(),
        ),
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
    );
  }
}

class Bird {
 final String name;
 final String imgUrl;
 const Bird({
   @required this.name,
   @required this.imgUrl,
 });
}
