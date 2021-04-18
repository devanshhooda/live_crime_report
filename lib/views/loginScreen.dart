import 'package:flutter/material.dart';
import 'package:live_crime_report/views/homePage.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneNumber, _password;

  Widget _loginButton() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: MaterialButton(
        child: Text('Login'),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => HomePage()));
        },
      ),
    );
  }

  Widget _inputFields(TextEditingController _controller,
      TextInputType inputType, IconData icn, String _hintText) {
    return Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.black12),
        margin: EdgeInsets.symmetric(
          horizontal: 7,
        ),
        child: new TextFormField(
          controller: _controller,
          style: TextStyle(
              fontWeight: FontWeight.w600, color: Colors.black, fontSize: 17),
          keyboardType: inputType,
          cursorWidth: 2,
          cursorHeight: 5,
          cursorColor: Colors.red,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            hintText: '$_hintText',
            border: InputBorder.none,
            icon: Icon(
              icn,
              size: 25,
            ),
          ),
        ));
  }

  Widget _loginSection() {
    return Container(
      height: 400,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _inputFields(
                _phoneNumber, TextInputType.phone, Icons.call, 'Phone Number'),
            _inputFields(
                _password, TextInputType.text, Icons.vpn_key, 'Password'),
            _loginButton()
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Text(
                'LIVE CRIME REPORT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            _loginSection()
          ],
        ),
      ),
    );
  }
}
