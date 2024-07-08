import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/status.dart' as status;
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> map = {'authorization': 'Bearer 4fgjf46f56'};

    return new MaterialApp(
      home: new MyHomePage(
          //channel: new IOWebSocketChannel.connect("ws://echo.websocket.org"),
          //channel: IOWebSocketChannel();
          //channel: new IOWebSocketChannel.connect(
          //"ws://37d9-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app",
          //headers: {'authorization': 'Bearer 151dfg51dffbdf'},
          //headers: {
          //'Content-type': 'application/json',
          //'Accept': 'application/json',
          //'Authorization': 'Bearer 151dfg51dffbdf'
          //}
          //headers: Headers.getHeaderParameters(),
          //headers: map,

          //headers: new Map("authorization": "Bearer 4fgjf46f56")
          //headers: {
          //'Content-type': 'application/json',
          //'Accept': 'application/json',
          //'authorization': 'Bearer 4fgjf46f56'
          //}
          //),
          ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //final WebSocketChannel channel;

  //MyHomePage(//{required this.channel});

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
            //new StreamBuilder(
            //stream: widget.channel.stream,
            //builder: (context, snapshot) {
            //return new Padding(
            //padding: const EdgeInsets.all(20.0),
            //child: new Text(snapshot.hasData ? '${snapshot.data}' : ''),
            //);
            //},
            //),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.send),
          //onPressed: _sendMyMessage,
          //onPressed: newConnection, // <--*
          onPressed: ConnectionWS),
    );
  }

  void _sendMyMessage() {
    if (editingController.text.isNotEmpty) {
      //widget.channel.sink.add("authorization : Bearer 445464");
      //widget.channel.sink.add(editingController.text);
    }
  }

  @override
  void dispose() {
    //widget.channel.sink.close();
    super.dispose();
  }

  void ConnectionWS() async {
    final uri = Uri.parse(
        "ws://b851-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app");
    final headersX = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'authorization': 'Bearer 151dfg51dffbdf',
      'othertoken': 'e15345dsfsdfhgyj'
    };

    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        headers: headersX,
      );

      final channel = IOWebSocketChannel(socket);

      channel.stream.listen((message) {
        print('Received: $message');
      });

      channel.sink.add('Hello, WebSocket!');
    } catch (e) {
      print('Error: $e');
    }
  }

/*
  void ConnectionHttpWS() async {
    final uri = Uri.parse(
        "ws://37d9-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app");
    final headers = {
      'authorization': 'Bearer 151dfg51dffbdf',
    };

    try {
      final request = http.Request('GET', uri)..headers.addAll(headers);

      final response = await http.Client().send(request);

      if (response.statusCode == 101) {
        // HTTP 101 Switching Protocols
        final socket = await response.detachSocket();
        final channel = WebSocketChannel(socket);

        channel.stream.listen((message) {
          print('Received: $message');
        });

        channel.sink.add('Hello, WebSocket!');
      } else {
        print('Failed to connect: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/

  void newConnection() {
    /*
    final IO.Socket _socket = IO.io(
        serverURL,
        IO.OptionBuilder()
            .disableAutoConnect()
            //.setTransports(['websocket'])
            //.setAuth({'authorization': 'Bearer 4fgjf46f56'})
            .build());*/

    IO.Socket sssssocket = IO.io(
        serverURL,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            //.setExtraHeaders({'foo': 'bar'}) // optional
            .setExtraHeaders({
              'authorization': 'Bearer e15345dsfsdfhgyj',
              'foo': 'bar',
              'othertoken': 'e15345dsfsdfhgyj'
            })
            .build());

    sssssocket.onConnect((data) => print('Connection established'));
    sssssocket.onConnectError((data) => print('Connec Error: $data'));
    sssssocket.onDisconnect((data) => print('Socket.IO server disconnected'));
    sssssocket.connect();
  }

  final serverURL =
      'ws://b851-2806-2f0-90a0-da95-b18f-e798-92b0-ed0d.ngrok-free.app';
}
