import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:untitled/a/readBinary.dart';
import 'AnalysisPage.dart';
import 'PageSelector.dart';
import 'GlobalVar.dart';

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // extracontext = context;
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: PageSelecter(),
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.manage_search), text: 'SEARCH'),
                Tab(icon: Icon(Icons.qr_code_scanner), text: 'QR CODE'),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: TabBarView(
            children: [
              // const Icon(Icons.manage_search),
              _searchAreaFrom(),
              // Text('test')
              // const Icon(Icons.qr_code_scanner),
              _QRSCANArea(),
            ],
          ),
        ),
      ),
    );
  }
}

class _searchAreaFrom extends StatelessWidget {
  // _searchAreaFrom({Key? key, BuildContext? context}) : super(key: key);


  final _formKey = GlobalKey<FormState>();

  void _submission(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>NextPage(),)
      );
      // ScaffoldMessenger.of(extracontext).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    // BuildContext? extracontext = context;
    // String _name = '';

    return Form(
        key: _formKey,
        child: Container(
            margin: const EdgeInsets.fromLTRB(32.0, 16.0, 32.0, 0.0),
            // child: Text("test")
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TextFormField(
                  enabled: true,
                  maxLength: 13,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter serial number',
                    labelText: 'Serial number',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'fill the text form';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (String? value) {
                    // _name = value!;
                    SerialNumber = value;
                  },
                ),
                ElevatedButton(
                  // onPressed: (Buildcontext? context)//_submission(context),{
                  //   if (_formKey.currentState!.validate()) {}
                  // },
                    child: const Text('submit'),
                    onPressed: ()
                    {
                      _submission(context);
                      // socketChannel.sendMessage(SerialNumber);
                      // while(socketChannel.isSteamEmpty() == Future<bool>.value(true)) {
                      //   Future.delayed(const Duration(milliseconds: 100));
                      // }
                      // var jsonData = jsonDecode(socketChannel.getMessage());
                      // if (SerialNumber!.isNotEmpty){
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(builder: (context)=>NextPage(),)
                      //   );
                      // }
                    }
                )
              ],
            )
        )
    );
  }

}


class _QRSCANArea extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      allowDuplicates: false,
      onDetect: (barcode, args) {
        // final String? code = barcode.rawValue;
        SerialNumber = barcode.rawValue;
        // socketChannel.sendMessage(SerialNumber);
        // while(socketChannel.isSteamEmpty() == Future<bool>.value(true)) {
        //   Future.delayed(const Duration(milliseconds: 100));
        // }
        // var jsonData = jsonDecode(socketChannel.getMessage());
        // debugPrint('Barcode found! $code');
        // _QRSCANdialog(extracontext);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context)=>NextPage(), )
        );
      }
    );
  }
}

class NextPage extends StatefulWidget {
  @override
  State createState() {return NextPageState();}
}

// class NextPageState extends State<NextPage> {
class NextPageState extends State<NextPage> {

  late Map<String, dynamic>? jsonInfo = {
    "id" : "",
    "measurement" : "",
    "info" : "",
  };

  late Map<String, dynamic>? jsonData = {  };

  var confirmState = true;

  @override
  void dispose() {
    isCancel = true;
    super.dispose();
  }

  @override
  void initState() {
    isCancel = false;
    socketChannel.setListen();
    Future(() async {
      socketChannel.sendMessage(
          """{
              \"id\":\"$SerialNumber\",
              \"data\":0
              }"""
      );
      // while(socketChannel.streamAvailable()==0) {
      while (socketChannel.isMessageEmpty()) {
        await Future.delayed(const Duration(milliseconds: 100));
        // print (socketChannel.getMessage());
        if (isCancel == true) return;
      }
      // print ("e");
      String dataMes = socketChannel.getMessage();
      print(dataMes);
      var jsonList;
      if (dataMes.isNotEmpty) {
        jsonList = jsonDecode(dataMes.replaceAll("\'", "\""));
      }

      resetBinary();
      print(jsonList);
      for (var element in jsonList!["data"]) {
        socketChannel.sendMessage(
            """{
                \"id\":\"$SerialNumber\",
                \"data\":\"$element\"
            }"""
        );
        print(element);
        // while (socketChannel.streamAvailable() == 0) {
        while (socketChannel.isMessageEmpty()) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (isCancel) return;
        }
        String dataMes = socketChannel.getMessage();
        print(dataMes);
        if (dataMes.isNotEmpty) {
          if (element == "info") {
            print("INFO!!");
            setState(() {
              jsonInfo = jsonDecode(dataMes.replaceAll("\'", "\""));
            });
          } else {
            print("NOT INFO!!");
            while (/*socketChannel.isMessageEmpty()*/socketChannel.messages.isEmpty) {
              await Future.delayed(const Duration(milliseconds: 1000));
              if (isCancel) return;
            }
            String dataMes = socketChannel.getMessage();
            // print(dataMes);
            Future<int> ret = readBinary(dataMes.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((String item) => int.parse(item)).toList(), false);
            while (ret==1) {
              await Future.delayed(const Duration(milliseconds: 100));
              if (isCancel) return;
            }

            chartSeriesController1?.updateDataSource(
              updatedDataIndexes: List.generate(chartData[0].length, (i)=>i),
            );
          }
        }
      }
      setState(() {
        confirmState = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NextPage'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          LinearProgressIndicator(
            // value: controller.value,
            semanticsLabel: 'Linear progress indicator',
            value: confirmState ? null : 1,
          ),
          Container(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 200.0,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("id:"),
                            Text(jsonInfo!["id"]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("measurement:"),
                            Text(jsonInfo!["measurement"]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text("info:"),
                            Text(jsonInfo!["info"]),
                          ],
                        ),
                      ],
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: confirmState ? null : () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => HomeScreen(jsonData: jsonInfo),
                            ),
                                (route) => false,
                          );
                        },
                        // onPressed : null,
                        child: Text('Confirm'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          isCancel = true;
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}