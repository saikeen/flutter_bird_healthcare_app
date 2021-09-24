import 'package:BirdHealthcare/domain/weight_data.dart';
import 'package:charts_flutter/flutter.dart';
import "package:flutter/material.dart";
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GraphPanelStyle {
  const GraphPanelStyle({
    this.height,
  });

  final int? height;
}

class StylableGraphPanel extends HookConsumerWidget {
  const StylableGraphPanel({
    required this.title,
    Key? key,
    this.style = const GraphPanelStyle(),
    this.data,
  }) : super(key: key);

  final GraphPanelStyle style;
  final String title;
  final List<Series<WeightData, DateTime>>? data;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
      height: 250.0,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(title),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: new charts.TimeSeriesChart(data!,
                    animate: false,
                    primaryMeasureAxis: new charts.NumericAxisSpec(
                        tickProviderSpec:
                            new charts.BasicNumericTickProviderSpec(
                                zeroBound: false))),
              ),
            ],
          ),
        ),
      ));
}
