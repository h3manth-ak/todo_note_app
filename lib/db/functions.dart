
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:to_no/variables.dart';

import 'database.dart';

class MongoDB{
  static var db,todoCollection,noteCollection;
  static connect() async{
    db = await Db.create(MONGO_URL);
    await db.open(secure:true);
    debugPrint("connected.....");
    inspect(db);
    var status = db.serverStatus();
    debugPrint(status.toString());
    todoCollection = db.collection(TodoCollection);
    noteCollection = db.collection(NoteCollection);
    debugPrint("hii");
    debugPrint("${todoCollection.toString()},${noteCollection.toString()}");
    debugPrint("hiiiiii");
  }

  static get_todo() async{
    try {
      debugPrint("get_todo");
      var data = await todoCollection.find().toList();
      debugPrint("todo data");
      debugPrint(data.toString());
      return data;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
      
    }
  }
   static get_note() async{
    try {
      var data = await noteCollection.find().toList();
      return data;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
   }

   static insert_todo(Todo data) async{
    try {
      var res = await todoCollection.insert(data.toJson());
      if(res.isSucess){
        return "Data Inserted";
      }
      else{
        return "Data Not Inserted";
      }
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }

    
   }

   static insert_note(Notes data) async{
    try {
      var result =await noteCollection.insert(data.toJson());
      if(result.isSucess){
        return "Data Inserted";
      }
      else{
        return "Data Not Inserted";
      }
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
      
    }
   }

   static Future<void> update_todo(Todo data) async{
      try{
      var result=await todoCollection.findOne({"_id":data.id});
      if(result!=null){
        result["task"]=data.task;
        result["description"]=data.description;

      var response= await todoCollection.update(where.id(result['_id']), result);
      inspect(response);
      debugPrint('Update response: $response');
      }
      else {
        debugPrint('User not found');
      }
   }catch(e){
     debugPrint('Error updating data $e');
   }
   
   }

  static Future<void> update_note(Notes data) async{
    try {
      var result = await noteCollection.findOne({"_id":data.id});
      if(result!=null){
        result["title"]=data.title;
        result["description"]=data.description;
        var response = await noteCollection.update(where.id(result['_id']), result);
        inspect(response);
        debugPrint('Update response: $response');
      }
      else{
        debugPrint('User not found');
      }
    } catch (e) {
      debugPrint('Error updating data $e');
    }
  }

  static delete_todo (Todo data) async{
     await todoCollection.remove(where.id(data.id));
  }
  static delete_note (Notes data) async{
     await noteCollection.remove(where.id(data.id));
  }


  static update_todo_status(Todo data) async{
    try {
      var result = await todoCollection.findOne({"_id":data.id});
      if(result!=null){
        result["status"]=data.status;
        var response = await todoCollection.update(where.id(result['_id']), result);
        inspect(response);
        debugPrint('Update response: $response');
      }
      else{
        debugPrint('User not found');
      }
    } catch (e) {
      debugPrint('Error updating data $e');
    }
  }

}