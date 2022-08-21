import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/link.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
          appBar: AppBar(
            title: const Text('About'),
            backgroundColor: Colors.blueAccent,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "VIT Weather Station",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  "Group Members:\n\n1. Akshaj Raut\n2. Anup Kanse\n3. Harish Karnam\n4. Nikunj Tandan\n5. Sonali Bedade\n6. Aditya Agashe\n7. Oj Uparkar",
                  style: TextStyle(fontSize: 20),
                ),
                Link(
                  target: LinkTarget.self,
                  uri: Uri.parse("https://twitter.com/VIT_Weather"),
                  builder: (context, followLink) => ElevatedButton(
                    onPressed: (followLink),
                    child: Text("View on Twitter"),
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
