import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:sdp_transform/sdp_transform.dart';

class CallingScreen extends StatefulWidget {
  @override
  _CallingScreenState createState() => _CallingScreenState();
}

enum FaceMode { FRONT, BACK }
enum CallStatus { CONNECTED, CALLING }

class _CallingScreenState extends State<CallingScreen> {
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  MediaStream _localStream;
  RTCPeerConnection _rtcPeerConnection;
  var candidate;

  FaceMode facing = FaceMode.FRONT;

  bool _answerButtonPressed, _declineButtonPressed, _offer = false;

  //////////////////////////////////////////////////////
  // Here are methods only, widgets are below in file //
  //////////////////////////////////////////////////////

  // INIT RENDERERS
  // - To initialise renderers and RTC_peer_connection
  Future _initialiseRederers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    // Peer connection is initialised here //
    await _createPeerConnection().then((peerConnection) {
      print('<<<<<<<<< Connection Peer Establised >>>>>>');
      print(peerConnection == null);
      _rtcPeerConnection = peerConnection;
    });
  }

  // INIT STREAMS
  // - To initialise MQTT streams
  Future _initialiseStreams() {
    // TODO : implement MQTT streams
  }

  // CREATE PEER CONNECTION
  Future<RTCPeerConnection> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:13.233.40.179"}
      ]
    };

    final Map<String, dynamic> offerConstraints = {
      "mandatory": {"OfferToReceiveAudio": true, "OfferToReceiveVideo": true},
      "optional": []
    };

    try {
      _localStream = await _getUserMedia();

      RTCPeerConnection rtcPeerConnection =
          await createPeerConnection(configuration, offerConstraints);

      print("<<<<<<<<<<<<< creating RTC Connection >>>>>>>>>>>>");
      // print('1. ${rtcPeerConnection == null}');

      // print('2. ${rtcPeerConnection == null}');

      rtcPeerConnection.onIceCandidate = (e) {
        print('>>>>>>>>>>>> On ICE Candidate  <<<<<<<<<');
        print(e.toMap());
        if (e.candidate != null && candidate == null) {
          candidate = json.encode({
            'candidate': e.candidate.toString(),
            'sdpMid': e.sdpMid.toString(),
            'sdpMlineIndex': e.sdpMlineIndex,
          });

          print('candidates : $candidate');
        }
      };

      // print('3. ${rtcPeerConnection == null}');

      rtcPeerConnection.onIceConnectionState = (e) {
        print('pcIceConnectionState : $e');
      };
      // print('4. ${rtcPeerConnection == null}');

      rtcPeerConnection.onAddStream = (stream) {
        print('add stream : ${stream.id}');
        print('stream : $stream');
        _remoteRenderer.srcObject = stream;
        print('remoteRenderer(addStream) : $_remoteRenderer');
      };
      // print('5. ${rtcPeerConnection == null}');

      return rtcPeerConnection;
    } catch (e) {
      print('>>>>>>>> Error Creating RTC Connection <<<<<<');
      print(e);
      return null;
    }
  }

  // GET USER MEDIA
  Future<MediaStream> _getUserMedia(
      {FaceMode facingMode = FaceMode.FRONT}) async {
    String faceing = facingMode == FaceMode.FRONT ? "user" : "environment";
    Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {'facingMode': faceing}
    };

    try {
      MediaStream mediaStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      _localRenderer.srcObject = mediaStream;
      // if (facingMode == FaceMode.FRONT) {
      //   _localRenderer.mirror = true;
      // }

      return mediaStream;
    } catch (e) {
      print('>>>>>>>>> Get User Media Error <<<<<<<');
      print(e);
      return null;
    }
  }

  // CREATE OFFER
  Future _createOffer() async {
    try {
      print('>>>>>>>>>>> Creating Offer <<<<<<<<<<<<<');
      print(_rtcPeerConnection == null);
      RTCSessionDescription rtcSessionDescription =
          await _rtcPeerConnection.createOffer({"OfferToReceiveVideo": true});
      var session = parse(rtcSessionDescription.sdp);
      var offerSessionBody = json.encode(session);
      print('createOffer sessionJsonBody : $offerSessionBody');
      print(
          '+-+-+-+-+-+-+-+-+-+-+- createOffer sessionJsonBody length : ${offerSessionBody.toString().length} -+-+-+-+-+-+-+-+-+-+-+-+');

      // repo.sendCallingMessage(widget.profile.userId, offerSessionBody, '5');
      _offer = true;

      await _rtcPeerConnection.setLocalDescription(rtcSessionDescription);

      return offerSessionBody;
    } catch (e) {
      print('>>>>>>>>>>>>> Create Offer Error <<<<<<<<<<');
      print(e);
    }
  }

  // SET REMOTE DESCRIPTION
  Future _setRemoteDescription(String remoteDescription) async {
    try {
      dynamic session = jsonDecode('$remoteDescription');

      String sdp = write(session, null);

      RTCSessionDescription sessionDescription =
          new RTCSessionDescription(sdp, _offer ? 'answer' : 'offer');

      print('sessionDescription : ${sessionDescription.toMap()}');
      print(
          '+-+-+-+-+-+-+-+-+-+-+- sessionDescription length : ${sessionDescription.toString().length} -+-+-+-+-+-+-+-+-+-+-+-+');

      await _rtcPeerConnection.setRemoteDescription(sessionDescription);
    } catch (e) {
      print('>>>>>>>>>>>>>> Set Remote Description Error <<<<<<<<<<<<');
      print(e);
    }
  }

  // SET CANDIDATE
  Future _setCandidate(String candidateDescription) async {
    try {
      dynamic session = jsonDecode('$candidateDescription');
      dynamic sessionCandidate = session['candidate'];
      print('sessionCandidate : $sessionCandidate');
      dynamic candidate = RTCIceCandidate(
          sessionCandidate, session['sdpMid'], session['sdpMlineIndex']);
      print(
          '+-+-+-+-+-+-+-+-+-+-+- candidate length : ${candidate.toString().length} -+-+-+-+-+-+-+-+-+-+-+-+');

      await _rtcPeerConnection.addCandidate(candidate);
    } catch (e) {
      print('>>>>>>>>>>>>>>> Set Candidate Error <<<<<<<<<<<<');
      print(e);
    }
  }

  // CREATE ANS
  Future _createAnswer() async {
    try {
      RTCSessionDescription rtcSessionDescription =
          await _rtcPeerConnection.createAnswer({"OfferToReceiveVideo": true});
      var session = parse(rtcSessionDescription.sdp);
      var ansSessionBody = json.encode(session);
      print('createAnswer sessionJsonBody : $ansSessionBody');
      print(
          '+-+-+-+-+-+-+-+-+-+-+- answer sessionJsonBody length : ${ansSessionBody.toString().length} -+-+-+-+-+-+-+-+-+-+-+-+');

      // repo.sendCallingMessage(widget.profile.userId, ansSessionBody, '6');
      await _rtcPeerConnection.setLocalDescription(rtcSessionDescription);

      return ansSessionBody;
    } catch (e) {
      print('>>>>>>>>>>> Create Answer Error <<<<<<<<<<');
      print(e);
    }
  }

  void _callEndingProcess() {
    // TODO : send call ending msg to end on both sides
    Navigator.of(context).pop();
  }

  //////////////////////////////
  // Widgets starts from here //
  //////////////////////////////

  /// ANS BUTTON
  Widget _answerButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: CircleAvatar(
        backgroundColor: _answerButtonPressed ? Colors.grey : Colors.green,
        radius: 40,
        child: IconButton(
            icon: Icon(
              Icons.call,
              size: 30,
              color: Colors.white,
            ),
            onPressed: _answerButtonPressed
                ? null
                : () async {
                    setState(() {
                      _answerButtonPressed = !_answerButtonPressed;
                    });
                    await _createOffer();
                  }),
      ),
    );
  }

  // DECLINE BUTTON
  Widget _declineButton() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: CircleAvatar(
        backgroundColor: _declineButtonPressed ? Colors.grey : Colors.red,
        radius: 40,
        child: IconButton(
            icon: Icon(
              Icons.call_end,
              size: 30,
              color: Colors.white,
            ),
            onPressed: _declineButtonPressed
                ? null
                : () {
                    setState(() {
                      _declineButtonPressed = !_declineButtonPressed;
                    });
                    _callEndingProcess();
                  }),
      ),
    );
  }

  @override
  void initState() {
    _initialiseRederers();
    super.initState();
  }

  @override
  void dispose() {
    _localRenderer?.dispose();
    _remoteRenderer?.dispose();
    _rtcPeerConnection?.close();
    _rtcPeerConnection?.dispose();
    _localStream?.dispose();
    // _streamSubscription.pause();
    // _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
