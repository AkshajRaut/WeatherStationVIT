import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vitweather/gauge_humidity.dart';
import 'package:vitweather/custom_axis_renderer/custom_axis_renderer_humidity.dart';

class Humidity extends StatefulWidget {
  const Humidity({Key? key}) : super(key: key);

  @override
  State<Humidity> createState() => _HumidityState();
}

class _HumidityState extends State<Humidity> {
  double humidity_1 = 0.0;
  double humidity_2 = 0.0;
  DatabaseReference refs = FirebaseDatabase.instance.ref();
  final Color _pointerColor = const Color(0xFF494CA2);

  @override
  void initState() {
    super.initState();

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Humidity"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
            child: orientation == Orientation.portrait
                ? Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 40.h,
                            width: 40.h,
                            child: CustomGauge(
                              title: "Local Station 1",
                              value: humidity_1,
                              unit: " %",
                              stat: "",
                              statcolor: Colors.white,
                              max: 100,
                              renderer: handleCreateAxisRenderer,
                            )),
                        Container(
                            height: 40.h,
                            width: 40.h,
                            child: CustomGauge(
                              title: "Local Station 2",
                              value: humidity_2,
                              unit: " %",
                              stat: "",
                              statcolor: Colors.transparent,
                              max: 100,
                              renderer: handleCreateAxisRenderer,
                            )),
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
                            value: humidity_1,
                            unit: " %",
                            stat: "",
                            statcolor: Colors.transparent,
                            max: 100,
                            renderer: handleCreateAxisRenderer,
                          )),
                      Container(
                          height: 40.h,
                          width: 32.h,
                          child: CustomGauge(
                            title: "Local Station 2",
                            value: humidity_2,
                            unit: " %",
                            stat: "",
                            statcolor: Colors.transparent,
                            max: 100,
                            renderer: handleCreateAxisRenderer,
                          )),
                    ],
                  )),
      ),
    );
  }
}
