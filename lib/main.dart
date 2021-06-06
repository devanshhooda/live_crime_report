import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:live_crime_report/data/repository.dart';
import 'package:live_crime_report/views/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CrimeReportApp());
}

class CrimeReportApp extends StatefulWidget {
  @override
  _CrimeReportAppState createState() => _CrimeReportAppState();
}

class _CrimeReportAppState extends State<CrimeReportApp> {
  AppRepository repository;

  @override
  void initState() {
    repository = new AppRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(repository: repository),
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.red, primaryColor: Colors.redAccent),
      // darkTheme: ThemeData.dark(),
    );
  }
}
