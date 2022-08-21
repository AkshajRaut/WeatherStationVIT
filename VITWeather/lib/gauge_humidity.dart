import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CustomGauge extends StatefulWidget {
  final String title;
  final double max;
  final double value;
  final String unit;
  final String stat;
  final Color statcolor;
  final dynamic renderer;

  const CustomGauge({
    Key? key,
    required this.title,
    required this.max,
    required this.value,
    required this.unit,
    required this.renderer,
    required this.stat,
    required this.statcolor,
  }) : super(key: key);

  @override
  State<CustomGauge> createState() => _CustomGaugeState();
}

class _CustomGaugeState extends State<CustomGauge> {
  final Color _pointerColor = const Color(0xFF494CA2);

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
      title: GaugeTitle(
          text: widget.title,
          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      enableLoadingAnimation: true,
      animationDuration: 900,
      axes: <RadialAxis>[
        RadialAxis(
          axisLineStyle: const AxisLineStyle(
              thicknessUnit: GaugeSizeUnit.factor, thickness: 0.15),
          radiusFactor: 1.0,
          showTicks: false,
          showLastLabel: true,
          maximum: widget.max,
          axisLabelStyle: const GaugeTextStyle(),
          // Added custom axis renderer that extended from RadialAxisRenderer
          onCreateAxisRenderer: widget.renderer,
          pointers: <GaugePointer>[
            NeedlePointer(
                enableAnimation: true,
                gradient: const LinearGradient(colors: <Color>[
                  Color.fromRGBO(203, 126, 223, 0),
                  Colors.blue,
                ], stops: <double>[
                  0.25,
                  0.75
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                animationType: AnimationType.easeOutBack,
                value: widget.value,
                animationDuration: 900,
                needleStartWidth: 3,
                needleEndWidth: 6,
                needleLength: 0.7,
                knobStyle: const KnobStyle(
                  knobRadius: 0,
                )),
            RangePointer(
                value: widget.max,
                width: .15,
                sizeUnit: GaugeSizeUnit.factor,
                color: _pointerColor,
                animationDuration: 400,
                animationType: AnimationType.ease,
                gradient: const SweepGradient(
                    colors: <Color>[Colors.red,Colors.yellow,Colors.green,Colors.lightBlue, Colors.blue],
                    stops: <double>[0,0.3,0.6,0.9, 1]),
                enableAnimation: true)
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Text(widget.stat,
                        style: TextStyle(
                            color: widget.statcolor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                angle: 85,
                positionFactor: 0.4),
            GaugeAnnotation(
                widget: Container(
                    child: Text(widget.value.toStringAsFixed(2) + widget.unit,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                angle: 85,
                positionFactor: 0.6)
          ],
        ),
      ],
    );
  }
}
