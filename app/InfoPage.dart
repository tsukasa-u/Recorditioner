import 'package:flutter/material.dart';
import 'PageSelector.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PageSelecter(),
      appBar: AppBar(
        title: Text('InfoPage'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: const Center(
            child: Text("under construct")
        ),
      ),
    );
  }
}