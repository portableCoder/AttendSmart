import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:testzd/dataGraph.dart';

void main() => runApp(RunApp());

class RunApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:Statistics());
  }
}

class Statistics extends StatefulWidget {
  final String classRoomName;
  @override
  _StatisticsState createState() => _StatisticsState();
  Statistics({Key key,@required this.classRoomName}) : super(key: key);
}

class _StatisticsState extends State<Statistics> {
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _readAttendence(context));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _readAttendenceGraphData(context));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => PopulateGraph(context));
  }
  final List<dataGraph> data = [


  ];

  List<Map<String,String>> AttendanceGraphData = [];

  Future<void> _readAttendenceGraphData(BuildContext context) async {
    try {
      final directory = await getExternalStorageDirectory();
      final file = File('${directory.path}/Graph.txt');


      final decoded = jsonDecode(await file.readAsString()) as List;
      setState(() {
        AttendanceGraphData = decoded.cast<Map<String, dynamic>>()
            .map((map) => map.cast<String, String>()).toList();
      });

      print("reading graph stats sucessful");

    }
    catch(e){
      print(' reading graph stats failed');

    }
  }

  void PopulateGraph(BuildContext context){
    setState((){
      print("Test");
      
      AttendanceGraphData.forEach((element) => AddDataGraph(element.keys.toString().replaceAll("(","").replaceAll(")", ""),element.values.toString().replaceAll("(", "").replaceAll(")", "")));

    });

  }

  void AddDataGraph(String date,String attendance){
   int number = int.parse(attendance);
   setState(() {
     data.add(dataGraph(date: date,totalAttendance: number));

   });


  }


  List<Map<String,int>> totalAttendence = [



  ];
  bool notTapped=true;
  Future<void> _readAttendence(BuildContext context) async {
    try {
      final directory = await getExternalStorageDirectory();
      final file = File(
          '${directory.path}/Statistics ${widget.classRoomName}.txt');


      final decoded = jsonDecode(await file.readAsString()) as List;
     setState(() {
       totalAttendence = decoded.cast<Map<String, dynamic>>()
           .map((map) => map.cast<String, int>()).toList();
     });

      print("reading stats sucessful");

    }
    catch(e){
      print(' reading stats failed');
    }
  }




  @override

  Widget build(BuildContext context) {
    return Scaffold(


        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Center(child: Text("Attendance Statistics")),
          actions: <Widget>[
            FloatingActionButton(
                child: Icon(Icons.file_download),
                onPressed:(){

                  print(data);
                  print(AttendanceGraphData.toList());
                  PopulateGraph(context);






                }

            ),
          ],
        ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Attendence in days')),
                  ],
                  rows:
                  totalAttendence // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                    ((element) => DataRow(
                      onSelectChanged: (bool selected) {
                        if (selected) {

                        }
                      },
                      cells: <DataCell>[
                        DataCell(Text(element.keys.toString().replaceAll("(", "").replaceAll(")", ""))),
                        DataCell(Text(element.values.toString().replaceAll("(", "").replaceAll(")", ""))), //Extracting from Map element the value
                                              //Extracting from Map element the value
                      ],
                    )),
                  )
                      .toList(),
                ),
              ),

            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0.0, 30,0, 10.0),
                child: Text("Datewise Attendance Graph")),

            SizedBox(
                width: 300,
                height: 300,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.00)
                  ),
                  borderOnForeground: true,
                    child: AttendanceChart(data: data)))],
        ),
      ),


    );
  }
}
