import 'package:flutter/material.dart';
import 'QRCodePage.dart';
import 'AnalysisPage.dart';
import 'SettingsPage.dart';
import 'InfoPage.dart';

class PageSelecter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('QRCodeReader'),
            leading: const Icon(Icons.qr_code_scanner,),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context)=>TabBarDemo(),)
              );
            },
          ),
          ListTile(
            title: const Text('Analysis'),
            leading: const Icon(Icons.show_chart,),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen(),
                ),
                    (route) => false,
              );
            },
          ),
          ListTile(
            title: const Text('Info'),
            leading: const Icon(Icons.info,),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => InfoPage(),
                ),
                    (route) => false,
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings,),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => SetteinsPage(),
                ),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}