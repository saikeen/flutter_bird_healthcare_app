import 'dart:collection';

import 'package:BirdHealthcare/presentation/models/record_list_model.dart';
import 'package:BirdHealthcare/presentation/providers/bird_provider.dart';
import 'package:BirdHealthcare/presentation/providers/common_provider.dart';
import 'package:BirdHealthcare/view_models/bird_list.dart';
import 'package:BirdHealthcare/view_models/select_bird.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/circle_avatar_list_view.dart';
import '../widgets/graph_panel.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:intl/intl.dart';
import '../screens/add_record_screen.dart';

class RecordListScreen extends HookConsumerWidget {
  const RecordListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    BirdListViewModel _birdListProvider = ref.watch(birdListProvider);
    SelectBird _selectBirdProvider = ref.watch(selectBirdProvider);
    StateController<int> _selectedViewIndexProvider =
        ref.watch(selectedViewIndexProvider);
    StateController<CalendarFormat> _selectedCalendarFormatProvider =
        ref.watch(selectedCalendarFormatProvider);
    StateController<DateTime> _selectedCalendarDayProvider =
        ref.watch(selectedCalendarDayProvider);
    StateController<DateTime> _focusedCalendarDayProvider =
        ref.watch(focusedCalendarDayProvider);

    RecordListModel recordListModel = RecordListModel();

    DateFormat formatter = DateFormat('MM/dd');

    Map<int, Widget> _children = {
      0: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text('グラフ', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      1: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text('テーブル', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      2: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Text('スケジュール', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    };

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
              selectionIndex: _selectedViewIndexProvider.state,
              borderColor: Colors.white,
              selectedColor: Colors.orange,
              unselectedColor: Colors.white,
              borderRadius: 8.0,
              onSegmentChosen: (index) {
                _selectedViewIndexProvider.state = index as int;
              },
            ),
          SizedBox(
            height: 8,
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              if (_selectBirdProvider.name.isNotEmpty &&
                  _selectedViewIndexProvider.state == 0)
                StylableGraphPanel(
                    title: "体重",
                    data: recordListModel
                        .makeBodyWeightGraphData(_selectBirdProvider.records)),
              if (_selectBirdProvider.name.isNotEmpty &&
                  _selectedViewIndexProvider.state == 0)
                StylableGraphPanel(
                    title: "食事量",
                    data: recordListModel
                        .makeFoodWeightGraphData(_selectBirdProvider.records)),
              if (_selectBirdProvider.name.isNotEmpty &&
                  _selectedViewIndexProvider.state == 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: TableBorder.all(color: Colors.white),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FlexColumnWidth(),
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
                              color: Colors.orange,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "日付",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.orange,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "体重",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.orange,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "食事量",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Container(
                              color: Colors.orange,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "備考",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (final birdTableData in recordListModel
                          .makeBirdTableData(_selectBirdProvider.records))
                        TableRow(
                          children: <Widget>[
                            TableCell(
                              child: Container(
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    formatter.format(birdTableData.date),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    birdTableData.bodyWeightSum.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    birdTableData.foodWeightSum.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                color: Colors.grey[100],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              if (_selectBirdProvider.name.isNotEmpty &&
                  _selectedViewIndexProvider.state == 2)
                TableCalendar(
                  locale: 'ja_JP',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedCalendarDayProvider.state,
                  calendarFormat:
                      _selectedCalendarFormatProvider.state, //以下、追記部分。
                  // フォーマット変更のボタン押下時の処理
                  onFormatChanged: (format) {
                    if (_selectedCalendarFormatProvider.state != format) {
                      _selectedCalendarFormatProvider.state = format;
                    }
                  },
                  selectedDayPredicate: (day) {
                    //以下追記部分
                    return isSameDay(_selectedCalendarDayProvider.state, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) async {
                    if (isSameDay(
                        _selectedCalendarDayProvider.state, selectedDay)) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddRecordScreen(),
                          fullscreenDialog: true,
                        ),
                      );
                    } else {
                      _selectedCalendarDayProvider.state = selectedDay;
                      _focusedCalendarDayProvider.state = focusedDay;
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedCalendarDayProvider.state = focusedDay;
                  },
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
                  builder: (context) => AddRecordScreen(),
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
