import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'PageSelector.dart';
import 'GlobalVar.dart';
import 'Graph.dart';
import 'DateSelector.dart';
import 'readBinary.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key, jsonData}) : super(key: key);
  Map<String, dynamic>? jsonData;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // _HomeScreenState(jsonData);
  // Map<String, dynamic>? jsonData;

  @override
  void initState()  {
    Timer.periodic(const Duration(seconds:10),updateDataSource);
  }

  void updateDataSource(Timer time) async{
    // //時間の取得
    // var now = DateTime.now();
    // var formatter = DateFormat('y-M-d-H-m-s');
    // var formattedTime = formatter.format(now);
    // //string型のdateListをdateTime型にする
    // var date = formatter.parse(formattedTime);
    // //dateList.add(date);
    // //numberList.add(i);
    // chartData[vari!].add(Data(date,i*(vari!+1)));
    // // chartData[vari!].add(Data(date,0));
    // i++;

    // chartSeriesController1?.updateDataSource(
    //     addedDataIndex: chartData[0].length + 1,
    //     // updatedDataIndexes: List.generate(chartData.length, (i)=>i),
    // );

    socketChannel.sendMessage(
        """{
              \"id\":\"$SerialNumber\",
              \"data\":-1
              }"""
    );
    // while(socketChannel.streamAvailable()==0) {
    while (socketChannel.isMessageEmpty()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    String dataMes = socketChannel.getMessage();
    print(dataMes);
    if (dataMes != '[]') {
      readBinary(
          dataMes.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((
              String item) => int.parse(item)).toList(), true);
      setState(() {
        chartSeriesController1?.updateDataSource(
          // addedDataIndex: chartData.length + 1,
          // removedDataIndexes: List.generate(chartData.length, (i)=>i),
          updatedDataIndexes: List.generate(chartData[0].length, (i) => i),
        );
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    nowDate = (await showDatePicker(
      context: context,
      initialDate: nowDate,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    ))!;
    setState(() {
      if (isSelectedDate[0]) {
        DateFormat outputFormat = DateFormat('H-m-s');
        DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
        chartData = (dataList[0].containsKey(selectedDate) ? dataList[0][selectedDate] : emptyData)!;
      } else if (isSelectedDate[1]) {
        DateFormat outputFormat = DateFormat('y-M-d');
        DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
        chartData = (dataList[1].containsKey(selectedDate) ? dataList[1][selectedDate] : emptyData)!;
      } else if (isSelectedDate[2]) {
        DateFormat outputFormat = DateFormat('y-M');
        DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
        chartData = (dataList[2].containsKey(selectedDate) ? dataList[2][selectedDate] : emptyData)!;
      } else if (isSelectedDate[3]) {
        DateFormat outputFormat = DateFormat('y');
        DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
        chartData = (dataList[3].containsKey(DateTime(1970)) ? dataList[0][DateTime(1970)] : emptyData)!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child:Scaffold(
          drawer: PageSelecter(),
          appBar: AppBar(
            title: Text('$SerialNumber' /*ここにデバイス名を入れる*/),
            backgroundColor: Colors.blue,
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'TEMP', icon: Icon(Icons.device_thermostat)),
                Tab(text: 'HUM', icon: Icon(Icons.water)),
                Tab(text: 'VIBES', icon: Icon(Icons.vibration)),
                Tab(text: 'UV', icon: Icon(Icons.wb_sunny)),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                onPressed: () {
                  _selectDate(context);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                onPressed: () {
                  null;
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Column(children: [const DateSelector(), drawGraph(vari: 0),],),
              Column(children: [const DateSelector(), drawGraph(vari: 1),],),
              Column(children: [const DateSelector(), drawGraph(vari: 2),],),
              Column(children: [const DateSelector(), drawGraph(vari: 3),],),
            ],
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          // floatingActionButton: FloatingActionButton(
          //   child : const Icon(
          //     Icons.calendar_today,
          //   ),
          //   onPressed: () {},
          // ),
        ),

      ),
    );

  }
}

class Clock extends StatefulWidget{
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock>{
  String time = '';
  @override
  void initState(){
    Timer.periodic(
      const Duration(seconds: 1),
      _onTimer,
    );
    super.initState();
  }
  void _onTimer(Timer timer){
    var now = DateTime.now();
    var formatter = DateFormat('yMd:HH:mm:ss');
    var formattedTime = formatter.format(now);
    setState(()=> time = formattedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style:const TextStyle(
        fontSize:60.0,
        fontFamily: 'IBMPlexMono',
      ),
    );
  }
}