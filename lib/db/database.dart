import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

Todo todoFromJson(String str) => Todo.fromJson(json.decode(str));

String todoToJson(Todo data) => json.encode(data.toJson());

Notes notesFromJson(String str) => Notes.fromJson(json.decode(str));

String notesToJson(Notes data) => json.encode(data.toJson());


class Todo {
    ObjectId id;
    String task;
    String description;
    bool status;

    Todo({
        required this.id,
        required this.task,
        required this.status,
        required this.description,
    });

    factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["_id"],
        task: json["task"],
        status: json["status"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "task": task,
        "status": status,
        "description": description,
    };
}



class Notes {
    ObjectId id;
    String title;
    String description;

    Notes({
        required this.id,
        required this.title,
        required this.description,
    });

    factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
    };
}
