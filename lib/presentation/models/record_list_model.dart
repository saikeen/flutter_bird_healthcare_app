import 'package:BirdHealthcare/domain/record.dart';
import 'package:BirdHealthcare/domain/weight_data.dart';
import 'package:dart_date/src/dart_date.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

class RecordListModel {
  List<charts.Series<WeightData, DateTime>> makeBodyWeightGraphData(
      List<Record>? records) {
    if (records != null) {
      List<WeightData> data = [];
      double test = 0;
      for (DateTime day in weekDays) {
        final targetRecords =
            records.where((record) => day.isSameDay(record.createdAt.toDate()));
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
        final targetRecords =
            records.where((record) => day.isSameDay(record.createdAt.toDate()));
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
        final targetRecords =
            records.where((record) => day.isSameDay(record.createdAt.toDate()));
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
        final targetRecords =
            records.where((record) => day.isSameDay(record.createdAt.toDate()));
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

  List<BirdTableData> makeBirdTableData(List<Record>? records) {
    List<BirdTableData> tableData = [];

    if (records != null) {
      double inheritedBodyWeightSum = 0;
      double inheritedFoodWeightSum = 0;
      for (DateTime day in weekDays) {
        final targetRecords =
            records.where((record) => day.isSameDay(record.createdAt.toDate()));
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
        final targetRecords =
            records.where((record) => day.isSameDay(record.createdAt.toDate()));
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
        final targetRecords =
            records.where((record) => day.isSameDay(record.createdAt.toDate()));
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
        tableData
            .add(BirdTableData(date: day, bodyWeightSum: 0, foodWeightSum: 0));
      });
      return tableData;
    }
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
