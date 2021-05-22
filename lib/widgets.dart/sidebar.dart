import 'package:flutter/material.dart';
import 'package:notepad/views/homepage.dart';

class SideBar extends StatefulWidget {
  bool _allnotes;
  bool _favorites;

  SideBar()
      : _allnotes = true,
        _favorites = false;

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Notepad",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          ListTile(
            title: Text("All Notes"),
            selected: widget._allnotes,
            onTap: () {
              widget._favorites = false;
              widget._allnotes = true;
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(title: "Notepad"),
                ),
              );
            },
          ),
          ListTile(
            title: Text("Favorites"),
            selected: widget._favorites,
            onTap: () {
              widget._favorites = true;
              widget._allnotes = false;
              Navigator.pop(context);
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(title: "Notepad"),
                ),
              );*/
            },
          ),
        ],
      ),
    );
  }
}
