import 'package:BirdHealthcare/components/atoms/circle_avatar_button.dart';
import 'package:BirdHealthcare/domain/bird.dart';
import 'package:BirdHealthcare/models/bird_list_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_record_page.dart';

final _birdListProvider = ChangeNotifierProvider<BirdListModel>(
  (ref) => BirdListModel()..fetchBirdList(),
);

class RecordListPage extends StatefulWidget {
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

    // template start
    return Scaffold(
      // organism start
      appBar: AppBar(
        title: Text("ホーム"),
        elevation: 0,
      ),
      // organism end
      // organism start
      body: Container(
        child: Column(
          children: <Widget>[
            // molecule start
            Container(
              height: 60.0,
              child: Consumer(builder: (context, watch, child) {
                final List<Bird>? birds = watch(_birdListProvider).birds;
              
                if (birds == null) {
                  return CircularProgressIndicator();
                }

                final List<Widget> widgets = birds.map(
                  (bird) => StylableCircleAbatarButton(
                    style: CircleAbatarButtonStyle(
                      backgroundColor: Colors.grey.shade200,
                      size: 60
                    ),
                    text: bird.name,
                    imageUrl: bird.imageUrl,
                  )
                ).toList();
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: widgets,
                );
              }),
            ),
            // molecule end
            // molecule start
            Container(
              height: 250.0,
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
            // molecule end
            // molecule start
            Container(
              height: 250.0,
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
            // molecule end
          ],
        ),
      ),
      // organism end
      // organism start
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecordPage(),
              fullscreenDialog: true,
            ),
          ),
        },
        label: const Text('追加'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
      // organism end
    );
    // template end
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
