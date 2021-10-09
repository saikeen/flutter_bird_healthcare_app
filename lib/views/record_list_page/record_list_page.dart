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
import 'package:intl/intl.dart';
import '../add_record_page/add_record_page.dart';

class RecordListPage extends HookConsumerWidget {
  final formatter = DateFormat('yyyy/MM/dd');

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
        child: Text('グラフ', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      1: Padding(
        padding: EdgeInsets.only(right: 30, left: 30),
        child: Text('テーブル', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    };

    makeBirdTableData(List<Record>? records) {
      List<BirdTableData> tableData = [];

      if (records != null) {
        double inheritedBodyWeightSum = 0;
        double inheritedFoodWeightSum = 0;
        for (DateTime day in weekDays) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double bodyWeightSum = 0;
          targetRecords.forEach((record) {
            bodyWeightSum += record.bodyWeight;
          });
          if (bodyWeightSum != 0) {
            inheritedBodyWeightSum = bodyWeightSum;
            break;
          }
        }
        for (DateTime day in weekDays) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double foodWeightSum = 0;
          targetRecords.forEach((record) {
            foodWeightSum += record.foodWeight;
          });
          if (foodWeightSum != 0) {
            inheritedFoodWeightSum = foodWeightSum;
            break;
          }
        }
        weekDays.forEach((day) {
          final targetRecords = records
              .where((record) => day.isSameDay(record.createdAt.toDate()));
          double bodyWeightSum = 0;
          double foodWeightSum = 0;
          targetRecords.forEach((record) {
            bodyWeightSum += record.bodyWeight;
            foodWeightSum += record.foodWeight;
          });
          if (bodyWeightSum == 0) {
            bodyWeightSum = inheritedBodyWeightSum;
          } else {
            inheritedBodyWeightSum = bodyWeightSum;
          }
          if (foodWeightSum == 0) {
            foodWeightSum = inheritedFoodWeightSum;
          } else {
            inheritedFoodWeightSum = foodWeightSum;
          }
          tableData.add(BirdTableData(
              date: day,
              bodyWeightSum: bodyWeightSum,
              foodWeightSum: foodWeightSum));
        });
        return tableData;
      } else {
        weekDays.forEach((day) {
          tableData.add(
              BirdTableData(date: day, bodyWeightSum: 0, foodWeightSum: 0));
        });
        return tableData;
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: _selectBirdProvider.name.isEmpty
            ? Text('ホーム')
            : Text('${_selectBirdProvider.name}の情報'),
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
              selectedColor: Colors.orange,
              unselectedColor: Colors.white,
              borderRadius: 8.0,
              onSegmentChosen: (index) {
                _selectViewIndexProvider.state = index as int;
              },
            ),
          SizedBox(
            height: 8,
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              if (_selectBirdProvider.name.isNotEmpty &&
                  _selectViewIndexProvider.state == 0)
                StylableGraphPanel(
                    title: "体重",
                    data: makeBodyWeightGraphData(_selectBirdProvider.records)),
              if (_selectBirdProvider.name.isNotEmpty &&
                  _selectViewIndexProvider.state == 0)
                StylableGraphPanel(
                    title: "食事量",
                    data: makeFoodWeightGraphData(_selectBirdProvider.records)),
              if (_selectBirdProvider.name.isNotEmpty &&
                  _selectViewIndexProvider.state == 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(
                      color: Colors.grey,
                    ),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(100),
                      1: FlexColumnWidth(),
                      2: FlexColumnWidth(),
                      3: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: <TableRow>[
                      TableRow(
                        children: <Widget>[
                          TableCell(
                            child: Container(
                              color: Colors.orange[300],
                              child: Text(
                                "日付",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.orange[300],
                              child: Text(
                                "体重",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.orange[300],
                              child: Text(
                                "食事量",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.orange[300],
                              child: Text(
                                "備考",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (final birdTableData
                          in makeBirdTableData(_selectBirdProvider.records))
                        TableRow(
                          children: <Widget>[
                            TableCell(
                              child: Container(
                                child: Text(
                                  formatter.format(birdTableData.date),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                child: Text(
                                  birdTableData.bodyWeightSum.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                child: Text(
                                  birdTableData.foodWeightSum.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                child: Text(
                                  "",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
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

class BirdTableData {
  DateTime date;
  double bodyWeightSum;
  double foodWeightSum;

  BirdTableData(
      {required this.date,
      required this.bodyWeightSum,
      required this.foodWeightSum}) {}
}
