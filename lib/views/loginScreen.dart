import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_crime_report/views/homePage.dart';
import '../models/userProfile.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool filled = false;
  String msg = '';
  TextStyle _titleStyle = new TextStyle(
      fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white);

  // logo or title of app comes here
  Widget _titleWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'LIVE',
            style: _titleStyle,
          ),
          Text(
            'CRIME',
            style: _titleStyle,
          ),
          Text(
            'REPORT',
            style: _titleStyle,
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.yellow),
      // padding: EdgeInsets.symmetric(vertical: 30),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: MaterialButton(
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20),
        ),
        onPressed: () async {
          if (filled) {
            setState(() {
              msg = '';
            });

            UserProfile profile = new UserProfile(
                name: _name.text, phoneNumber: _phoneNumber.text);

            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                    builder: (_) => HomePage(userProfile: profile)),
                (route) => false);
          } else {
            setState(() {
              msg = 'Please enter both the info';
            });
          }
        },
      ),
    );
  }

  final TextStyle _inputeTextStyle = new TextStyle(
      fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87);
  final TextStyle _hintStyle = TextStyle(fontSize: 17, color: Colors.black45);

  TextEditingController _name = new TextEditingController();
  TextEditingController _phoneNumber = new TextEditingController();

  Widget _inputField(String type) {
    return new Container(
        height: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        margin: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        padding: EdgeInsets.only(left: 10, top: 10),
        child: new TextField(
          controller: type == 'u' ? _name : _phoneNumber,
          style: _inputeTextStyle,
          keyboardType: type == 'u' ? TextInputType.name : TextInputType.phone,
          cursorWidth: 2,
          cursorColor: Colors.yellow,
          textCapitalization:
              type == 'u' ? TextCapitalization.words : TextCapitalization.none,
          decoration: InputDecoration(
            hintText: type == 'u' ? 'Name' : 'Phone Number',
            hintStyle: _hintStyle,
            border: InputBorder.none,
            icon: Icon(
              type == 'u' ? Icons.person : Icons.phone,
              size: 20,
            ),
          ),
          onChanged: (val) {
            checkFilled();
          },
        ));
  }

  Widget _errMsg() {
    return Container(
      child: Text(
        msg,
        style: TextStyle(color: Colors.pinkAccent),
      ),
    );
  }

  void checkFilled() {
    if (_phoneNumber != null &&
        _name != null &&
        _phoneNumber.text.isNotEmpty &&
        _name.text.isNotEmpty) {
      setState(() {
        filled = true;
      });
    } else {
      setState(() {
        filled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff242B2E),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _titleWidget(),
              _inputField('u'),
              _inputField('p'),
              _loginButton(),
              _errMsg(),
            ],
          ),
        ),
      ),
    );
  }
}
