import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_crime_report/data/jistiVideoCallService.dart';

import '../models/userProfile.dart';

class HomePage extends StatefulWidget {
  UserProfile userProfile;

  HomePage({@required this.userProfile});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> authoritiesNames = [
    'Police',
    'Ambulance',
    'Fire Brigade',
    'Bomb Squad'
  ];
  List<bool> boolVals = [false, false, false, false];
  List<List<Color>> clrGradients = [
    [Colors.amber, Colors.green],
    [Colors.red, Colors.white, Colors.redAccent],
    [Colors.red, Colors.yellow],
    [Colors.green, Colors.grey]
  ];
  JitsiVideoCallService _jitsiVideoCallService;
// AUTHORITY WIDGET
  Widget _authorityWidget(int idx) {
    return MaterialButton(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: clrGradients[idx],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(20)),
            child: GridTile(
              child: Container(
                  child: Center(
                child: Text(
                  '${authoritiesNames[idx]}',
                  style: TextStyle(fontSize: 17),
                ),
              )),
              footer: CheckboxListTile(
                  value: boolVals[idx],
                  onChanged: (val) {
                    setState(() {
                      boolVals[idx] = val;
                    });
                  }),
            )),
      ),
      onPressed: () {
        print('call authority ${authoritiesNames[idx]}');
        setState(() {
          boolVals[idx] = !boolVals[idx];
        });
      },
    );
  }

  Widget _authoritiesGridView() {
    return Container(
      child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: authoritiesNames.length,
          itemBuilder: (BuildContext context, int idx) {
            return _authorityWidget(idx);
          }),
    );
  }

  Widget _appBar() {
    return AppBar(
      backgroundColor: Colors.red,
      title: Container(
        child: Text('LIVE CRIME REPORT'),
      ),
      centerTitle: true,
    );
  }

  Widget _floatingCallButton() {
    return FloatingActionButton(
        child: Icon(Icons.videocam_rounded),
        onPressed: () async {
          await _jitsiVideoCallService.joinMeeting(profile: widget.userProfile);
          // Navigator.of(context).push(CupertinoPageRoute(
          //     builder: (_) =>
          //     CallingScreen(
          //           callMute: false,
          //         )));
        });
  }

  @override
  void initState() {
    _jitsiVideoCallService = new JitsiVideoCallService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.black,
      floatingActionButton: _floatingCallButton(),
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        child: _authoritiesGridView(),
      ),
    );
  }
}
