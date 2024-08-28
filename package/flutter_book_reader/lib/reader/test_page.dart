import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestItemPage extends StatelessWidget {
  final Color bgColor;

  const TestItemPage(this.bgColor, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      width: double.infinity,
      height: double.infinity,
      // alignment: AlignmentDirectional.center,
      child: Column(
        children: [
          Text(
            '我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget',
            style: TextStyle(fontSize: 20),
          ),
          GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: '我是图片，可以点击的那种');
            },
            child: Column(
              children: [
                Image.asset(
                  "img/avatar.png",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
                Text('图片和文字可以点击')
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Fluttertoast.showToast(msg: '我是图片，可以点击的那种');
            },
            child: Column(
              children: [
                Image.asset(
                  "img/avatar.png",
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
                Text('图片和文字可以点击')
              ],
            ),
          ),
          Text(
            '我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget ，我是 Text Widget',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
