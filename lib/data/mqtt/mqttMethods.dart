import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';
import 'mqttAppState.dart';
import 'mqttManager.dart';

class MQTTmethods {
  MQTTAppState currentAppState;
  MQTTManager manager;

  MQTTmethods() {
    currentAppState = new MQTTAppState();
  }

  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
    }
  }

  Future<String> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Future<void> configureAndConnect() async {
    String deviceID = await _getId();
    manager = MQTTManager(
        host: 'test.mosquitto.org',
        topic: 'baka',
        identifier: deviceID,
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  void disconnect() {
    manager.disconnect();
  }

  Future<void> publishMessage({@required String text}) async {
    manager.publish(text);
  }
}
