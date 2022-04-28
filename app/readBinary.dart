import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'GlobalVar.dart';
import 'dart:typed_data';
import 'dart:async';


// var formatter = DateFormat('y-M-d-H-m-s');
var formatterTime = DateFormat('H-m-s');
var formatterDate = DateFormat('y-M-d');
var formatterM = DateFormat('y-M');
var formatterDays = DateFormat('d');
var formatterMont = DateFormat('M');
var formatterYear = DateFormat('y');

late int numberOfVariables;

late List<String> variableName;
late List<int> variablesNameLength;
late List<int> variableBytes;
late int variableBytesSum;
late List<String> variableType;

late int headerSize;

late int startMeasurementTime;

late int measurementInterval;

void resetBinary() {
  dataList = [
    {},
    {},
    {},
    {},
  ];
}

Future<int> readBinary(List<int> data, bool isIni) async {
  // print(String.fromCharCodes(data.sublist(0, 4)));
  // if (String.fromCharCodes(data.sublist(0, 4)) == "dat ") return;
  // print(String.fromCharCodes(data.sublist(0, 4)));

  int currentPointer;
  if (!isIni) {
    headerSize =
        ByteData.sublistView(Uint8List.fromList(data.sublist(4, 8))).getUint32(
            0, Endian.little);

    startMeasurementTime =
        ByteData.sublistView(Uint8List.fromList(data.sublist(8, 12))).getUint32(
            0, Endian.little);

    measurementInterval =
        ByteData.sublistView(Uint8List.fromList(data.sublist(12, 16)))
            .getUint32(
            0, Endian.little);

    // var numberOfVariables = ByteData.sublistView(Uint8List.fromList(data!.substring(12, 13).codeUnits)).getUint32(0);
    // int numberOfVariables = data.subList(16, 17).codeUnits[0];
    numberOfVariables = data.sublist(16, 17)[0];

    currentPointer = 17;

    // List<String> variableName = []..length = numberOfVariables;
    variableName = List.generate(numberOfVariables, (i) => "");
    // List<int> variablesNameLength = []..length = numberOfVariables;
    variablesNameLength = List.generate(numberOfVariables, (i) => 0);
    // List<int> variableBytes = []..length = numberOfVariables;
    variableBytes = List.generate(numberOfVariables, (i) => 0);
    variableBytesSum = 0;
    // List<String> variableType = []..length = numberOfVariables;
    variableType = List.generate(numberOfVariables, (i) => "");

    for (var i = 0; i < numberOfVariables; i++) {
      variablesNameLength[i] =
      (data.sublist(currentPointer, currentPointer + 1)[0]);
      currentPointer++;
    }
    for (var i = 0; i < numberOfVariables; i++) {
      variableName[i] = (String.fromCharCodes(
          data.sublist(
              currentPointer, currentPointer + variablesNameLength[i])));
      currentPointer += variablesNameLength[i];
    }
    for (var i = 0; i < numberOfVariables; i++) {
      variableBytes[i] = (data.sublist(currentPointer, currentPointer + 1)[0]);
      currentPointer++;
      variableBytesSum += variableBytes[i];
    }
    for (var i = 0; i < numberOfVariables; i++) {
      variableType[i] =
      (String.fromCharCodes(data.sublist(currentPointer, currentPointer + 1)));
      currentPointer++;
    }
  } else {
    currentPointer = 0;
  }

  // if (currentPointer-8 != headerSize) return;

  // int dataSize = ByteData.sublistView(Uint8List.fromList(data.substring(currentPointer, currentPointer+4).codeUnits)).getUint32(0);
  DateTime epochTime = DateTime(1970, 1, 1, 0, 0, 0).add(Duration(seconds:startMeasurementTime));
  var s = ByteData.sublistView(Uint8List.fromList(data.sublist(currentPointer, data.length)));
  print(data.length-currentPointer);
  // for (int j = 0; currentPointer<data.length; currentPointer+=variableBytesSum) {
  for (int j = 0; j<data.length-currentPointer;) {
    //
    String strTime = formatterTime.format(epochTime);
    String strDate = formatterDate.format(epochTime);

    DateTime time = formatterTime.parse(strTime);
    DateTime date = formatterDate.parse(strDate);

    // if (!dataList[0].containsKey(date)) dataList[0][date] = []..length = numberOfVariables;
    if (!dataList[0].containsKey(date)) dataList[0][date] = List.generate(numberOfVariables, (i)=><Data>[]);
    // print(dataList);
    // print(numberOfVariables);

    for (int i = 0; i < numberOfVariables; i++) {
      // print(variableType[i]);
      if (variableType[i] == "f") {
        double temp = 0.0;
        if (variableBytes[i] == 4) {
          temp = s.getFloat32(j, Endian.little);
          // temp = s.getFloat32(j);
          j += 4;
        } else if (variableBytes[i] == 8) {
          temp = s.getFloat64(j, Endian.little);
          // temp = s.getFloat64(j);
          j += 8;
        }
        dataList[0][date]![i].add(Data(epochTime, temp));
        // print("f $epochTime $temp");
      } else if (variableType[i] == "i") {
        int temp = 0;
        if (variableBytes[i] == 1) {
          temp = s.getInt8(j);
          j += 1;
        } else if (variableBytes[i] == 2) {
          temp = s.getInt16(j, Endian.little);
          // temp = s.getInt16(j);
          j += 2;
        } else if (variableBytes[i] == 4) {
          temp = s.getInt32(j, Endian.little);
          // temp = s.getInt32(j);
          j += 4;
        } else if (variableBytes[i] == 8) {
          temp = s.getInt64(j, Endian.little);
          // temp = s.getInt64(j);
          j += 8;
        }
        dataList[0][date]![i].add(Data(epochTime, temp));
        // print("i$temp");
      } else if (variableType[i] == "u") {
        int temp = 0;
        if (variableBytes[i] == 1) {
          temp = s.getUint8(j);
          j += 1;
        } else if (variableBytes[i] == 2) {
          temp = s.getUint16(j, Endian.little);
          // temp = s.getUint16(j);
          j += 2;
        } else if (variableBytes[i] == 4) {
          temp = s.getUint32(j, Endian.little);
          // temp = s.getUint32(j);
          j += 4;
        } else if (variableBytes[i] == 8) {
          temp = s.getUint64(j, Endian.little);
          // temp = s.getUint64(j);
          j += 8;
        }
        dataList[0][date]![i].add(Data(epochTime, temp));
        // print("u$temp");
      }
    }
    // print(epochTime);
    epochTime = epochTime.add(Duration(milliseconds: measurementInterval));
  }
  // print(dataList[0]);

  dataList[0].forEach((DateTime key, List<List<Data>> value) {
    for (var elementI=0; elementI < value.length; elementI++) {
      var sum = 0.0;
      value[elementI].forEach((data) {
        sum += data.y;
      });
      sum /= value[elementI].length;

      var newKey= formatterM.parse(formatterM.format(key));
      var newTime = formatterDays.parse(formatterDays.format(key));
      if (!dataList[1].containsKey(newKey)) dataList[1][newKey] = List.generate(numberOfVariables, (i)=><Data>[]);
      dataList[1][newKey]![elementI].add(Data(newTime, sum));
    }
  });

  dataList[1].forEach((var key, var value) {
    for (var elementI=0; elementI < value.length; elementI++) {
      var sum = 0.0;
      value[elementI].forEach((data) {
        sum += data.y;
      });
      sum /= value[elementI].length;

      var newKey= formatterYear.parse(formatterYear.format(key));
      var newTime = formatterMont.parse(formatterMont.format(key));
      if (!dataList[2].containsKey(newKey)) dataList[2][newKey] = List.generate(numberOfVariables, (i)=><Data>[]);
      dataList[2][newKey]![elementI].add(Data(newTime, sum));
    }
  });

  dataList[2].forEach((var key, var value) {
    for (var elementI=0; elementI < value.length; elementI++) {
      var sum = 0.0;
      value[elementI].forEach((data) {
        sum += data.y;
      });
      sum /= value[elementI].length;

      var newTime = formatterYear.parse(formatterYear.format(key));
      if (!dataList[3].containsKey(DateTime(1970))) dataList[3][DateTime(1970)] = List.generate(numberOfVariables, (i)=><Data>[]);
      dataList[3][DateTime(1970)]![elementI].add(Data(newTime, sum));
    }
  });

  // chartData = []..length = 4; // = numberOfVariables

  // DateFormat outputFormat = DateFormat('H-m-s');
  // DateTime selectedDate = outputFormat.parse(outputFormat.format(nowDate));

  DateTime selectedDate = formatterDate.parse(formatterDate.format(DateTime(1970, 1, 1, 0, 0, 0).add(Duration(seconds:startMeasurementTime))));
  chartData = dataList[0][selectedDate] ?? List.generate(numberOfVariables, (i)=><Data>[]);
  print(dataList);

  return 1;
}
