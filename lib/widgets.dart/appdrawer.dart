import 'package:flutter/material.dart';

import '../utils/navigator.dart';

enum Pages { ALL_NOTES, FAVORITES }

class AppDrawer extends StatelessWidget {
  final Pages currPage;
  AppDrawer({Key key, this.currPage}) : super(key: key);

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
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            title: Text("All Notes"),
            selected: currPage == Pages.ALL_NOTES,
            onTap: () {
              if (currPage != Pages.ALL_NOTES) {
                AppNavigator.navigateToHome(context);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: Text("Favorites"),
            selected: currPage == Pages.FAVORITES,
            onTap: () async {
              if (currPage != Pages.FAVORITES) {
                await AppNavigator.navigateToFavorites(
                  context,
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
