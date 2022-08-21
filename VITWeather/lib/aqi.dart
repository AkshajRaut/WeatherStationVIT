import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vitweather/gauge.dart';
import 'package:vitweather/custom_axis_renderer/custom_axis_renderer_aqi.dart';

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

  @override
  void initState() {
    refs.get().then((value) =>
        aqi_1 = double.parse(value.child('station1/aqi1').value.toString()));
    refs.get().then((value) =>
        aqi_2 = double.parse(value.child('station2/aqi2').value.toString()));
    super.initState();
    refs.onValue.listen((DatabaseEvent event) {
      double aqi1 =
          double.parse(event.snapshot.child('station1/aqi1').value.toString());
      double aqi2 =
          double.parse(event.snapshot.child('station2/aqi2').value.toString());
      setState(() {
        aqi_1 = aqi1;
        aqi_2 = aqi2;
      });
      if (aqi_1 > 0 && aqi_1 <= 75) {
        setState(() {
          stat_aqi_1 = "Good";
          color_aqi_1 = Colors.green;
        });
      } else if (aqi_1 > 75 && aqi_1 <= 150) {
        setState(() {
          stat_aqi_1 = "Moderate";
          color_aqi_1 = Colors.orange;
        });
      } else if (aqi_1 > 150) {
        setState(() {
          stat_aqi_1 = "Unhealthy";
          color_aqi_1 = Colors.red;
        });
      }
      if (aqi_2 > 0 && aqi_2 <= 75) {
        setState(() {
          stat_aqi_2 = "Good";
          color_aqi_2 = Colors.green;
        });
      } else if (aqi_2 > 75 && aqi_2 <= 150) {
        setState(() {
          stat_aqi_2 = "Moderate";
          color_aqi_2 = Colors.orange;
        });
      } else if (aqi_2 > 150) {
        setState(() {
          stat_aqi_2 = "Unhealthy";
          color_aqi_2 = Colors.red;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      Orientation orientation = MediaQuery.of(context).orientation;
      return Scaffold(
        appBar: AppBar(
          title: const Text("Air Quality"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Container(
          height: height,
          width: width,
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [Colors.white,Colors.white, Colors.white],),
          // ),

          child: SingleChildScrollView(
              child: orientation == Orientation.portrait
                  ? Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 40.h,
                            width: 40.h,
                            child: CustomGauge(
                              title: "Local Station 1",
                              value: aqi_1,
                              unit: "",
                              statcolor: color_aqi_1,
                              stat: stat_aqi_1,
                              max: 300,
                              renderer: handleCreateAxisRenderer,
                            ),
                          ),
                          Container(
                            height: 40.h,
                            width: 40.h,
                            child: CustomGauge(
                              title: "Local Station 2",
                              value: aqi_2,
                              unit: " ",
                              stat: stat_aqi_2,
                              statcolor: color_aqi_2,
                              max: 300,
                              renderer: handleCreateAxisRenderer,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 40.h,
                          width: 32.h,
                          child: CustomGauge(
                            title: "Local Station 1",
                            value: aqi_1,
                            unit: "",
                            stat: stat_aqi_1,
                            statcolor: color_aqi_1,
                            max: 300,
                            renderer: handleCreateAxisRenderer,
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 32.h,
                          child: CustomGauge(
                            title: "Local Station 2",
                            value: aqi_2,
                            unit: " ",
                            stat: stat_aqi_2,
                            statcolor: color_aqi_2,
                            max: 300,
                            renderer: handleCreateAxisRenderer,
                          ),
                        ),
                      ],
                    )),
        ),
      );
    });
  }
}
