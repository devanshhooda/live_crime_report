import 'package:flutter/material.dart';
import 'package:live_crime_report/views/homePage.dart';

void main() {
  runApp(CrimeReportApp());
}

class CrimeReportApp extends StatefulWidget {
  @override
  _CrimeReportAppState createState() => _CrimeReportAppState();
}

class _CrimeReportAppState extends State<CrimeReportApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.red, primaryColor: Colors.redAccent),
      // darkTheme: ThemeData.dark(),
    );
  }
}
