import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiExample extends StatefulWidget {
  const ApiExample({super.key});

  @override
  State<ApiExample> createState() => _ApiExampleState();
}

class _ApiExampleState extends State<ApiExample> {
  List studentList = [];

  void addStudent() async {
    var uri = Uri.parse("https://jsonplaceholder.typicode.com/users");
    http.Response res = await http.get(uri);
    print("the response is --- ${res.body}");
    var data = jsonDecode(res.body);
    for (var student in data) {
      studentList.add(student["name"]);
    }
    setState(() {}); // to refresh UI after data is added
  }

  @override
  void initState() {
    super.initState();
    addStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: studentList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(studentList[index].toString()),
          );
        },
      ),
    );
  }
}
