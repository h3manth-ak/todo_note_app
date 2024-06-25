import 'package:flutter/material.dart';
import 'package:to_no/db/database.dart';
import 'package:to_no/db/functions.dart';
import 'package:to_no/todo/add_todo.dart';

class TodoDisplay extends StatefulWidget {
  const TodoDisplay({super.key});

  @override
  State<TodoDisplay> createState() => _TodoDisplayState();
}

class _TodoDisplayState extends State<TodoDisplay> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: MongoDB.get_todo(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                      color: Colors.brown, backgroundColor: Colors.cyan),
                );
              } else {
                if (snapshot.hasData) {
                  var totalData = snapshot.data.length;
                  debugPrint(totalData.toString());
                  return ListView.builder(
                      itemBuilder: (context, index) {
                        return displayCard(
                            Todo.fromJson(snapshot.data[index]));
                      },
                      itemCount: totalData,
                      );
                } else {
                  return const Text("No Data Found");
                }
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(
                builder:(BuildContext context){
                  return const InsertTodo();
                },
                settings:const RouteSettings(arguments: null),
              ),
            ).then((value) {
              setState(() {});
            });
          },
          child: const Icon(Icons.add)),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget displayCard(Todo todo) {
    return Card(
        color: const Color.fromARGB(255, 12, 3, 3),

        //                           <-- Card
        child: CheckboxListTile(
          activeColor: Colors.greenAccent,
          checkColor: Colors.white,
          tileColor: const Color(0xff1e1e1e),
          value: todo.status,
          onChanged: (value) async {
            todo.status = !todo.status;
            await MongoDB.update_todo_status(todo);
            setState(()  {
              _isVisible = !_isVisible;
              setState(() {
                
              });
            });
          },
          title: Text(
            todo.task,
            style: const TextStyle(color: Color(0xfff1f1f1)),
          ),
          subtitle: Text(
            todo.description,
            style: const TextStyle(color: Color(0xffF1D9D9)),
          ),
          secondary: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: todo.status ,
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () async{
                            debugPrint("${todo.id}");
                            await MongoDB.delete_todo(todo);
                            setState((){});
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.redAccent,
                          ))
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      // debugPrint("${todo.id}");
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder:(BuildContext context){
                            return const InsertTodo();
                          },
                          settings: RouteSettings(
                            arguments: todo,
                        ),
                      ),
                      ).then((value) {
                        setState(() {});
                      
                      });
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blueGrey,
                    )),
              ],
            ),
          ),
          // selected: _value,
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ));
  }
}
