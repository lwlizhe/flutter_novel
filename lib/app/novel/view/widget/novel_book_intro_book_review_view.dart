import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/api/api_novel.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_review.dart';
import 'package:flutter_novel/app/widget/widget_tag_view.dart';
import 'package:flutter_novel/base/util/utils_time.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class NovelIntroBookReviewView extends StatelessWidget {
  final NovelBookReview reviewInfo;

  NovelIntroBookReviewView(this.reviewInfo);

  @override
  Widget build(BuildContext context) {
    if (reviewInfo == null || reviewInfo.reviews == null) {
      return Container(
        alignment: Alignment.center,
        child: Text("正在查询中……"),
        padding: EdgeInsets.all(20),
      );
    } else {
      return  Container(
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child:  Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "热门书评",
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                        child: Row(children: <Widget>[
                          Icon(Icons.edit, color: Colors.green, size: 15),
                          Text('写书评',
                              style:
                              TextStyle(fontSize: 14, color: Colors.green))
                        ], mainAxisSize: MainAxisSize.min),
                        onTap: () {})
                  ],
                ),
                ListView.separated(
                    padding: EdgeInsets.only(top: 5),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (_, index) =>
                        _ItemReview(review: reviewInfo?.reviews[index]),
                    separatorBuilder: (_, index) => Divider(
                      height: 20,
                      indent: 0.0,
                      color: Colors.grey,
                    ),
                    itemCount: reviewInfo?.reviews?.length ?? 0),
                InkWell(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text('全部书评',
                            style:
                            TextStyle(color: Colors.green, fontSize: 14)),
                        alignment: Alignment.center),
                    onTap: (reviewInfo?.reviews?.length ?? 0) == 0 ? null : () {})
              ],
            ),
          );
    }
  }
}

class _ItemReview extends StatelessWidget {
  final Reviews review;

  _ItemReview({Key key, @required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// 作者
                Row(children: <Widget>[
                  ClipOval(
                    child: CachedNetworkImage(
                      width: 25,
                      height: 25,
                      imageUrl: NovelApi.READER_IMAGE_URL +
                          review?.author?.avatar,
                      fit: BoxFit.cover,
//                    errorWidget: (context, url, error) =>
//                        Image.asset("img/loading_4.png"),
                      fadeOutDuration: new Duration(seconds: 1),
                      fadeInDuration: new Duration(seconds: 1),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text('${review?.author?.nickname}',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(
                    width: 5,
                  ),
                  TagView(
                      tag: 'Lv${review?.author?.lv}',
                      textColor:
                      review.author.lv > 5 ? Colors.blueAccent : null,
                      borderColor:
                      review.author.lv > 5 ? Colors.blueAccent : null)
                ]),
                SizedBox(
                  height: 5,
                ),

//                /// 评分
//                Row(children: <Widget>[
//                  SmoothStarRating(
//                      rating: commentInfo?.rating?.toDouble(),
//                      size: 15,
//                      allowHalfRating: false,
//                      color: starColor,
//                      borderColor: Colors.grey),
//                  Text('${commentInfo?.ratingDesc}', style: TextStyles.textGrey12)
//                ]),
//                SizedBox(height: 5,),

                /// content
                Text('${review?.content}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[850]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis),
                SizedBox(
                  height: 5,
                ),

                /// 时间/回复/赞
                Row(children: <Widget>[
                  Text('${TimeUtils.friendlyDateTime(review?.created)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Icon(Feather.thumbs_up, size: 15, color: Colors.grey),
                    SizedBox(
                      height: 5,
                    ),
                    Text('${review?.likeCount}',
                        style: TextStyle(fontSize: 12, color: Colors.grey))
                  ])
                ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
              ],
            ),
          ),
          onTap: () {}),
    );
  }
}
