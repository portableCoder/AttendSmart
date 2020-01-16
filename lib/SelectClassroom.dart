import 'dart:core';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'main.dart';
import 'dart:convert';
import 'package:simple_permissions/simple_permissions.dart';
import 'package:testzd/EnterName.dart';


void main() => runApp(ClassRoom());
class ClassRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home:SelectClass());
  }
}
class SelectClass extends StatefulWidget {
  @override
  _SelectClassState createState() => _SelectClassState();
}

class _SelectClassState extends State<SelectClass> {

  Future<void> saveWidget(WidgetList) async {
    final directory = await  getExternalStorageDirectory();

    final file = File('${directory.path}/widgetsClassRoomName.txt');
    final jsonString = jsonEncode(WidgetList);
    await file.writeAsString(jsonString.toString());
    print('saved');

  }

  final textInput =  TextEditingController();
  String storeInput;
  final saveFileInput = TextEditingController();
  String storeFileInput;
  String titleText ="enter name";

 List<Widget> widgetList =[];
 List<Map<String,String>> storeWidgets =[];
  requestPermission(BuildContext context) async {
    final res = await SimplePermissions.requestPermission(Permission.ReadExternalStorage);
    final res2 = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    final res3 = await SimplePermissions.requestPermission(Permission.RecordAudio);


    print("permission request result is " + res.toString());
  }

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
                  storeWidgets.add({"Number":"1","Name":"$storeInput"});
                  widgetList.add(
                      Container(
                        height: 100,
                        width: 100,
                        child: FittedBox(

                          child: FlatButton.icon(

                              icon:Icon(Icons.ac_unit) ,
                              label: Text("$storeInput"),
                              onPressed:(){

                                    MaterialPageRoute(builder: (context) => ClassRoomSelect(classRoomName: storeInput));



                              }

                        ),

                        ),
                      )


                  );



                    saveWidget(storeWidgets);
                    Navigator.pop(context);



                  }),],

          );

        }

    );

  }
  Future<void> loadWidget(BuildContext context) async {
    final directory = await  getExternalStorageDirectory();

    final file = File('${directory.path}/widgetsClassRoomName.txt');
    final decoded = jsonDecode(await file.readAsString()) as List;
    storeWidgets = decoded.cast<Map<String, dynamic>>()
        .map((map) => map.cast<String, String>()).toList();
    for(int i =0;i<storeWidgets.length;i++){
      setState((){
        widgetList.add(

            Container(
              height: 100,
              width: 100,
              child: FittedBox(

                child: FlatButton.icon(onPressed:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>ClassRoomSelect(classRoomName:storeWidgets[i]["Name"])),
                  );

                } , icon: Icon(Icons.ac_unit), label: Text(" "+storeWidgets[i]["Name"])),

              ),
            )
        );
      });


    }



  }

  void initState() {

    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => loadWidget(context));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => requestPermission(context));


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Colors.redAccent,
        backgroundColorEnd: Color(0xff0575e6),
         actions: <Widget>[
           IconButton(icon: Icon(Icons.add), onPressed: (){
             _showDialog();


           }
           ),

         ],
    ),
    body: Align(

      alignment: Alignment.topCenter,
      child: Wrap(
        spacing: 8.0, // gap between adjacent chips
        runSpacing: 4.0,
        direction: Axis.horizontal,
        children:widgetList,



      ),
    ),



    );
  }
}

