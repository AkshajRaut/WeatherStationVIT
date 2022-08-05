import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:vitweather/aqi.dart';
import 'package:vitweather/humidity.dart';

import 'package:vitweather/temp.dart';
import 'package:sizer/sizer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'VIT Weather Station',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(title: 'VIT Weather Station  ⛅'),
          );
        }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int aqi_1 = 0;
  double temperature_1 = 0.0;
  double humidity_1 = 0.0;
  int aqi_2 = 0;
  double temperature_2 = 0.0;
  double humidity_2 = 0.0;
  double avg_aqi = 0;
  double avg_temperature = 0;
  double avg_humidity = 0;
  DatabaseReference refs = FirebaseDatabase.instance.ref();
  StreamSubscription? listener;



  @override
  void initState() {
    super.initState();
    // print('INIT');
    listener = refs.onValue.listen((DatabaseEvent event) {
      int aqi1 =
      int.parse(event.snapshot.child('station1/aqi1').value.toString());
      double temp1 =
      double.parse(event.snapshot.child('station1/temp1').value.toString());
      double humidity1 = double.parse(
          event.snapshot.child('station1/humidity1').value.toString());

      setState(() {
        aqi_1 = aqi1;
        temperature_1 = temp1;
        humidity_1 = humidity1;
      }
      );






      int aqi2 =
      int.parse(event.snapshot.child('station2/aqi2').value.toString());
      double temp2 =
      double.parse(event.snapshot.child('station2/temp2').value.toString());
      double humidity2 = double.parse(
          event.snapshot.child('station2/humidity2').value.toString()).roundToDouble();



      setState(() => aqi_2 = aqi2);
      setState(() => temperature_2 = temp2);
      setState(() => humidity_2 = humidity2);

      avg_aqi = (aqi_1 + aqi_2) / 2;
      avg_temperature = (temperature_1 + temperature_2) / 2;
      avg_humidity = (humidity_1 + humidity_2) / 2;
    });
  }



  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      drawer: Drawer(
        //backgroundColor: Colors.transparent,

          child: ListView(

            children: [

              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  image: DecorationImage(image: AssetImage("assets/images/VIT2.png")),

                ),
                child: Text(
                  '',
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.2,
                  style: TextStyle(height: 3, fontSize: 24),
                ),
              ),
              const SizedBox(height:16),
              ListTile(
                leading: Icon(
                  Icons.thermostat,
                  size: 30,
                ),
                title: const Text('Temperature',style: TextStyle(fontSize: 18),),

                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return Temperature();
                  }));
                },
              ),
              const SizedBox(height:16),
              ListTile(
                leading: Icon(
                  Icons.thermostat_auto,
                  size: 30,
                ),
                title: const Text('Humidity',style: TextStyle(fontSize: 18),),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return Humidity();
                  }));
                },
              ),
              const SizedBox(height:16),
              ListTile(
                leading: Icon(
                  Icons.air_outlined,
                  size: 30,
                ),
                title: const Text('Air Quality Index',style: TextStyle(fontSize: 18),),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return AirQuality();
                  }));
                },
              )
            ],
          )),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            //Image.asset
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return Temperature();
                }));
              },
              child:

              Image.asset(
                'assets/images/temperature.png',
                height: 20.h,
                width: 18.h,
              ),
            ),
            Text(
              avg_temperature.toStringAsFixed(2) + " °C",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ), // Image.asset

            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return Humidity();
                }));
              },
              child:
              Image.asset(
                'assets/images/humi.png',
                height: 25.h,
                width: 18.h,
              ),
            ),
            Text(
              avg_humidity.toStringAsFixed(2) + " %",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),

            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AirQuality();
                }));
              },
              child:
              Image.asset(
                'assets/images/airquality.png',
                height: 25.h,
                width: 19.h,
              ),
            ),
            Text(
              avg_aqi.toStringAsFixed(2),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            )
          ], //<Widget>[]
        ), //Column
      ),
    );
  }

  @override
  void dispose() {

    super.dispose();
    listener?.cancel();
  }
}
