import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/status.dart' as status;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'services/notification_services.dart';

void main() => runApp(new MyApp());

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
    final uri = Uri.parse(
        "ws://b851-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app");
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

  final serverURL =
      'b851-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app';

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
