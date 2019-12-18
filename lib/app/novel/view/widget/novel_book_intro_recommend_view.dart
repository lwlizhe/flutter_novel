import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/entity/entity_novel_book_recommend.dart';

class NovelIntroBookRecommendView extends StatelessWidget {
  final NovelBookRecommend recommendInfo;

  NovelIntroBookRecommendView(this.recommendInfo);

  @override
  Widget build(BuildContext context) {
    return interestedView(context);
  }

  Widget interestedView(BuildContext context) {
    Widget result = Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Text("正在查询中……"),
      padding: EdgeInsets.all(20),
    );

    if (recommendInfo != null) {
      result = Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Text('你可能感兴趣的', style: TextStyle(fontSize: 16)),
              InkWell(
                child: Text('更多',
                    style: TextStyle(fontSize: 14, color: Colors.green)),
              )
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
            GridView.builder(
                padding: EdgeInsets.all(0),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 9 / 16,
                    crossAxisCount: 4,
                    crossAxisSpacing: 5),
                itemBuilder: (_, index) => _ItemPictureBook(
                      book: recommendInfo.books[index],
                    ),
                itemCount: 4)
          ],
        ),
      );
    }

    return result;
  }
}

class _ItemPictureBook extends StatelessWidget {
  final Books book;
  final VoidCallback onPressed;

  _ItemPictureBook({Key key, @required this.book, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
          child: Container(
            child: Column(
              children: <Widget>[
                CachedNetworkImage(
                    imageUrl:
                        Uri.decodeComponent(book.cover.split("/agent/").last)),
                Text('${book?.title}',
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
          onTap: onPressed),
    );
  }
}
