import 'package:flutter/material.dart';
import 'package:live_crime_report/views/homePage.dart';
import 'package:live_crime_report/views/loginScreen.dart';
import 'data/repository.dart';
import 'models/userProfile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  _getUser() async {
    return await repository.getUserFromSP();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: repository.getStringFromSP(key: 'name'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserProfile _user = _getUser();
              return HomePage(userProfile: _user);
            } else {
              return LoginScreen();
            }
          }),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red, primaryColor: Colors.yellow[800]),
    );
  }
}
