import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'main.dart';
import 'package:simple_permissions/simple_permissions.dart';
import 'saveFileWidgets.dart';
import 'dart:math';
import 'Welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:ClassRoomSelect(),

    );
  }
}
class ClassRoomSelect extends StatefulWidget {
  final String classRoomName;

  ClassRoomSelect({Key key,@required this.classRoomName}) : super(key: key);
  @override
  _ClassRoomSelectState createState() => _ClassRoomSelectState();
}

class _ClassRoomSelectState extends State<ClassRoomSelect> {
  var save = SaveWidgets();


  List<Map<String, String>> listOfColumns = [



  ];
  final textInput =  TextEditingController();
  String storeInput;
  final saveFileInput = TextEditingController();
  String storeFileInput;
  String titleText ="enter name";
  List<String> listofstring = [
    "Hello world"



  ];
 Future <void> checkTrue(BuildContext context) async{
    var check = await save.readFile(listOfColumns,widget.classRoomName);
    print("the value is $check");



    if(check == true){
      String classRoomName = widget.classRoomName;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>Welcome(classRoomName: classRoomName)),
        // pass data to main.dart
      );


  }
    else if(check == false){


    }
  }
  void initState() {

    super.initState();
    
      WidgetsBinding.instance
          .addPostFrameCallback((_) => checkTrue(context));
      
    
    

  }
  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titleText),
            actions: <Widget>[
              Container(
                width: 200,
                height: 100,
                child: TextField(
                  controller: textInput,
                  decoration: InputDecoration(


                  ),
                ),
              ), new FloatingActionButton(elevation: 0,
                  child: Text('OK'),

                  onPressed: () {
                    storeInput = textInput.text;
                    listofstring[0] = storeInput;
                    int roll = listOfColumns.length + 1;
                    setState(() {
                      listOfColumns.add({
                        "Name": "" + listofstring[0],
                        "Number": "" + roll.toString(),
                        "State":""
                      });
                    });

                    save.saveMaster(listOfColumns,widget.classRoomName);

                    Navigator.pop(context);
                  }),
            ],

          );
        }

    );
  }


  @override
  Widget build(BuildContext context) {


    // ignore: return_of_invalid_type
    return Scaffold(

      appBar: GradientAppBar(
        actions: <Widget>[
            IconButton(icon: Icon(Icons.add), onPressed: (){
              _showDialog();


          })
        ],
        backgroundColorStart: Colors.redAccent,
        backgroundColorEnd: Color(0xff0575e6),
        title: SafeArea(
          child: Center(
            child: Text("Welcome: Enter student names",
                style: TextStyle(

                )),
          ),
        ),
      ),

      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Roll')),
            ],
            rows:
            listOfColumns // Loops through dataColumnText, each iteration assigning the value to element
                .map(
              ((element) => DataRow(
                onSelectChanged: (bool selected) {
                  if (selected) {

                  }
                },
                cells: <DataCell>[
                  DataCell(Text(element["Name"])), //Extracting from Map element the value
                  DataCell(Text(element["Number"])),
                ],
              )),
            )
                .toList(),
          ),
        ),

      ),
    floatingActionButton: Align(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(onPressed: (){
        String classRoomName = widget.classRoomName;

        print(classRoomName);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>Welcome(classRoomName: classRoomName)),
          // pass data to main.dart
        );

      },
        child: Text("OK") ),
    ),
    );
  }
}


