import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:io';
import 'package:flutter/material.dart';

class webSocket {
 List<String> messages = [];

  // var channel = IOWebSocketChannel.connect(Uri.parse('ws://192.168.10.102:9001'));
  // var channel = WebSocketChannel.connect(Uri.parse('ws://192.168.10.102:9001'));
  // var channel = WebSocketChannel.connect(Uri.parse('ws://10.230.30.204:22'));

  // late WebSocket _socket;
  var _socket;

  void socketInitialize (){
    // WebSocket.connect('ws://192.168.10.102:9001').then((socket) {
    WebSocket.connect('ws://192.168.128.124:9001').then((socket) {
      _socket = socket;
      // _socket.add("data");

      _socket.listen((socket) {
        // socket.transform(UTF8.decoder).listen(print);
        messages.add(socket.toString());
        // print(socket.toString());
      });
    });
  }
 void setListen() {
    // channel.stream.listen((data) {
    //   if (data.isNotEmpty) {
    //     messages.add(data);
    //   }
    //   // channel.sink.close(status.goingAway);
    // });
  }

  void sendMessage(data) {
    // if (data.isNotEmpty) {
    //   channel.sink.add(data);
    // }
    _socket.add(data);
  }

  // Future<bool> isSteamEmpty() {
  //   // return channel.stream.isEmpty;
  // }

  bool isMessageEmpty() {
   return messages.isEmpty;
  }

  dynamic getMessage() {
    return messages.isNotEmpty ? messages.removeAt(0) : "{}";
  }

  int streamAvailable() {
    return messages.length;
  }

  void dispose() {
    // channel.sink.close();
    _socket.close();
  }

}