import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vitweather/gauge_temp.dart';
import 'package:vitweather/custom_axis_renderer/custom_axis_renderer_temp.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      Orientation orientation = MediaQuery.of(context).orientation;
      return Scaffold(
        appBar: AppBar(
          title: const Text("Temperature"),
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
                              value: temperature_1,
                              unit: " °C",
                              stat: "",
                              max: 60,
                              statcolor: Colors.transparent,
                              renderer: handleCreateAxisRenderer,
                            ),
                          ),
                          Container(
                            height: 40.h,
                            width: 40.h,
                            child: CustomGauge(
                              title: "Local Station 2",
                              value: temperature_2,
                              unit: " °C",
                              stat: "",
                              max: 60,
                              statcolor: Colors.transparent,
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
                            value: temperature_1,
                            unit: " °C",
                            stat: "",
                            max: 120,
                            statcolor: Colors.transparent,
                            renderer: handleCreateAxisRenderer,
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 32.h,
                          child: CustomGauge(
                            title: "Local Station 2",
                            value: temperature_2,
                            unit: " °C",
                            stat: "",
                            max: 120,
                            statcolor: Colors.transparent,
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
