import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/status.dart' as status;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:webcosketflutter/services/back_services.dart';

import 'services/notification_services.dart';

//void main() => runApp(new MyApp());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  await initializeService();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Map<String, dynamic> map = {'authorization': 'Bearer 4fgjf46f56'};

    initializeNotifications();

    return new MaterialApp(
      home: new MyHomePage(),
    );
  }

  Future<void> initializeNotifications() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initNotifications();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = new TextEditingController();
  String text = "stop service";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Web Socket"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Form(
              child: new TextFormField(
                decoration: new InputDecoration(labelText: "Send any message"),
                controller: editingController,
              ),
            ),
            new Form(
              child: new ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke('setAsForeground');
                },
                child: const Text("Foreground Service"),
              ),
            ),
            new Form(
              child: new ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke('setAsBackground');
                },
                child: const Text("Background Service"),
              ),
            ),
            new Form(
              child: new ElevatedButton(
                  onPressed: () async {
                    final service = FlutterBackgroundService();
                    bool isRunning = await service.isRunning();
                    if (isRunning) {
                      service.invoke("stopService");
                    } else {
                      service.startService();
                    }
                    if (!isRunning) {
                      text = "Stop Service";
                    } else {
                      text = "Start Service";
                    }
                    setState(() {});
                  },
                  child: Text("$text")),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.send), onPressed: Procesos),
    );
  }

  @override
  void dispose() {
    //widget.channel.sink.close();
    super.dispose();
  }

  void ConnectionWS(token) async {
    //final uri = Uri.parse(
    //"ws://b851-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app");
    final uri = Uri.parse("ws://" + serverURL);
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

  //final serverURL =
  //'b851-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app';
  final serverURL = '186.96.0.239:3000';
  // --- --- --- --- --- --- --- --- --- --- --- ---

  Future postData() async {
    var token = "empty";
    try {
      final response = await post(
          Uri.parse("https://" + serverURL + "/subscribe"),
          body: {});

      final sdsds = json.decode(response.body);
      token = sdsds["token"];

      print(response.body);
    } catch (er) {
      print(er);
    }

    return token;
  }
  // --- --- --- --- --- --- --- --- --- --- --- ---

  void Procesos() async {
    var token = await postData();

    if (token != "empty") {
      ConnectionWS(token);
    }
  }
}
