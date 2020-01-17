import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SaveWidgets {




  Future<void> saveWidget(WidgetList) async {
    final directory = await  getExternalStorageDirectory();

    final file = File('${directory.path}/widgets.txt');
    final jsonString = jsonEncode(WidgetList);
    await file.writeAsString(jsonString.toString());
    print('saved');

  }
  Future<bool> saveMaster(listOfColumns,String ClassRoomName) async {
    try {
      final directory = await getExternalStorageDirectory();

      final file = File(
          "${directory.path}/Attendance${ClassRoomName}_Master.txt");
      final jsonString = jsonEncode(listOfColumns);
      await file.writeAsString(jsonString);
      print('read fof');
    }
    catch(e){
      print('File fof');

      return true;

    }
  }
  Future<bool> readFile(listOfColumns,String ClassRoomName) async {
    try {
      final directory = await getExternalStorageDirectory();

      final file = File("${directory.path}/Attendance${ClassRoomName}_Master.txt");
      final decoded = jsonDecode(await file.readAsString());
      print('file found fof');

      return true;

    }
    catch(e){
      print('File not found fof');

      return false;

    }
  }

   //TO read from file JSON strings as listOfColumns


  //Reads date and total Attendance





}


