import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  _BarState createState() => _BarState();
}

class _BarState extends State<HomePage> {
  var bloablid = 10;
  final List<todo> listItems = new List<todo>.generate(10, (i) {
    return todo(
      name: '測試資料 $i',
      id: i,
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          itemCount: listItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.check_box,
                  color: Colors.white,
                ),
                onPressed: () => setState(() => listItems.removeLast()),
              ),
              title: Text(
                '${listItems[index].name}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            bloablid = bloablid + 1,
            setState(() => listItems.add(todo(name: "aa", id: bloablid)))
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat);
  }
}

class todo {
  final String name;
  final int id;
  todo({required this.name, required this.id});
}
