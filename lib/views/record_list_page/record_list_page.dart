import 'package:BirdHealthcare/domain/weight_data.dart';
import 'package:BirdHealthcare/view_models/bird_list.dart';
import 'package:BirdHealthcare/view_models/select_bird.dart';
import 'package:BirdHealthcare/views/record_list_page/circle_avatar_list_view.dart';
import 'package:BirdHealthcare/views/record_list_page/graph_panel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../main.dart';
import '../add_record_page/add_record_page.dart';

class RecordListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BirdListViewModel _birdListProvider = ref.watch(birdListProvider);
    SelectBird _selectBirdProvider = ref.watch(selectBirdProvider);
    List<WeightData> bodyWeightDataList = [];
    List<WeightData> foodWeightDataList = [];

    final records = _selectBirdProvider.records;
    if (records != null) {
      records.forEach((record) {
        bodyWeightDataList.add(WeightData(
            date: record.createdAt.toDate(), weight: record.bodyWeight));
        foodWeightDataList.add(WeightData(
            date: record.createdAt.toDate(), weight: record.foodWeight));
      });
    }

    List<charts.Series<WeightData, DateTime>> getGraphData(
        List<WeightData> dataList) {
      List<charts.Series<WeightData, DateTime>> series = [
        charts.Series(
            id: "Sales",
            data: dataList,
            domainFn: (WeightData data, _) => data.date,
            measureFn: (WeightData data, _) => data.weight,
            colorFn: (WeightData data, _) =>
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
                    title: "体重", data: getGraphData(bodyWeightDataList)),
              if (_selectBirdProvider.name.isNotEmpty)
                StylableGraphPanel(
                    title: "食事量", data: getGraphData(foodWeightDataList)),
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
        label: const Text('追加'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
