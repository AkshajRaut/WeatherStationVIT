import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:sizer/sizer.dart';

class AirQuality extends StatefulWidget {
  const AirQuality({Key? key}) : super(key: key);

  @override
  State<AirQuality> createState() => _AirQualityState();
}

class _AirQualityState extends State<AirQuality> {
  double aqi_1 = 0;
  double aqi_2 = 0;
  String stat_aqi_1 = '';
  String stat_aqi_2 = '';
  Color color_aqi_1 = Colors.black;
  Color color_aqi_2 = Colors.black;
  DatabaseReference refs = FirebaseDatabase.instance.ref();

  void initState() {
    super.initState();
    // print('INIT');
    refs.onValue.listen((DatabaseEvent event) {
      double aqi1 =
      double.parse(event.snapshot.child('station1/aqi1').value.toString());
      double aqi2 =
      double.parse(event.snapshot.child('station2/aqi2').value.toString());
      if(aqi_1>0 && aqi_1<=75){
        setState((){stat_aqi_1="Good";
        color_aqi_1=Colors.green;});
      } else if (aqi_1>75 && aqi_1<=150){
        setState((){stat_aqi_1="Moderate";
        color_aqi_1=Colors.orange;});
      } else if (aqi_1>150){
        setState((){stat_aqi_1="Unhealthy";
        color_aqi_1=Colors.red;});
      }
      if(aqi_2>0 && aqi_2<=75){
        setState((){stat_aqi_2="Good";
        color_aqi_2=Colors.green;});
      } else if (aqi_2>75 && aqi_2<=150){
        setState((){stat_aqi_2="Moderate";
        color_aqi_2=Colors.orange;});
      } else if (aqi_2>150){
        setState((){stat_aqi_2="Unhealthy";
        color_aqi_2=Colors.red;});
      }



      setState(() {
        aqi_1 = aqi1;
        aqi_2 = aqi2;
      });
    });
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
            appBar: AppBar(title: const Text("Air Quality")),
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
                          RadialAxis(minimum: 0,
                              maximum: 300,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startValue: 0,
                                    endValue: 75,
                                    color: Colors.green),
                                GaugeRange(
                                    startValue: 75,
                                    endValue: 150,
                                    color: Colors.orange),
                                GaugeRange(
                                    startValue: 150,
                                    endValue: 300,
                                    color: Colors.red)
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: aqi_1,
                                  needleStartWidth: 1,
                                  needleEndWidth: 6,
                                  needleLength: 0.72,
                                  enableAnimation: true,
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(stat_aqi_1,
                                            style: TextStyle(
                                                color: color_aqi_1,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    angle: 85,
                                    positionFactor: 0.4),
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(aqi_1.toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    angle: 85,
                                    positionFactor: 0.6)
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
                          RadialAxis(minimum: 0,
                              maximum: 300,
                              ranges: <GaugeRange>[
                                GaugeRange(
                                    startValue: 0,
                                    endValue: 75,
                                    color: Colors.green),
                                GaugeRange(
                                    startValue: 75,
                                    endValue: 150,
                                    color: Colors.orange),
                                GaugeRange(
                                    startValue: 150,
                                    endValue: 300,
                                    color: Colors.red)
                              ],
                              pointers: <GaugePointer>[
                                NeedlePointer(
                                  value: aqi_2,
                                  needleStartWidth: 1,
                                  needleEndWidth: 6,
                                  needleLength: 0.72,
                                  enableAnimation: true,
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(stat_aqi_2,
                                            style: TextStyle(
                                                color: color_aqi_2,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    angle: 85,
                                    positionFactor: 0.4),
                                GaugeAnnotation(
                                    widget: Container(
                                        child: Text(aqi_2.toStringAsFixed(2),
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold))),
                                    angle: 85,
                                    positionFactor: 0.6)
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
