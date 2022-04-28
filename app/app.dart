import 'package:flutter/material.dart';
import 'QRCodePage.dart';
import 'GlobalVar.dart';
import 'dart:async';

void main() {

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("stete = $state");
    switch (state) {
      case AppLifecycleState.inactive:
        print('非アクティブになったときの処理');
        break;
      case AppLifecycleState.paused:
        print('停止されたときの処理');
        break;
      case AppLifecycleState.resumed:
        print('再開されたときの処理');
        break;
      case AppLifecycleState.detached:
        print('破棄されたときの処理');
        socketChannel.dispose();
        break;
    }
  }

  runApp(MaterialApp(home:Logo()));
}

class Logo extends StatefulWidget{

  @override
  LogoState createState() => LogoState();
}

class LogoState extends State<Logo> {
  late BuildContext extraContext;

  void changeScreen(context) {
    Future(() async {
      await Future.delayed(const Duration(milliseconds: 2000), (){
        // Future(() async {
        //   await Future.delayed(Duration(seconds: 5));
        // });
        // print("e");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const TabBarDemo(),
          ),
        );
      });
    });
  }

  void initState() {
    super.initState();
    socketChannel.socketInitialize();
    WidgetsBinding.instance!.addPostFrameCallback((_) => changeScreen(context));
  }

  @override
  Widget build(BuildContext context){
    extraContext = context;
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/images/LOGO.png'),
        )
      ),
    );
  }
}

