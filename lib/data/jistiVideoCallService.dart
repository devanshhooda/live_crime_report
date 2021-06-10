import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';

import '../models/userProfile.dart';

class JitsiVideoCallService {
  final serverText = TextEditingController();

  joinMeeting({UserProfile profile}) async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;
    final String roomId = "crime-report-server";

    try {
      Map<FeatureFlagEnum, bool> featureFlag = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
        FeatureFlagEnum.CALL_INTEGRATION_ENABLED: false,
        FeatureFlagEnum.CHAT_ENABLED: false,
        FeatureFlagEnum.RAISE_HAND_ENABLED: false,
        FeatureFlagEnum.MEETING_NAME_ENABLED: false,
        FeatureFlagEnum.MEETING_PASSWORD_ENABLED: false,
      };

      var options = JitsiMeetingOptions(room: roomId)
        ..serverURL = serverUrl
        ..subject = 'Live crime reporting'
        ..userDisplayName = profile.name
        ..audioOnly = false
        ..audioMuted = false
        ..videoMuted = false
        ..userEmail = profile.phoneNumber
        ..featureFlags = featureFlag;

      // debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(
            onConferenceWillJoin: (message) {
              debugPrint("${options.room} will join with message: $message");
            },
            onConferenceJoined: (message) {
              debugPrint("${options.room} joined with message: $message");
            },
            onConferenceTerminated: (message) {
              debugPrint("${options.room} terminated with message: $message");
            },
            genericListeners: [
              JitsiGenericListener(
                  eventName: 'readyToClose',
                  callback: (dynamic message) {
                    debugPrint("readyToClose callback");
                  }),
            ]),
        // by default, plugin default constraints are used
        roomNameConstraints: new Map(), // to disable all constraints
        //roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  void _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }

  void endMeeting() {
    JitsiMeet.closeMeeting();
    print('Call ended');
  }
}
