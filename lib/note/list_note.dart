import 'package:flutter/material.dart';
import 'package:to_no/db/database.dart';
import 'package:to_no/db/functions.dart';
import 'add_note.dart';

class DisplayNotes extends StatefulWidget {
  const DisplayNotes({super.key});

  @override
  State<DisplayNotes> createState() => _DisplayNotesState();
}

class _DisplayNotesState extends State<DisplayNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: MongoDB.get_note(),
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
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7, // Aspect ratio for the grid items
                    ),
                    itemBuilder: (context, index) {
                      return displayCard(Notes.fromJson(snapshot.data[index]));
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) {
                return const AddNotes();
              },
              settings: const RouteSettings(arguments: null),
            ),
          ).then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget displayCard(Notes note) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return FullScreenNote(
                note: note,
                onUpdate: () {
                  setState(() {});
                },
              );
            },
          ),
        );
      },
      child: Card(
  color: const Color(0xff1e1e1e),
  elevation: 10.0,
  shape: RoundedRectangleBorder(
    side: const BorderSide(
      color: Colors.white,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  note.title,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 15,
                  ),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return AddNotes();
                        },
                        settings: RouteSettings(arguments: note),
                      ),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 15,
                  ),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    await MongoDB.delete_note(note);
                    setState(() {});
                    debugPrint('delete note id: ${note.id}');
                  },
                ),
              ],
            ),
          ],
        ),
        Padding(padding:  const EdgeInsets.all(5.0)),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              note.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
)

    );
  }
}

class FullScreenNote extends StatelessWidget {
  final Notes note;
  final VoidCallback onUpdate;

  const FullScreenNote({
    Key? key,
    required this.note,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController =
        TextEditingController(text: note.title);
    TextEditingController descriptionController =
        TextEditingController(text: note.description);

    return Scaffold(
      appBar: AppBar(
        title:  Text(note.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                note.title = titleController.text;
                note.description = descriptionController.text;
                await MongoDB.update_note(note);
                onUpdate();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
