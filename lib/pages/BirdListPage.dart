import 'dart:ui';

import 'package:BirdHealthcare/services/NavigationService.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    final Stream<QuerySnapshot> _birdsStream = FirebaseFirestore.instance
                                                                .collection('birds')
                                                                .orderBy('createdAt', descending: false)
                                                                .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _birdsStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            return ListView(
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(data['name']),
                        subtitle: Text("生年月日: 20xx/xx/xx"),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade200,
                          child: ClipOval(
                            child: Image.network(
                              data['imageUrl'],
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
                    ],
                  )
                );
              }).toList(),
            );
          },
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
