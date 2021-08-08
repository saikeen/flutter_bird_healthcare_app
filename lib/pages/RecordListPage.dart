import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:BirdHealthcare/services/NavigationService.dart';
import 'package:BirdHealthcare/settings/ScreenArguments.dart';

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
    final bodyWeightData = [
      new BodyWeightData(new DateTime(2021, 8, 8), 35.0),
      new BodyWeightData(new DateTime(2021, 8, 9), 35.3),
      new BodyWeightData(new DateTime(2021, 8, 10), 35.3),
      new BodyWeightData(new DateTime(2021, 8, 11), 35.0),
      new BodyWeightData(new DateTime(2021, 8, 12), 34.5),
      new BodyWeightData(new DateTime(2021, 8, 13), 34.5),
      new BodyWeightData(new DateTime(2021, 8, 14), 35.0),
    ];

    final foodWeightData = [
      new FoodWeightData(new DateTime(2021, 8, 8), 3),
      new FoodWeightData(new DateTime(2021, 8, 9), 3),
      new FoodWeightData(new DateTime(2021, 8, 10), 3),
      new FoodWeightData(new DateTime(2021, 8, 11), 3),
      new FoodWeightData(new DateTime(2021, 8, 12), 3),
      new FoodWeightData(new DateTime(2021, 8, 13), 3),
      new FoodWeightData(new DateTime(2021, 8, 14), 3),
    ];

    _getBodyWeightData() {
      List<charts.Series<BodyWeightData, DateTime>> series = [
        charts.Series(
          id: "Sales",
          data: bodyWeightData,
          domainFn: (BodyWeightData bodyWeight, _) => bodyWeight.time,
          measureFn: (BodyWeightData bodyWeight, _) => bodyWeight.sales,
          colorFn: (BodyWeightData bodyWeight, _) => charts.MaterialPalette.blue.shadeDefault
        )
      ];
      return series;
    }

    _getFoodWeightData() {
      List<charts.Series<FoodWeightData, DateTime>> series = [
        charts.Series(
          id: "Sales",
          data: foodWeightData,
          domainFn: (FoodWeightData foodWeight, _) => foodWeight.time,
          measureFn: (FoodWeightData foodWeight, _) => foodWeight.sales,
          colorFn: (FoodWeightData foodWeight, _) => charts.MaterialPalette.blue.shadeDefault
        )
      ];
      return series;
    }

    final Stream<QuerySnapshot> _birdsStream = FirebaseFirestore.instance
                                                                .collection('birds')
                                                                .orderBy('createdAt', descending: false)
                                                                .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Container(
        // decoration: BoxDecoration(border: Border.all(
        //     color: Colors.red,
        //     width: 8.0,
        //   ),
        // ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 60.0,
              // decoration: BoxDecoration(border: Border.all(
              //     color: Colors.blue,
              //     width: 8.0,
              //   ),
              // ),
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
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.grey.shade200,
                            child: ClipOval(
                              child: Image.network(
                                data['imageUrl'],
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
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              height: 250.0,
              // decoration: BoxDecoration(border: Border.all(
              //     color: Colors.blue,
              //     width: 8.0,
              //   ),
              // ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "体重",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 20,),
                      Expanded(
                        child: new charts.TimeSeriesChart(_getBodyWeightData(), animate: true,),
                      ),
                    ],
                  ),
                ),
              )
            ),
            Container(
              height: 250.0,
              // decoration: BoxDecoration(border: Border.all(
              //     color: Colors.blue,
              //     width: 8.0,
              //   ),
              // ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "食事量",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 20,),
                      Expanded(
                        child: new charts.TimeSeriesChart(_getFoodWeightData(), animate: true,),
                      ),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {
          //タブ内に遷移
          NavigationService.pushInTab(
            "/record_registration",
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

class BodyWeightData {
  final DateTime time;
  final double sales;

  BodyWeightData(this.time, this.sales);
}

class FoodWeightData {
  final DateTime time;
  final int sales;

  FoodWeightData(this.time, this.sales);
}
