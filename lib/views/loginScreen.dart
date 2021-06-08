import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_crime_report/data/repository.dart';
import 'package:live_crime_report/models/userProfile.dart';
import 'package:live_crime_report/views/homePage.dart';

class LoginScreen extends StatefulWidget {
  final AppRepository repository;
  LoginScreen({@required this.repository});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // logo or title of app comes here
  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'LIVE      CRIME     REPORT',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
    );
  }

  Widget _googleLoginButton() {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.white),
      padding: EdgeInsets.symmetric(vertical: 30),
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            child: Text(
              'Login with',
              style: TextStyle(fontSize: 20),
            ),
            onPressed: () async {
              // UserProfile _userProfile = await widget.repository.userLogin();
              Navigator.of(context)
                  .push(CupertinoPageRoute(builder: (_) => HomePage()));
            },
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            child: Image.asset(
              'assets/googleLogo.png',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff242B2E),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_titleWidget(), _googleLoginButton()],
          ),
        ),
      ),
    );
  }
}
