import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'GlobalVar.dart';
import 'readBinary.dart';


// ChartSeriesController? _chartSeriesController1;
// ChartSeriesController? _chartSeriesController2;
// ChartSeriesController? _chartSeriesController3;

class drawGraph extends StatefulWidget{
  drawGraph({Key? key, this.vari}) : super(key: key);
  final int? vari;

  @override
  _drawGraphState createState() => _drawGraphState(vari);
}

class _drawGraphState extends State<drawGraph>{
  final int? vari;
  _drawGraphState(this.vari);

  int i=0;//グラフに入れる仮の値

  @override
  void initState(){
    // print(vari);
    // chartData[vari!] = graphData();
    // Timer.periodic(const Duration(minutes:10),updateDataSource);
    super.initState();

  }

  @override
  Widget build(BuildContext context){
    return SfCartesianChart(
      series:<LineSeries<Data,DateTime>>[
        LineSeries<Data,DateTime>(
          onRendererCreated: (ChartSeriesController controller){
            chartSeriesController1 = controller;
          },
          dataSource: chartData[vari!],
          color:const Color.fromRGBO(192,108,132,1),
          xValueMapper: (Data data, _) => data.x,
          yValueMapper: (Data data, _) => data.y,
        ),
        LineSeries<Data,DateTime>(
          onRendererCreated: (ChartSeriesController controller){
            chartSeriesController2 = controller;
          },
          dataSource: chartData[vari!],
          color:const Color.fromRGBO(192,0,132,1),
          xValueMapper: (Data data, _) => data.x,
          yValueMapper: (Data data, _) => data.y,
        ),
        LineSeries<Data,DateTime>(
          onRendererCreated: (ChartSeriesController controller){
            chartSeriesController3 = controller;
          },
          dataSource: chartData[vari!],
          color:const Color.fromRGBO(192,108,0,1),
          xValueMapper: (Data data, _) => data.x,
          yValueMapper: (Data data, _) => data.y,
        ),
      ],
      primaryXAxis: DateTimeAxis(
          majorGridLines: const MajorGridLines(width:0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          intervalType: DateTimeIntervalType.minutes,
          title:AxisTitle(text: 'time')
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width:0),
          majorTickLines: const MajorTickLines(width:0),
          title: AxisTitle(text:'value')
      ),
    );
  }

// //日付を入れる
//   void updateDataSource(Timer time) async{
//     // //時間の取得
//     // var now = DateTime.now();
//     // var formatter = DateFormat('y-M-d-H-m-s');
//     // var formattedTime = formatter.format(now);
//     // //string型のdateListをdateTime型にする
//     // var date = formatter.parse(formattedTime);
//     // //dateList.add(date);
//     // //numberList.add(i);
//     // chartData[vari!].add(Data(date,i*(vari!+1)));
//     // // chartData[vari!].add(Data(date,0));
//     // i++;
//
//     // chartSeriesController1?.updateDataSource(
//     //     addedDataIndex: chartData[0].length + 1,
//     //     // updatedDataIndexes: List.generate(chartData.length, (i)=>i),
//     // );
//
//     socketChannel.sendMessage(
//         """{
//               \"id\":\"$SerialNumber\",
//               \"data\":-1
//               }"""
//     );
//     // while(socketChannel.streamAvailable()==0) {
//     while (socketChannel.isMessageEmpty()) {
//       await Future.delayed(const Duration(milliseconds: 100));
//     }
//     String dataMes = socketChannel.getMessage();
//     setState(() {
//       readBinary(dataMes.replaceAll('[', '').replaceAll(']', '').split(',').map<int>((String item) => int.parse(item)).toList(), true);
//       chartSeriesController1?.updateDataSource(
//         // addedDataIndex: chartData.length + 1,
//         // removedDataIndexes: List.generate(chartData.length, (i)=>i),
//         updatedDataIndexes: List.generate(chartData[0].length, (i)=>i),
//       );
//     });
//   }

  List<Data> graphData(){
    return <Data>[];
  }
}
//
// class LineConfig{
//
//   @override
//   Widget build(BuildContext context){
//
//   }
//   return
// }
