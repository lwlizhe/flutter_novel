import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/helper_reader_content.dart';

class NovelReaderErrorPageWidget extends StatelessWidget {
  final ReaderContentDataValue dataValue;

  NovelReaderErrorPageWidget(this.dataValue);

  @override
  Widget build(BuildContext context) {
    Widget result;

    switch (dataValue.contentState) {
      case ContentState.STATE_NORMAL:
        result = Container(width: 0,height: 0,);
        break;
      case ContentState.STATE_NOT_FOUND:
        result = Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Text("当前章节不存在\n点击屏幕调出菜单，跳转到下一章"),
        );
        break;
      case ContentState.STATE_NET_ERROR:
        result = Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("加载出错，点击重试按钮再次尝试"),
              MaterialButton(
                onPressed: () {},
                child: Text("重试"),
              )
            ],
          ),
        );
        break;
    }

    return result;
  }
}
