import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class dataGraph{
  final String date;
  final int totalAttendance;
  dataGraph({this.date,this.totalAttendance});


}
class AttendanceChart extends StatelessWidget{
  AttendanceChart({this.data});

  List<dataGraph> data;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<dataGraph,String>> series = [
      charts.Series(
          id:"Attendance",
          data:data,
          domainFn: (dataGraph series, _) => series.date,
          measureFn: (dataGraph series, _) => series.totalAttendance,

      ),
    ];
    return charts.BarChart(series, animate: true);



  }


}