import 'dart:ui';

import 'package:BirdHealthcare/services/NavigationService.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:flutter/material.dart';

class RecordListPage extends StatefulWidget {
  RecordListPage({
    Key key,
    this.title,
    this.arguments,
  }) : super(key: key);

  final String title;
  final ScreenArguments arguments;

  @override
  _RecordListPageState createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
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
          scrollDirection: Axis.horizontal,
          children: birds.map((bird) =>
            Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey.shade200,
                  child: ClipOval(
                    child: Image.network(
                      bird.imgUrl,
                    ),
                  ),
                ),
                Positioned(
                  right: 0.0,
                  width: 60.0,
                  height: 60.0,
                  child: RawMaterialButton(
                    onPressed: () {},
                    shape: CircleBorder(),
                  ),
                ),
              ],
            )
          ).toList(),
        ),
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
