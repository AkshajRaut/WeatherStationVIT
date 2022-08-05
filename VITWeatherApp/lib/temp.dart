import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:sizer/sizer.dart';

class Temperature extends StatefulWidget {
  const Temperature({Key? key}) : super(key: key);

  @override
  State<Temperature> createState() => _TemperatureState();
}

class _TemperatureState extends State<Temperature> {
  double temperature_1 = 0.0;
  double temperature_2 = 0.0;
  DatabaseReference refs = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    // print('INIT');
    refs.onValue.listen((DatabaseEvent event) {
      double temp1 =
      double.parse(event.snapshot.child('station1/temp1').value.toString());

      double temp2 =
      double.parse(event.snapshot.child('station2/temp2').value.toString());

      setState(() {
        temperature_1 = temp1;
        temperature_2 = temp2;
      });
    });
    // void dispose(
    //  refs.removeEventListener()
    //  )
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder:(context,orientation,deviceType)
        {
          double height = MediaQuery
              .of(context)
              .size
              .height;
          double width = MediaQuery
              .of(context)
              .size
              .width;
          return Scaffold(
            appBar: AppBar(title: const Text("Temperature")),
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
                          RadialAxis(minimum: 10,
                              maximum: 50,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startValue: 10,
                                    endValue: 20,
                                    color: Colors.green),
                                GaugeRange(
                                    startValue: 20,
                                    endValue: 35,
                                    color: Colors.orange),
                                GaugeRange(
                                    startValue: 35, endValue: 50, color: Colors.red)
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: temperature_1,
                                  enableAnimation: true,
                                  needleEndWidth: 6,
                                  needleLength: 0.72,
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(temperature_1.toStringAsFixed(2) +
                                            " °C",
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
                          RadialAxis(minimum: 10,
                              maximum: 50,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startValue: 10,
                                    endValue: 20,
                                    color: Colors.green),
                                GaugeRange(
                                    startValue: 20,
                                    endValue: 35,
                                    color: Colors.orange),
                                GaugeRange(
                                    startValue: 35, endValue: 50, color: Colors.red)
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: temperature_2,
                                  enableAnimation: true,
                                  needleEndWidth: 6,
                                  needleLength: 0.72,
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(temperature_2.toStringAsFixed(2) +
                                            " °C",
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
