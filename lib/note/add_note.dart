import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import '../db/database.dart';
import '../db/functions.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _checkInsertUpdate = "Insert";
  @override
  Widget build(BuildContext context) {
    Notes? data =ModalRoute.of(context)!.settings.arguments as Notes?;
    if(data != null){
      _titleController.text = data.title;
      _descriptionController.text = data.description;
      _checkInsertUpdate = "Update";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Notes'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 50),
              TextField(
                controller: _titleController,
                decoration:  InputDecoration(
                  hintText: 'Title',
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
                maxLines: null,
                decoration:  InputDecoration(
                  hintText: 'Description',
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
                  // Add note
                  if(_checkInsertUpdate == "Insert"){
                    addNotes(_titleController.text, _descriptionController.text);
                  }
                  // Update note
                  else{
                    _updateNotes(data!.id, _titleController.text, _descriptionController.text);
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
  Future <void> addNotes(title,description) async{
    var _id=M.ObjectId();
    var data=Notes(id: _id, title: title, description: description);
     await MongoDB.insert_note(data);
    ScaffoldMessenger.of(context).
      showSnackBar(SnackBar(content: Text("Insert Id${_id.oid}")));
      _clearTextFields();
    
  }

  void _clearTextFields() {
   setState(() {
      _titleController.clear();
      _descriptionController.clear();
   });
  }

  Future <void> _updateNotes(var id,title,description) async{
    var data=Notes(id: id, title: title, description: description);
    await MongoDB.update_note(data).whenComplete(() => Navigator.pop(context));
  }
}