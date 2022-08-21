import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

class _CustomAxisRenderer extends RadialAxisRenderer {
  _CustomAxisRenderer() : super();

  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 7; i++) {
      final double labelValue = _calculateLabelValue(i);
      final CircularAxisLabel label = CircularAxisLabel(
          axis.axisLabelStyle, labelValue.toInt().toString(), i, false);
      label.value = labelValue;
      visibleLabels.add(label);
    }

    return visibleLabels;
  }

  /// Returns the factor(0 to 1) from value to place the labels in an axis.
  @override
  double valueToFactor(double value) {
    if (value >= 0 && value <= 10) {
      return (value * 0.1) / 6;
    } else if (value > 10 && value <= 20) {
      return (((value - 10) * 0.1) / (6)) + (1 * 0.167);
    } else if (value > 20 && value <= 30) {
      return (((value - 20) * 0.1) / (6)) + (2 * 0.167);
    } else if (value > 30 && value <= 40) {
      return (((value - 30) * 0.1) / (6)) + (3 * 0.167);
    } else if (value > 40 && value <= 50) {
      return (((value - 40) * 0.1) / (6)) + (4 * 0.167);
    } else if (value > 50 && value <= 60) {
      return (((value - 50) * 0.1) / (6)) + (5 * 0.167);
    } else {
      return 1;
    }
  }

  /// To return the label value based on interval
  double _calculateLabelValue(num value) {
    if (value == 0) {
      return 0;
    } else if (value == 1) {
      return 10;
    } else if (value == 2) {
      return 20;
    } else if (value == 3) {
      return 30;
    } else if (value == 4) {
      return 40;
    } else if (value == 5) {
      return 50;
    } else {
      return 60;
    }
  }
}

GaugeAxisRenderer handleCreateAxisRenderer() {
  final _CustomAxisRenderer customAxisRenderer = _CustomAxisRenderer();
  return customAxisRenderer;
}

final Color _pointerColor = const Color(0xFF494CA2);
