import 'package:BirdHealthcare/domain/record.dart';
import 'package:BirdHealthcare/domain/weight_data.dart';
import 'package:BirdHealthcare/view_models/bird_list.dart';
import 'package:BirdHealthcare/view_models/select_bird.dart';
import 'package:BirdHealthcare/views/record_list_page/circle_avatar_list_view.dart';
import 'package:BirdHealthcare/views/record_list_page/graph_panel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dart_date/src/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../main.dart';
import '../add_record_page/add_record_page.dart';

class RecordListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BirdListViewModel _birdListProvider = ref.watch(birdListProvider);
    SelectBird _selectBirdProvider = ref.watch(selectBirdProvider);
    DateTime monday = DateTime.now().startOfISOWeek;
    final weekDays = [
      monday,
      monday.addDays(1),
      monday.addDays(2),
      monday.addDays(3),
      monday.addDays(4),
      monday.addDays(5),
      monday.addDays(6),
    ];

    List<charts.Series<WeightData, DateTime>> makeBodyWeightGraphData(
        List<Record>? records) {
      if (records != null) {
        List<WeightData> data = [];
        weekDays.forEach((day) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double sum = 0;
          targetRecords.forEach((record) {
            sum += record.bodyWeight;
          });
          data.add(WeightData(date: day, weight: sum));
        });
        List<charts.Series<WeightData, DateTime>> graphData = [
          charts.Series(
              id: "Sales",
              data: data,
              domainFn: (WeightData data, _) => data.date,
              measureFn: (WeightData data, _) => data.weight,
              colorFn: (WeightData data, _) =>
                  charts.MaterialPalette.blue.shadeDefault)
        ];
        return graphData;
      } else {
        List<WeightData> data = [];
        weekDays.forEach((day) {
          WeightData(date: day, weight: 0);
        });
        List<charts.Series<WeightData, DateTime>> graphData = [
          charts.Series(
              id: "Sales",
              data: data,
              domainFn: (WeightData data, _) => data.date,
              measureFn: (WeightData data, _) => data.weight,
              colorFn: (WeightData data, _) =>
                  charts.MaterialPalette.blue.shadeDefault)
        ];
        return graphData;
      }
    }

    List<charts.Series<WeightData, DateTime>> makeFoodWeightGraphData(
        List<Record>? records) {
      if (records != null) {
        List<WeightData> data = [];
        weekDays.forEach((day) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double sum = 0;
          targetRecords.forEach((record) {
            sum += record.foodWeight;
          });
          data.add(WeightData(date: day, weight: sum));
        });
        List<charts.Series<WeightData, DateTime>> graphData = [
          charts.Series(
              id: "Sales",
              data: data,
              domainFn: (WeightData data, _) => data.date,
              measureFn: (WeightData data, _) => data.weight,
              colorFn: (WeightData data, _) =>
                  charts.MaterialPalette.blue.shadeDefault)
        ];
        return graphData;
      } else {
        List<WeightData> data = [];
        weekDays.forEach((day) {
          WeightData(date: day, weight: 0);
        });
        List<charts.Series<WeightData, DateTime>> graphData = [
          charts.Series(
              id: "Sales",
              data: data,
              domainFn: (WeightData data, _) => data.date,
              measureFn: (WeightData data, _) => data.weight,
              colorFn: (WeightData data, _) =>
                  charts.MaterialPalette.blue.shadeDefault)
        ];
        return graphData;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: _selectBirdProvider.name.isEmpty
            ? Text('ホーム')
            : Text('${_selectBirdProvider.name}のグラフ'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          StylableCircleAbatarListView(data: _birdListProvider),
          if (_selectBirdProvider.name.isEmpty)
            Center(child: Text("愛鳥を選択してください")),
          Expanded(
              child: ListView(
            children: <Widget>[
              if (_selectBirdProvider.name.isNotEmpty)
                StylableGraphPanel(
                    title: "体重",
                    data: makeBodyWeightGraphData(_selectBirdProvider.records)),
              if (_selectBirdProvider.name.isNotEmpty)
                StylableGraphPanel(
                    title: "食事量",
                    data: makeFoodWeightGraphData(_selectBirdProvider.records)),
            ],
          )),
        ],
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
        label: const Text('記録を追加'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.yellow[900],
      ),
    );
  }
}
