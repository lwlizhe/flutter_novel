import 'package:flutter/material.dart';

class NovelTopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: InkWell(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "top menu",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            )),
        onTap: () {
          print("menuItem clicked");
        },
      ),
    );
  }
}
