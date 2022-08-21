import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:vitweather/aqi.dart';
import 'package:vitweather/humidity.dart';
import 'package:vitweather/about.dart';
import 'package:vitweather/temp.dart';
import 'package:sizer/sizer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitweather/themes.dart';
import 'package:vitweather/ThemeProvider.dart';
import 'package:provider/provider.dart';

//T? _ambiguate<T>(T? value) => value;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'VIT Weather Station',
        themeMode: themeProvider.themeMode,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        home: const MyHomePage(title: 'VIT Weather Station  ⛅'),
      );
    });
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
  final _url = Uri.parse("https://twitter.com/VIT_Weather");

  @override
  void initState() {
    super.initState();

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
      });

      int aqi2 =
          int.parse(event.snapshot.child('station2/aqi2').value.toString());
      double temp2 =
          double.parse(event.snapshot.child('station2/temp2').value.toString());
      double humidity2 = double.parse(
              event.snapshot.child('station2/humidity2').value.toString())
          .roundToDouble();

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
    final themeProvider2 = Provider.of<ThemeProvider>(context);

    final size = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                bool value = themeProvider.isDarkMode;
                themeProvider.setDarkMode = !value;
              },
              icon: Icon(themeProvider2.isDarkMode
                  ? CupertinoIcons.sun_max
                  : CupertinoIcons.moon_stars))
        ],
      ),
      drawer: Drawer(

          //backgroundColor: Colors.transparent,

          child: Column(
        children: [
          Expanded(
            flex: 6,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    image: DecorationImage(
                        image: AssetImage("assets/images/VIT2.png")),
                  ),
                  child: Text(
                    '',
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.2,
                    style: TextStyle(height: 3, fontSize: 24),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(
                    Icons.thermostat,
                    size: 30,
                  ),
                  title: const Text(
                    'Temperature',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Temperature();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.thermostat_auto,
                    size: 30,
                  ),
                  title: const Text(
                    'Humidity',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return Humidity();
                    }));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.air_outlined,
                    size: 30,
                  ),
                  title: const Text(
                    'Air Quality Index',
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return AirQuality();
                    }));
                  },
                ),
                ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.twitter,
                    ),
                    title: const Text(
                      'View on Twitter',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: _launchUrl),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: Icon(
                    Icons.account_box_outlined,
                    size: 30,
                  ),
                  title: const Text('About', style: TextStyle(fontSize: 18)),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return About();
                    }));
                  },
                ),
              ),
            ),
          ),
        ],
      )),
      body: Center(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            //reverse: true,

            child: orientation == Orientation.portrait
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Image.asset

                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Temperature();
                              }));
                            },
                            child: Image.asset(
                              'assets/images/temperature.png',
                              height: 20.h,
                              width: 18.h,
                            ),
                          ),
                          Text(
                            avg_temperature.toStringAsFixed(2) + " °C",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ), // Image.asset

                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Humidity();
                              }));
                            },
                            child: Image.asset(
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
                        ],
                      ),

                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return AirQuality();
                              }));
                            },
                            child: Image.asset(
                              'assets/images/airquality.png',
                              height: 25.h,
                              width: 19.h,
                            ),
                          ),
                          Text(
                            avg_aqi.toStringAsFixed(2),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ], //<Widget>[]
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Image.asset

                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Temperature();
                              }));
                            },
                            child: Image.asset(
                              'assets/images/temperature.png',
                              height: 25.h,
                              width: 18.h,
                            ),
                          ),
                          Text(
                            avg_temperature.toStringAsFixed(2) + " °C",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ), // Image.asset

                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return Humidity();
                              }));
                            },
                            child: Image.asset(
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
                        ],
                      ),

                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return AirQuality();
                              }));
                            },
                            child: Image.asset(
                              'assets/images/airquality.png',
                              height: 25.h,
                              width: 19.h,
                            ),
                          ),
                          Text(
                            avg_aqi.toStringAsFixed(2),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ],
                  )), //Column
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  @override
  void dispose() {
    super.dispose();
    listener?.cancel();
  }
}
