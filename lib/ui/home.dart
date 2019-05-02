import 'package:flutter/material.dart';
import './listadd.dart';

class Todolist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodolistState();
  }
}

class TodolistState extends State {
  int _index = 0;
  @override
  Widget build(BuildContext context) {

    final List topbar = <Widget>[
      IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Addlist()));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          setState(() {});
        },
      )
    ];
    List body = [Center(child: Text("Task")), Center(child: Text("Complete"))];
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: <Widget>[topbar[_index]],
      ),
      body: body[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), title: Text("Complete")),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), title: Text("done"))
        ],
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
