import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:sizer/sizer.dart';

class Humidity extends StatefulWidget {
  const Humidity({Key? key}) : super(key: key);

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  double humidity_1 = 0.0;
  double humidity_2 = 0.0;
  DatabaseReference refs = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    // print('INIT');
    refs.onValue.listen((DatabaseEvent event) {
      double humidity1 = double.parse(
          event.snapshot.child('station1/humidity1').value.toString());
      double humidity2 = double.parse(
          event.snapshot.child('station2/humidity2').value.toString());

      setState(() {
        humidity_1 = humidity1;
        humidity_2 = humidity2;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder:(context,orientation,deviceType){

          double height = MediaQuery.of(context).size.height;
          double width = MediaQuery.of(context).size.width;
          return Scaffold(
            appBar: AppBar(title: const Text("Humidity")),
            body: Container(
              height: height,
              width: width,
              // decoration: BoxDecoration(
              //   gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //       colors: [Colors.white,Colors.white, Colors.white],),
              // ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 40.h,
                    width: 40.h,
                    child: SfRadialGauge(
                        title: GaugeTitle(
                            text: "Local Station 1",
                            textStyle:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        enableLoadingAnimation: true,
                        animationDuration: 700,
                        axes: <RadialAxis>[
                          RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0, endValue: 20, color: Colors.green),
                            GaugeRange(
                                startValue: 20, endValue: 60, color: Colors.orange),
                            GaugeRange(
                                startValue: 60, endValue: 100, color: Colors.red)
                          ], pointers: <GaugePointer>[
                            NeedlePointer(
                              value: humidity_1,
                              needleStartWidth: 1,
                              needleEndWidth: 6,
                              needleLength: 0.72,
                              enableAnimation: true,
                            )
                          ], annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text(humidity_1.toStringAsFixed(2) + " %",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                angle: 80,
                                positionFactor: 0.4)
                          ])
                        ]),
                  ),
                  Container(
                    height: 40.h,
                    width: 40.h,
                    child: SfRadialGauge(
                        title: GaugeTitle(
                            text: "Local Station 2",
                            textStyle:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        enableLoadingAnimation: true,
                        animationDuration: 700,
                        axes: <RadialAxis>[
                          RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0, endValue: 20, color: Colors.green),
                            GaugeRange(
                                startValue: 20, endValue: 60, color: Colors.orange),
                            GaugeRange(
                                startValue: 60, endValue: 100, color: Colors.red)
                          ], pointers: <GaugePointer>[
                            NeedlePointer(
                              value: humidity_2,
                              needleStartWidth: 1,
                              needleEndWidth: 6,
                              needleLength: 0.72,
                              enableAnimation: true,
                            )
                          ], annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                                widget: Container(
                                    child: Text(humidity_2.toStringAsFixed(2) + " %",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                angle: 80,
                                positionFactor: 0.4)
                          ])
                        ]),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
