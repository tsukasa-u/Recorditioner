import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'GlobalVar.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({Key? key}) : super(key: key);

  @override
  _DateSelector createState() => _DateSelector();
}

class _DateSelector extends State<DateSelector> {


  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;

    return Padding(
        padding: const EdgeInsets.all(15),
        child: ToggleButtons(
          children: const <Widget>[
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5), child: Text("hour")),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5), child: Text("day")),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5), child: Text("month")),
            Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5), child: Text("year")),
          ],
          constraints: BoxConstraints(
            minWidth: _screenSize.width*0.20,
            maxWidth: _screenSize.width*0.23,
          ),
          onPressed: (int index) {
            setState(() {
              for (int buttonIndex = 0; buttonIndex < isSelectedDate.length; buttonIndex++) {
                if (buttonIndex == index) {
                  isSelectedDate[buttonIndex] = true;
                } else {
                  isSelectedDate[buttonIndex] = false;
                }
              }
              chartSeriesController1?.updateDataSource(
                // addedDataIndex: chartData.length + 1,
                removedDataIndexes: List.generate(chartData[0].length, (i)=>i),
                // updatedDataIndexes: List.generate(chartData.length, (i)=>i),
              );
              if (isSelectedDate[0]) {
                DateFormat outputFormat = DateFormat('H-m-s');
                DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
                chartData = (dataList[0].containsKey(selectedDate) ? dataList[0][selectedDate] : emptyData)!;
                chartSeriesController1?.updateDataSource(
                  updatedDataIndexes: List.generate(chartData[0].length, (i)=>i),
                );
              } else if (isSelectedDate[1]) {
                DateFormat outputFormat = DateFormat('y-M-d');
                DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
                chartData = (dataList[1].containsKey(selectedDate) ? dataList[1][selectedDate] : emptyData)!;
                chartSeriesController1?.updateDataSource(
                  updatedDataIndexes: List.generate(chartData[1].length, (i)=>i),
                );
              } else if (isSelectedDate[2]) {
                DateFormat outputFormat = DateFormat('y-M');
                DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
                chartData = (dataList[2].containsKey(selectedDate) ? dataList[2][selectedDate] : emptyData)!;
                chartSeriesController1?.updateDataSource(
                  updatedDataIndexes: List.generate(chartData[2].length, (i)=>i),
                );
              } else if (isSelectedDate[3]) {
                DateFormat outputFormat = DateFormat('y');
                DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));
                chartData = (dataList[3].containsKey(DateTime(1970)) ? dataList[3][DateTime(1970)] : emptyData)!;
                chartSeriesController1?.updateDataSource(
                  updatedDataIndexes: List.generate(chartData[3].length, (i)=>i),
                );
              }
            });
          },
          isSelected: isSelectedDate,
        ),
    );
  }
}


