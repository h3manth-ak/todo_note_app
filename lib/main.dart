import 'package:flutter/material.dart';
import 'package:to_no/db/functions.dart';
import 'package:to_no/note/list_note.dart';
import 'package:to_no/todo/add_todo.dart';
import 'package:to_no/todo/list_todo.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  debugPrint("connected");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xff1e1e1e)),
      home: const RootPage(),
      routes: {
        '/add_todo': (context) => const InsertTodo(),
      },
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [TodoDisplay(),DisplayNotes()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Theme(
          data: ThemeData(
            // brightness: Brightness.dark,
            // primarySwatch: Colors.blue,
            // platform: Theme.of(context).platform,
            
          ),
          child: pages[currentPage]
          ),
      
        bottomNavigationBar: NavigationBar(
          
          backgroundColor: Colors.white10,
          indicatorColor: Colors.white.withOpacity(0),  
          destinations:  const [
            NavigationDestination(icon:Icon(Icons.task_alt_outlined,color: Colors.white54,), label: 'ToDo',selectedIcon:Icon(Icons.add_task_outlined,color: Colors.cyanAccent,) ,
              
            ),
            NavigationDestination(icon: Icon(Icons.note_alt_outlined,color: Colors.white54,), label: 'Notes',selectedIcon:Icon(Icons.note_add,color: Colors.cyanAccent,),)
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currentPage = index;
            });
          },
          

          selectedIndex: currentPage,
        ),
        
    );
  }
}