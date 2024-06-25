import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:to_no/db/database.dart';

import '../db/functions.dart';


class InsertTodo extends StatefulWidget {
  const InsertTodo({super.key});

  @override
  State<InsertTodo> createState() => _InsertTodoState();
}

class _InsertTodoState extends State<InsertTodo> {
  TextEditingController _taskController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _checkInsertUpdate = "Insert";


  @override
  Widget build(BuildContext context) {
    Todo? data = ModalRoute.of(context)!.settings.arguments as Todo?;
    if(data != null){
      _taskController.text = data.task;
      _descriptionController.text = data.description;
      _checkInsertUpdate = "Update";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Todo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 50),
              TextField(
                controller: _taskController,
                decoration:   InputDecoration(hintText: 'Title',
                  fillColor: Colors.teal[50],
                    filled: true,
                    focusColor: const Color.fromARGB(255, 219, 225, 225), // Light blue cursor color
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff00ffff)), // Light blue border
                    ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration:   InputDecoration(hintText: 'Title',
                  fillColor: Colors.teal[50],
                    filled: true,
                    focusColor: const Color.fromARGB(255, 219, 225, 225), // Light blue cursor color
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff00ffff)), // Light blue border
                    ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if(_checkInsertUpdate == "Insert")
                    addTodo(_taskController.text,_descriptionController.text);
                  else{
                    _updateData(data!.id,_taskController.text,_descriptionController.text,data.status);
                  }
                  
                },
                child:  Text(_checkInsertUpdate),
              ),
            ],
          ),
        ),
      ),

    );
  }
  Future<void> addTodo(task,description) async {

    if(description.isEmpty){
      description = " ";
      var _id=M.ObjectId();
      var status = false;
      var data= Todo(id: _id, task: task, status: status, description: description);
      await MongoDB.insert_todo(data);
      ScaffoldMessenger.of(context).
      showSnackBar(SnackBar(content: Text("Insert Id${_id.oid}")));
      _clearTask();
    }
    else{
      var _id=M.ObjectId();
      var status = false;
    ;
      var data= Todo(id: _id, task: task, status: status, description: description);
      await MongoDB.insert_todo(data);
      ScaffoldMessenger.of(context).
      showSnackBar(SnackBar(content: Text("Insert Id${_id.oid}")));
      _clearTask();
      
    }
    
  }
  Future <void> _updateData(var id,task,description,status) async{
    status = false; // this is for if we update the data then status will be false
    var data= Todo(id: id, task: task, status: status, description: description);
    MongoDB.update_todo(data).whenComplete(() => Navigator.pop(context));
  }
  void _clearTask(){
    setState(() {
      _taskController.clear();
      _descriptionController.clear();
    });
  }
}