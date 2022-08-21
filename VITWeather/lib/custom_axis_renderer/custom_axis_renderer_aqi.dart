import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';

class _CustomAxisRenderer extends RadialAxisRenderer {
  _CustomAxisRenderer() : super();

  @override
  List<CircularAxisLabel> generateVisibleLabels() {
    final List<CircularAxisLabel> visibleLabels = <CircularAxisLabel>[];
    for (num i = 0; i < 11; i++) {
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
    if (value >= 0 && value <= 30) {
      return (value * 0.1) / 30;
    } else if (value > 30 && value <= 60) {
      return (((value - 30) * 0.1) / (30)) + (1 * 0.1);
    } else if (value > 60 && value <= 90) {
      return (((value - 60) * 0.1) / (30)) + (2 * 0.1);
    } else if (value > 90 && value <= 120) {
      return (((value - 90) * 0.1) / (30)) + (3 * 0.1);
    } else if (value > 120 && value <= 150) {
      return (((value - 120) * 0.1) / (30)) + (4 * 0.1);
    } else if (value > 150 && value <= 180) {
      return (((value - 150) * 0.1) / (30)) + (5 * 0.1);
    } else if (value > 180 && value <= 210) {
      return (((value - 180) * 0.1) / (30)) + (6 * 0.1);
    } else if (value > 210 && value <= 240) {
      return (((value - 210) * 0.1) / (30)) + (7 * 0.1);
    } else if (value > 240 && value <= 270) {
      return (((value - 240) * 0.1) / (30)) + (8 * 0.1);
    } else if (value > 270 && value <= 300) {
      return (((value - 270) * 0.1) / (30)) + (9 * 0.1);
    } else {
      return 1;
    }
  }

  /// To return the label value based on interval
  double _calculateLabelValue(num value) {
    if (value == 0) {
      return 0;
    } else if (value == 1) {
      return 30;
    } else if (value == 2) {
      return 60;
    } else if (value == 3) {
      return 90;
    } else if (value == 4) {
      return 120;
    } else if (value == 5) {
      return 150;
    } else if (value == 6) {
      return 180;
    } else if (value == 7) {
      return 210;
    } else if (value == 8) {
      return 240;
    } else if (value == 9) {
      return 270;
    } else {
      return 300;
    }
  }
}

GaugeAxisRenderer handleCreateAxisRenderer() {
  final _CustomAxisRenderer customAxisRenderer = _CustomAxisRenderer();
  return customAxisRenderer;
}

final Color _pointerColor = const Color(0xFF494CA2);
