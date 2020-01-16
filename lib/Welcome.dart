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
void main() => runApp(MyApp());


var save = SaveWidgets();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Welcome()

    );
  }
}

class Welcome extends StatefulWidget {
  final String classRoomName;

  Welcome({Key key,@required this.classRoomName}) : super(key: key);
  @override
  _WelcomeState createState() => _WelcomeState();
}
class _WelcomeState extends State<Welcome> {


  var prop = "1";


  List<Map<String,String>> WidgetsList = [];




  List<Widget> AppOpen = [

  ];
  List<Map<String,String>> listOfColumns = [];
  var now = DateTime.now();
  bool NewFile = false;
  String FileName="";

  Future<void> loadWidget(BuildContext context) async {
    final directory = await  getExternalStorageDirectory();

    final file = File('${directory.path}/widgets.txt');
    final decoded = jsonDecode(await file.readAsString()) as List;
    WidgetsList = decoded.cast<Map<String, dynamic>>()
        .map((map) => map.cast<String, String>()).toList();
    for(int i =0;i<WidgetsList.length;i++){
      setState((){
        AppOpen.add(

            Container(
              height: 100,
              width: 100,
              child: FittedBox(

                child: FlatButton.icon(onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AppNew(classRoomName:widget.classRoomName,date:WidgetsList[i]["Date"])),
                  );

                } , icon: Icon(Icons.ac_unit), label: Text("Attendance"+WidgetsList[i]["Date"])),

              ),
            )
        );
      });


    }



  }

  Future<void> _read(BuildContext context) async {
    try {
      final  dateTmi = (new DateFormat("dd-MM-yy").format(now)).toString();
      final directory = await  getExternalStorageDirectory();
      final file = File('${directory.path}/Attendence $dateTmi.txt');


      final decoded = jsonDecode(await file.readAsString()) as List;
      listOfColumns = decoded.cast<Map<String, dynamic>>()
          .map((map) => map.cast<String, String>()).toList();

    } catch (e) {
      print("Couldn't read file");
      NewFile = true;
      /* if(NewFile == true) {
        setState(() {
          AppOpen.add(

              Container(
                height: 100,
                width: 100,
                child: FittedBox(

                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>AppNew()),
                      );
                    },
                    child: Icon(Icons.add_to_home_screen),
                  ),
                ),
              )
          );
        });
      }
      */

    }
  }

  void initState() {

    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _read(context));

    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadWidget(context));


  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(

        appBar: GradientAppBar(
          actions: <Widget>[
            FloatingActionButton(onPressed: (){
              final  dateTmi = (new DateFormat("dd-MM-yy").format(now)).toString();

              WidgetsList.add({"List":"1","Date":"$dateTmi"});

              setState(() {
                  AppOpen.add(

                      Container(
                        height: 100,
                        width: 100,
                        child: FittedBox(

                          child: FlatButton.icon(onPressed:(){
                            Navigator.push(
                              context,
                              // ignore: missing_identifier
                              MaterialPageRoute(builder: (context) =>AppNew(classRoomName: widget.classRoomName,date: dateTmi,)),
                              // pass data to main.dart
                            );

                          } , icon: Icon(Icons.ac_unit), label: Text("Attendence "+dateTmi)),

                        ),
                      )
                  );
                });




             save.saveWidget(WidgetsList);
              print(WidgetsList.length);
            },
              child: Icon(Icons.save),
            )
          ],

          backgroundColorStart: Colors.redAccent,
          backgroundColorEnd: Color(0xff0575e6),
          title: SafeArea(
            child: Center(
              child: Text("Welcome",
                style: TextStyle(

                )),
            ),
          ),


        ),
      body: Align(

        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0,
            direction: Axis.horizontal,
              children:AppOpen,



          ),
      ),


    );
  }
}
