import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:intl/intl.dart';
import 'add_bird_screen.dart';
import 'edit_record_screen.dart';
import '../ui-kits/select_button_list.dart';
import '../ui-kits/graph_panel.dart';
import '../../../core/domain/record.dart';
import '../../../presentation/models/record_list_model.dart';
import '../../../presentation/providers/bird_provider.dart';
import '../../../presentation/providers/common_provider.dart';
import '../../../presentation/providers/record_provider.dart';

class RecordListScreen extends HookConsumerWidget {
  const RecordListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _selectBirdProvider = ref.watch(selectBirdProvider);
    final _editRecordProvider = ref.watch(editRecordProvider);
    final _birdListProvider = ref.watch(birdListProvider);
    final _selectedViewIndexProvider =
        ref.watch(selectedViewIndexProvider.state);
    final _selectedCalendarDayProvider =
        ref.watch(selectedCalendarDayProvider.state);

    void handleChangeForSelectButtonList(selectedIndex, selectedData) {
      if (selectedIndex == ADD_BUTTON_INDEX) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddBirdScreen(),
            fullscreenDialog: true,
          ),
        );
      } else {
        _selectBirdProvider.setBird(selectedData);
      }
    }

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
        title: _selectBirdProvider.bird == null
            ? Text('ホーム')
            : Text('${_selectBirdProvider.bird?.name}の情報'),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          SelectButtonList(
            _selectBirdProvider.bird,
            _birdListProvider.birds,
            handleChangeForSelectButtonList,
            FaIcon(FontAwesomeIcons.dove),
          ),
          SizedBox(
            height: 8,
          ),
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
            child: _buildRecordView(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async => {
          if (_selectBirdProvider.bird == null)
            {}
          else
            {
              _selectedCalendarDayProvider.state = DateTime.now(),
              _editRecordProvider.getRecord(
                  (_selectBirdProvider.bird?.id ?? ''), DateTime.now()),
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditRecordScreen(),
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

  Widget _buildRecordView(BuildContext context, WidgetRef ref) {
    final _selectBirdProvider = ref.watch(selectBirdProvider);
    final _editRecordProvider = ref.watch(editRecordProvider);

    StateController<int> _selectedViewIndexProvider =
        ref.watch(selectedViewIndexProvider.state);
    StateController<CalendarFormat> _selectedCalendarFormatProvider =
        ref.watch(selectedCalendarFormatProvider.state);
    StateController<DateTime> _selectedCalendarDayProvider =
        ref.watch(selectedCalendarDayProvider.state);
    StateController<DateTime> _focusedCalendarDayProvider =
        ref.watch(focusedCalendarDayProvider.state);

    RecordListModel recordListModel = RecordListModel();

    DateFormat formatter = DateFormat('MM/dd');

    final asyncValue = ref.watch(futureRecordsForWeekProvider);

    return asyncValue.when(
      data: (data) => _selectBirdProvider.bird != null
          ? ListView(
              children: <Widget>[
                if (_selectedViewIndexProvider.state == 0)
                  Column(
                    children: [
                      StylableGraphPanel(
                          title: "体重",
                          data: recordListModel.makeBodyWeightGraphData(data)),
                      StylableGraphPanel(
                          title: "食事量",
                          data: recordListModel.makeFoodWeightGraphData(data)),
                    ],
                  ),
                if (_selectedViewIndexProvider.state == 1)
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
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
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
                        for (final birdTableData
                            in recordListModel.makeBirdTableData(data))
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
                if (_selectedViewIndexProvider.state == 2)
                  TableCalendar(
                    locale: 'ja_JP',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedCalendarDayProvider.state,
                    calendarFormat: _selectedCalendarFormatProvider.state,
                    onFormatChanged: (format) {
                      if (_selectedCalendarFormatProvider.state != format) {
                        _selectedCalendarFormatProvider.state = format;
                      }
                    },
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedCalendarDayProvider.state, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) async {
                      if (isSameDay(
                          _selectedCalendarDayProvider.state, selectedDay)) {
                        _editRecordProvider.getRecord(
                            (_selectBirdProvider.bird?.id ?? ''), selectedDay);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditRecordScreen(),
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
            )
          : _unselectedListView(),
      loading: _loadingView,
      error: (error, _) => _errorView(error.toString()),
    );
  }

  Widget _loadingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _errorView(String errorMessage) {
    Fluttertoast.showToast(
      msg: errorMessage,
      backgroundColor: Colors.grey,
    );
    return Container();
  }

  Widget _unselectedListView() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          '記録を表示する愛鳥が選択されていません。愛鳥が未登録の場合は画面上部の追加ボタンをタップし、登録をお願い致します。',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _repositoryTile(Record record) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        ),
        child: Text(record.id));
  }
}
