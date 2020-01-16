import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'Statistics.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
void main() => runApp(MyApp())
;
class MyApp extends StatelessWidget {
  @override



  Widget build(BuildContext context) {
    return MaterialApp(home:AppNew()
    );
  }
}


class AppNew extends StatefulWidget {

  final String date;
  final String classRoomName;

  AppNew({Key key, @required this.date,@required this.classRoomName}) : super(key: key);
  @override
  _AppNewState createState() => _AppNewState();
}

class _AppNewState extends State<AppNew> {


//SpeechRecog Implementation
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";
  bool isCalled=false;
  bool isCalledFrom=false;
  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _read(context));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _readAttendence(context));
  }

  void initSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
          (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
          () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
          (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
          () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
    );

  }
  //SpeechRecog Implementation ends
  var now = DateTime.now();



//list map to be used in datatable
  List<Map<String, String>> listOfColumns = [



  ];
  List<Map<String,int>> totalAttendence = [


  ];





  int r=0,g=0,b=0;
  int ClickCount=0;
  String FileName="";
  //to be used for input
  List<String> listofstring = [
    "Hello world"



  ];


//TO save file a listofColumns as JSON strings
   Future<void> _save() async {

     final directory = await  getExternalStorageDirectory();

     final file = File('${directory.path}/Attendance ${widget.classRoomName} ${widget.date}.txt');
    final jsonString = jsonEncode(listOfColumns);
    await file.writeAsString(jsonString);
    print('saved');

  }
  //TO read from file JSON strings as listOfColumns

  Future<void> _read(BuildContext context) async {
    try {


      final directory = await  getExternalStorageDirectory();
      final file = File('${directory.path}/Attendance ${widget.classRoomName} ${widget.date}.txt');


      final decoded = jsonDecode(await file.readAsString()) as List;
      listOfColumns = decoded.cast<Map<String, dynamic>>()
          .map((map) => map.cast<String, String>()).toList();

    } catch (e) {
      print("Couldn't read file ${widget.classRoomName}");
      final directory = await  getExternalStorageDirectory();
      final file = File('${directory.path}/Attendance${widget.classRoomName}_Master.txt');


      final decoded = jsonDecode(await file.readAsString()) as List;

     setState((){
       listOfColumns = decoded.cast<Map<String, dynamic>>()
           .map((map) => map.cast<String, String>()).toList();
     });
      setState((){
        listOfColumns = decoded.cast<Map<String, dynamic>>()
            .map((map) => map.cast<String, String>()).toList();
      });

    }
  }
  int passCount = 0;

  bool isFileNull = false;
  Future<void> _saveAttendence() async {
    final directorySave = await  getExternalStorageDirectory();
    final fileSave = File('${directorySave.path}/Statistics ${widget.classRoomName}.txt');
    final jsonStringSave = jsonEncode(totalAttendence);
    await fileSave.writeAsString(jsonStringSave);
    print('saved');

  }
  Future<void> _readAttendence(BuildContext context) async {
     try {
       final directory = await getExternalStorageDirectory();
       final file = File(
           '${directory.path}/Statistics ${widget.classRoomName}.txt');


       final decoded = jsonDecode(await file.readAsString()) as List;
       totalAttendence = decoded.cast<Map<String, dynamic>>()
           .map((map) => map.cast<String, int>()).toList();
       print("reading stats sucessful");

     }
     catch(e){
       isFileNull=true;
        print(' reading stats failed');
     }
  }
  void _addAttendance(String state,String name){
    if(isFileNull == true) {


    if (state.toLowerCase() == 'a') {
      totalAttendence.add({name:0 });
    }
    else if(state.toLowerCase() == 'p'){
      totalAttendence.add({name: 1});
      }

    }


  }
  void addAttendanceExisting(){
    for(int j=0;j<listOfColumns.length;j++){
      if(listOfColumns[j]['State'] == 'P'){
        totalAttendence[j][listOfColumns[j]['Name']] += 1;
      }
      else if(listOfColumns[j]['State'] == 'A'){
        totalAttendence[j][listOfColumns[j]['Name']] += 0;

      }
    }

  }
  //Input Dialog Box
  final textInput =  TextEditingController();
  String storeInput;
  final saveFileInput = TextEditingController();
  String storeFileInput;
  String titleText ="enter name";


