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
import 'package:material_segmented_control/material_segmented_control.dart';
import '../../main.dart';
import '../add_record_page/add_record_page.dart';

class RecordListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BirdListViewModel _birdListProvider = ref.watch(birdListProvider);
    SelectBird _selectBirdProvider = ref.watch(selectBirdProvider);
    StateController<int> _selectViewIndexProvider =
        ref.watch(selectViewIndexProvider);
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
        double test = 0;
        for (DateTime day in weekDays) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double sum = 0;
          targetRecords.forEach((record) {
            sum += record.bodyWeight;
          });
          if (sum != 0) {
            test = sum;
            break;
          }
        }
        weekDays.forEach((day) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double sum = 0;
          targetRecords.forEach((record) {
            sum += record.bodyWeight;
          });
          if (sum == 0) {
            sum = test;
          } else {
            test = sum;
          }
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
        double test = 0;
        for (DateTime day in weekDays) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double sum = 0;
          targetRecords.forEach((record) {
            sum += record.foodWeight;
          });
          if (sum != 0) {
            test = sum;
            break;
          }
        }
        weekDays.forEach((day) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double sum = 0;
          targetRecords.forEach((record) {
            sum += record.foodWeight;
          });
          if (sum == 0) {
            sum = test;
          } else {
            test = sum;
          }
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

    Map<int, Widget> _children = {
      0: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: Text('グラフ'),
      ),
      1: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: Text('テーブル'),
      ),
    };

    List<int> _disabledIndices = [];

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
          SizedBox(
            height: 8,
          ),
          StylableCircleAbatarListView(data: _birdListProvider),
          SizedBox(
            height: 8,
          ),
          if (_selectBirdProvider.name.isEmpty)
            Center(child: Text("愛鳥を選択してください")),
          if (_selectBirdProvider.name.isNotEmpty)
            MaterialSegmentedControl(
              children: _children,
              selectionIndex: _selectViewIndexProvider.state,
              borderColor: Colors.grey,
              selectedColor: Colors.redAccent,
              unselectedColor: Colors.white,
              borderRadius: 8.0,
              disabledChildren: _disabledIndices,
              onSegmentChosen: (index) {
                _selectViewIndexProvider.state = index as int;
              },
            ),
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
