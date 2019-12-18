import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_detail.dart';
import 'package:flutter_novel/app/widget/widget_expand_text_view.dart';
import 'package:flutter_novel/app/widget/widget_tag_view.dart';
import 'package:flutter_novel/base/util/utils_color.dart';
import 'package:flutter_novel/base/util/utils_time.dart';

class NovelBookIntroHeaderTagView extends StatelessWidget {
  final NovelDetailInfo detailInfo;

  NovelBookIntroHeaderTagView(this.detailInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.all(15),
        child: Column(children: <Widget>[
          Text('简介', style: TextStyle(fontSize: 22, color: Colors.grey[900])),
          SizedBox(
            height: 5,
          ),

          /// 标签
          Wrap(
            children: tags(detailInfo),
            spacing: 5,
            runSpacing: 3,
          ),
          SizedBox(
            height: 5,
          ),
          ExpandText(
            '${detailInfo?.longIntro}',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            maxLength: 2,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "目录",
                  style: TextStyle(fontSize: 14, color: Colors.grey[850]),
                ),
                flex: 1,
              ),
              Expanded(
                child: Text(
                  '[${detailInfo != null ? (detailInfo.isSerial ? "更新:${TimeUtils.friendlyDateTime(detailInfo?.updated)}" : "完结") : ""}]\t${detailInfo?.lastChapter}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                flex: 4,
              ),
            ],
          ),
        ], crossAxisAlignment: CrossAxisAlignment.start));
  }

  List<Widget> tags(NovelDetailInfo detailInfo) {
    List<Widget> widgets = [];
    if (detailInfo != null) {
      detailInfo.tags.forEach(
        (tag) => widgets.add(
          TagView(
            tag: tag,
            bgColor: ColorUtils.strToColor(tag),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            textColor: Colors.white,
          ),
        ),
      );
    }

    return widgets;
  }
}