//INPUT BOX
  void _showDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
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
          ),new FloatingActionButton(elevation: 0,
              child:Text('OK'),

              onPressed:(){


              storeInput = textInput.text;
              listofstring[0] = storeInput;
              int roll = listOfColumns.length + 1;
              setState(() {
                listOfColumns.add({
                  "Name": "" + listofstring[0],
                  "Number": "" + roll.toString(),
                  "State": ""
                });
              });


              Navigator.pop(context);


              }),],

        );

      }

    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          actions: <Widget>[

            Align(
              alignment: Alignment.topRight,
              child: new FlatButton(
                  onPressed:(){
                    print(totalAttendence);
                    isCalledFrom=true;
                    _saveAttendence();

                    _showDialog();
                    _save();

                    if(isFileNull == true) {
                      listOfColumns.forEach((element) =>
                          _addAttendance(element['State'], element['Name']));
                    }

                    else if(isFileNull == false){
                      addAttendanceExisting();

                    }

                    _saveAttendence();

                    print(FileName);


                  }, child: Icon(Icons.save),

              ),
            ),
          Text("")],

          backgroundColor: Color.fromRGBO(r,g,b, 95),
          title: Center(
            child: Text(


            "Attend Smart "+ "Date: ${widget.date}",
                style:TextStyle(
                fontSize: 15,


            ),

            ),
          ),

        ),
      drawer: Drawer(

        child: Container(
          decoration:BoxDecoration(
            gradient: LinearGradient(colors:[
              Color(0xff2980B9),Color(0xff6DD5FA),
            ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,

              stops: [0.1,0.5],



            )
          ),

          child: ListView(
            padding: EdgeInsets.zero,
            children:<Widget>[
              DrawerHeader(child:Text("hello"),
                 padding: EdgeInsets.zero,

              ),
              ListTile(
                title: Text("Statistics"),
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Statistics(classRoomName: widget.classRoomName,)),
                  );
                },

              ),
              ListTile(
                title: Text("name2"),

              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
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
              DataColumn(label: Text('Attendence')),
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
                  DataCell(Text(element["State"])),
                ],
              )),
            )
                .toList(),
          ),
        ),

      ),


      floatingActionButton: Center(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(onPressed: (){

                  _isAvailable = true;

                if (_isAvailable && !_isListening) {
                  _speechRecognition
                      .listen(locale: "en_IN")
                      .then((result) => print('$result'));
                }

                  setState((){
                    if(resultText.toLowerCase() == 'absent') {

                      listOfColumns[ClickCount]['State'] = "A";

                      ClickCount++;
                    }
                    else if(resultText.toLowerCase() == 'present'){


                      listOfColumns[ClickCount]['State'] = "P";

                      ClickCount++;

                    }
                  });

              },
                backgroundColor: Colors.purple,
                child:Icon(Icons.mic),
                heroTag: "btn1",

              ),
              FloatingActionButton(onPressed: () {
                if (_isListening) {
                  _speechRecognition.stop().then((result) =>
                      setState(() => _isListening = result));
                }


                // _showDialog();

                print (totalAttendence);




              },
                  backgroundColor: Colors.purple,
                  child:Icon(Icons.stop),




              ), FloatingActionButton(onPressed: (){

                print(listofstring);




              },
                  backgroundColor: Colors.purple,
                  child:Icon(Icons.play_arrow),
                heroTag: "btn2",

              ),FloatingActionButton(onPressed: (){
                setState((){
                  _read(context);




                });
                setState((){
                  _read(context);




                });


              },
                heroTag: "btn3",
                child:Icon(Icons.add),

              )],
          ),
        ),
      ),


    );

  }
  @override
  void dispose(){
      textInput.dispose();
      super.dispose();

  }


}

