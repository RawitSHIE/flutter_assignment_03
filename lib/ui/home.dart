import 'package:flutter/material.dart';
import './listadd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Todolist extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TodolistState();
  }
}

class TodolistState extends State {
  int _index = 0;
  CollectionReference todos = Firestore.instance.collection("todos");
  // todos.where('done', isEqualTo: true).snapshots();
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
          QuerySnapshot ondone = await todos.where('done', isEqualTo: true).getDocuments();
          ondone.documents.forEach((item) {
            print(item.data["title"]);
            print(item.documentID);
            DocumentReference doc = Firestore.instance.document('todos/${item.documentID}');
            Firestore.instance.runTransaction((Transaction t) async {
              DocumentSnapshot dc = await t.get(doc);
              if (dc.exists){
                await t.delete(doc);
              }
            });
          });
          setState(() {});
        },
      )
    ];

    ListTile customCheckBox({DocumentSnapshot item}) {
      return ListTile(
        title: Text(
          item.data["title"],
          style: TextStyle(fontSize: 20, color: Colors.blueGrey),
        ),
        trailing: Checkbox(
          activeColor: Colors.blue,
          onChanged: (bool value) {
            todos.document(item.documentID).setData({
              // '_id': item.data['_id'],
              'title': item.data['title'],
              'done': !item.data['done']
            });
            setState(() {});
          },
          value: item.data["done"],
        ),
      );
    }

    Widget todoview(List<DocumentSnapshot> data) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: customCheckBox(item: data.elementAt(index)),
            ),
          ]));
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
        actions: <Widget>[topbar[_index]],
      ),
      body: StreamBuilder(
        stream: todos.where('done', isEqualTo: _index == 1).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return Center(child: Text("No data found.."));
            }
            return todoview(snapshot.data.documents);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
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
