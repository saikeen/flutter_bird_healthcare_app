import 'package:BirdHealthcare/views/record_list_page/circle_avatar_list_view.dart';
import 'package:BirdHealthcare/views/record_list_page/graph_panel.dart';
import 'package:BirdHealthcare/providers/bird_list_provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../add_record_page/add_record_page.dart';
import 'package:BirdHealthcare/providers/select_bird_provider.dart';

class RecordListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _birdListProvider = ref.watch(birdListProvider);
    final _selectBirdProvider = ref.watch(selectBirdProvider);

    final bodyWeightData = [
      new WeightData(new DateTime(2021, 8, 8), 35.0),
      new WeightData(new DateTime(2021, 8, 9), 35.3),
      new WeightData(new DateTime(2021, 8, 10), 35.3),
      new WeightData(new DateTime(2021, 8, 11), 35.0),
      new WeightData(new DateTime(2021, 8, 12), 34.5),
      new WeightData(new DateTime(2021, 8, 13), 34.5),
      new WeightData(new DateTime(2021, 8, 14), 35.0),
    ];

    final foodWeightData = [
      new WeightData(new DateTime(2021, 8, 8), 3),
      new WeightData(new DateTime(2021, 8, 9), 3),
      new WeightData(new DateTime(2021, 8, 10), 3),
      new WeightData(new DateTime(2021, 8, 11), 3),
      new WeightData(new DateTime(2021, 8, 12), 3),
      new WeightData(new DateTime(2021, 8, 13), 3),
      new WeightData(new DateTime(2021, 8, 14), 3),
    ];

    _getBodyWeightData() {
      List<charts.Series<WeightData, DateTime>> series = [
        charts.Series(
            id: "Sales",
            data: bodyWeightData,
            domainFn: (WeightData bodyWeight, _) => bodyWeight.time,
            measureFn: (WeightData bodyWeight, _) => bodyWeight.sales,
            colorFn: (WeightData bodyWeight, _) =>
                charts.MaterialPalette.blue.shadeDefault)
      ];
      return series;
    }

    _getFoodWeightData() {
      List<charts.Series<WeightData, DateTime>> series = [
        charts.Series(
            id: "Sales",
            data: foodWeightData,
            domainFn: (WeightData foodWeight, _) => foodWeight.time,
            measureFn: (WeightData foodWeight, _) => foodWeight.sales,
            colorFn: (WeightData foodWeight, _) =>
                charts.MaterialPalette.blue.shadeDefault)
      ];
      return series;
    }

    return Scaffold(
      appBar: AppBar(
        title: _selectBirdProvider.name.isEmpty
            ? Text('ホーム')
            : Text('${_selectBirdProvider.name}のグラフ'),
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            StylableCircleAbatarListView(data: _birdListProvider),
            if (_selectBirdProvider.name.isEmpty) Text("愛鳥を選択してください"),
            if (_selectBirdProvider.name.isNotEmpty)
              StylableGraphPanel(title: "体重", data: _getBodyWeightData()),
            if (_selectBirdProvider.name.isNotEmpty)
              StylableGraphPanel(title: "食事量", data: _getFoodWeightData()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => {
          if (_selectBirdProvider.id.isEmpty)
            {}
          else
            {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddRecordPage(),
                  fullscreenDialog: true,
                ),
              ),
            }
        },
        label: const Text('追加'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}

class WeightData {
  final DateTime time;
  final double sales;

  WeightData(this.time, this.sales);
}
