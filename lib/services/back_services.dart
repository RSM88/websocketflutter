import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:webcosketflutter/services/notification_services.dart';

int num = 0;

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  procesos(); // --- just for test
  await service.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
        onStart: onStart, isForegroundMode: true, autoStart: true),
  );
}

@pragma("vm:entry-point")
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsBackgroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
            title: "Notification", content: "service running ... $num");
      }
    }

    print("background service running ... $num");
    service.invoke('update');

    num = num + 1;
  });
}

// ***** ***** ***** ***** ***** ***** ***** ***** *****
//--------------------------------

void procesos() async {
  var token = await postData();

  if (token != "empty") {
    connectionWS(token);
  }
}

// ----- ----- ----- ----- ----- ----- -----
//const serverURL = '186.96.0.239:3000';
const serverURL = '68bb-2806-2f0-90a0-da95-ac58-74fa-a0c3-936b.ngrok-free.app';

//--------------------------------
Future postData() async {
  var token = "empty";
  try {
    final response =
        await post(Uri.parse("https://$serverURL/subscribe"), body: {});

    final sdsds = json.decode(response.body);
    token = sdsds["token"];

    print(response.body);
  } catch (er) {
    print(er);
  }

  return token;
}

// ----- ----- ----- ----- ----- ----- -----
void connectionWS(token) async {
  //final uri = Uri.parse(
  //"ws://b851-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app");
  final uri = Uri.parse("ws://$serverURL");
  final headersX = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'authorization': 'Bearer 151dfg51dffbdf',
    'othertoken': token
  };

  try {
    final socket = await WebSocket.connect(
      uri.toString(),
      headers: headersX,
    );

    final channel = IOWebSocketChannel(socket);

    channel.stream.listen((message) {
      print('Received: $message');
      final jsonData = json.decode(message);
      mostrarNotificacion(jsonData["title"], jsonData["message"]);
    });

    channel.sink.add('Hello, WebSocket!');
  } catch (e) {
    print('Error: $e');
  }
}
 // ----- ----- ----- ----- ----- ----- -----
 // ***** ***** ***** ***** ***** ***** ***** ***** *****