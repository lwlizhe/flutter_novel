import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_detail.dart';
import 'package:flutter_novel/app/widget/widget_tag_view.dart';
import 'package:flutter_novel/base/structure/base_view.dart';
import 'package:flutter_novel/base/structure/base_view_model.dart';

class NovelIntroAppBarHeaderView extends BaseStatelessView {
  final NovelDetailInfo detailInfo;

  /// 为什么通过父widget传入？因为折叠再展开之后，放在state之中的数据会重置……这个后续看下为啥会这么神奇，难道折叠展开之后在element树中不是改属性而是移除重构state？
  final Color bgStartColor;
  final Color bgEndColor;

  NovelIntroAppBarHeaderView(
      this.detailInfo, this.bgStartColor, this.bgEndColor);

  @override
  Widget buildView(BuildContext context, BaseViewModel viewModel) {
    return detailInfo == null
        ? Container()
        : AnimatedContainer(
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                bgStartColor ?? Colors.white,
                bgEndColor ?? Colors.grey[300]
              ],
            )),
            child: Container(
                padding: EdgeInsets.only(
                    top: (MediaQuery.of(context).padding.top + kToolbarHeight)),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              height: 100,
                              child: AspectRatio(
                                aspectRatio: 3 / 4,
                                child: CachedNetworkImage(
                                  imageUrl: detailInfo?.cover == null
                                      ? ""
                                      : Uri.decodeComponent(detailInfo.cover
                                          .split("/agent/")
                                          .last),
                                  fit: BoxFit.cover,
                                  fadeOutDuration: new Duration(seconds: 1),
                                  fadeInDuration: new Duration(seconds: 1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: _buildIntroInfoLayout(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(

                                    children: <Widget>[
                                      Text(
                                          detailInfo == null
                                              ? '0'
                                              : '${detailInfo.rating.score.toStringAsFixed(1)}',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Colors.white)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('${detailInfo?.rating?.count}人评分',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white))
                                    ]),
                                Column(children: <Widget>[
                                  Text(
                                      detailInfo?.retentionRatio == 0
                                          ? "暂无统计"
                                          : '${detailInfo?.retentionRatio}%',
                                      style: TextStyle(
                                          fontSize: 22.0, color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('读者留存',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white))
                                ]),
                                Column(children: <Widget>[
                                  Text('${detailInfo?.latelyFollower}',
                                      style: TextStyle(
                                          fontSize: 22.0, color: Colors.white)),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('7日人气',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white))
                                ])
                              ]),
                        )
                      ],
                    ))),
          );
  }

  @override
  BaseViewModel buildViewModel(BuildContext context) {
    return null;
  }

  @override
  void loadData(BuildContext context, BaseViewModel viewModel) {}

  List<Widget> _buildIntroInfoLayout() {
    if (detailInfo == null) {
      return <Widget>[Text("正在查询中………")];
    } else {
      return <Widget>[
        Row(
          children: <Widget>[
            Text(
              detailInfo.title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(
              width: 5,
            ),
            TagView(
                tag: detailInfo.isSerial ? '连载' : '完结',
                textColor: detailInfo.isSerial
                    ? const Color(0xFF33C3A5)
                    : Colors.redAccent,
                borderColor: detailInfo.isSerial
                    ? const Color(0xFF33C3A5)
                    : Colors.redAccent)
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(children: <Widget>[
                Icon(Icons.account_circle, size: 16, color: Color(0xFF33C3A5)),
                Text(
                  '${detailInfo?.author ?? ""}',
                  style: TextStyle(fontSize: 16, color: Color(0xFF33C3A5)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ], mainAxisSize: MainAxisSize.min),
              Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: 1,
                  color: Colors.white,
                  height: 10),
              Text('${detailInfo?.majorCate ?? ""}',
                  style: TextStyle(fontSize: 16, color: Colors.white))
            ]),
        SizedBox(
          height: 10,
        ),
        Text('${detailInfo?.wordCount ?? "0"}' + "字",
            style: TextStyle(fontSize: 12, color: Colors.white))
      ];
    }
  }
}
