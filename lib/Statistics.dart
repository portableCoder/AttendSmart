import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';


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
  }

  var varlist = [
    0.0, 1.0, 1.5, 2.0, 0.0, 0.0, -0.5, -1.0, -0.5, 0.0, 0.0

  ];
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
          title: Text("test"),
          actions: <Widget>[
            FloatingActionButton(
                child: Icon(Icons.file_download),
                onPressed:(){

                  print(totalAttendence[0].keys.toString());







                }

            ),
          ],
        ),
      body: Align(
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


    );
  }
}
