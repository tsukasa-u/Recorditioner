import 'package:syncfusion_flutter_charts/charts.dart';

import 'WebSocket.dart';


// BuildContext? extracontext;
String? SerialNumber;

List<bool> isSelectedDate = [
  true,
  false,
  false,
  false,
];

webSocket socketChannel = webSocket();

class Data {
  var x; //グラフの横軸になる日付
  var y; //グラフの縦軸になる数値

  Data(this.x, this.y);
}

// List<List<List<Data>>> dataList = [[[]]];

List<Map<DateTime, List<List<Data>>>> dataList = [
  {},
  {},
  {},
  {},
];

List<List<Data>> chartData = List.generate(4, (i)=><Data>[]);
List<List<Data>> emptyData = List.generate(4, (i)=><Data>[]);

DateTime nowDate = DateTime.now();

ChartSeriesController? chartSeriesController1;
ChartSeriesController? chartSeriesController2;
ChartSeriesController? chartSeriesController3;

bool isCancel = false;


