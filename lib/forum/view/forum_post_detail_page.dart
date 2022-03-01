import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/entity/net/entity_forum_comment.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/forum/viewmodel/forum_comment_view_model.dart';
import 'package:flutter_novel/forum/viewmodel/forum_detail_view_model.dart';
import 'package:flutter_novel/widget/text/expandable_text.dart';
import 'package:get/get.dart';

enum ForumDetailType { post, bookReview }

class ForumPostDetailPage extends BaseView<ForumDetailViewModel> {
  final ForumDetailType detailType;
  final String? detailId;

  ForumPostDetailPage({required this.detailType, required this.detailId});

  @override
  Widget buildContent(BuildContext context, ForumDetailViewModel viewModel) {
    return _DetailContentView(
      detailType: detailType,
      detailId: detailId,
    );
  }

  @override
  ForumDetailViewModel buildViewModel() {
    switch (detailType) {
      case ForumDetailType.post:
        return ForumPostDetailViewModel(detailId);
      case ForumDetailType.bookReview:
      default:
        return ForumBookReviewDetailViewModel(detailId);
    }
  }

  @override
  String? get tag => detailId;
}

/// 帖子的内容部分
class _DetailContentView extends StatefulWidget {
  final ForumDetailType detailType;
  final String? detailId;

  const _DetailContentView(
      {Key? key, required this.detailType, required this.detailId})
      : super(key: key);

  @override
  _DetailContentViewState createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<_DetailContentView> {
  @override
  Widget build(BuildContext context) {
    var listChildren = [
      LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          switch (widget.detailType) {
            case ForumDetailType.post:
              return _PostIntroView(
                detailId: widget.detailId,
              );
            case ForumDetailType.bookReview:
            default:
              return _BookReviewIntroView();
          }
        },
      ),
      _CommentView(widget.detailId ?? '', widget.detailType)
    ];

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: ListView.separated(

            /// 因为item就两个，所以设置cacheExtent特别大来让未被加载的Comment部分启动加载，
            /// 来防止介绍页过大的情况下，会触发Comment的销毁的情况
            cacheExtent: double.maxFinite,
            itemBuilder: (context, index) {
              return listChildren[index];
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 16,
              );
            },
            itemCount: listChildren.length),
      ),
    );
  }
}

/// 帖子介绍页
class _PostIntroView extends StatelessWidget {
  final String? detailId;

  const _PostIntroView({Key? key, required this.detailId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = (Get.find<ForumDetailViewModel>(tag: detailId)
            as ForumPostDetailViewModel)
        .currentDetailInfo;

    return ObxValue<Rx<ForumPostInfo?>>((value) {
      var commentInfo = value.value;

      return Container(
        color: Color(0xFF4E4E4E),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: 'http://api.zhuishushenqi.com' +
                    (commentInfo?.author?.avatar ?? ''),
                width: 40,
                height: 40,
                errorWidget: (context, url, error) {
                  return Container(
                    color: Colors.white,
                  );
                },
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(commentInfo?.author?.nickname ?? '')),
                    Text('点赞数 : ${(commentInfo?.likeCount ?? 0)}'),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: BrnExpandableText(
                    text: value.value?.content ?? '',
                    maxLines: 5,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      commentInfo?.created ?? '',
                      style: TextStyle(fontSize: 12, color: Color(0xA0FFFFFF)),
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      );
    }, data);
  }
}

/// 书评介绍页
class _BookReviewIntroView extends StatelessWidget {
  const _BookReviewIntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      child: Text('书评详情部分'),
    );
  }
}

/// 评论页面
class _CommentView extends BaseView<ForumCommentViewModel> {
  final String id;
  final ForumDetailType detailType;

  _CommentView(this.id, this.detailType);

  @override
  Widget buildContent(BuildContext context, ForumCommentViewModel viewModel) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HotComment(
            id: id,
          ),
          SizedBox(
            height: 8,
          ),
          _LatestComment(id: id),
        ],
      ),
    );
  }

  @override
  ForumCommentViewModel buildViewModel() {
    return ForumCommentViewModel(id, detailType);
  }

  @override
  String? get tag => id;
}

/// 热门评论
class _HotComment extends StatelessWidget {
  final String id;

  const _HotComment({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Get.find<ForumCommentViewModel>(tag: id).hotComment;

    return ObxValue<Rx<ForumCommentInfo?>>((value) {
      if (value.value == null) {
        return SizedBox.shrink();
      }

      return Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('热门评论'),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _CommentItem(value.value!);
              },
              itemCount: 1,
              shrinkWrap: true,
            )
          ],
        ),
      );
    }, data);
  }
}

/// 最近评论
class _LatestComment extends StatelessWidget {
  final String id;

  const _LatestComment({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = Get.find<ForumCommentViewModel>(tag: id).latestComments;

    return ObxValue<RxList<ForumCommentInfo>>((value) {
      if (value.isEmpty) {
        return SizedBox.shrink();
      }

      return Container(
        color: Color(0xFF4E4E4E),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 40,
              alignment: AlignmentDirectional.centerStart,
              child: Text('最新评论'),
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _CommentItem(value[index]);
              },
              itemCount: value.length,
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 1,
                  width: double.infinity,
                  color: Theme.of(context).canvasColor,
                  margin: EdgeInsetsDirectional.only(start: 68),
                );
              },
            )
          ],
        ),
      );
    }, data);
  }
}

class _CommentItem extends StatelessWidget {
  final ForumCommentInfo commentInfo;

  _CommentItem(this.commentInfo);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: 'http://api.zhuishushenqi.com' +
                  (commentInfo.author?.avatar ?? ''),
              width: 40,
              height: 40,
              errorWidget: (context, url, error) {
                return Container(
                  color: Colors.white,
                );
              },
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Text(commentInfo.author?.nickname ?? '')),
                  Text('点赞数 : ${(commentInfo.likeCount ?? 0)}'),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('${commentInfo.content ?? ''}'),
              ),
              Row(
                children: [
                  Text(
                    commentInfo.created ?? '',
                    style: TextStyle(fontSize: 12, color: Color(0xA0FFFFFF)),
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}
