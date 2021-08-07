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
    if (ModalRoute.of(context).settings.arguments != null) {
      print("arguments");
      print(ModalRoute.of(context).settings.arguments);
    }
    if (widget.arguments != null) {
      print("widget.arguments");
      print(widget.arguments);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            (widget.arguments != null)
                ? Text(
                    "arguments: " + widget.arguments.message,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                : SizedBox(),
            SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => {
                //タブ内に遷移
                NavigationService.pushInTab(
                  "/bird_registration",
                  arguments: ScreenArguments(
                    DateTime.now().toIso8601String(),
                  ),
                )
              },
              child: Text('/detail in tab'),
            ),
          ],
        ),
      ),
    );
  }
}
