import 'package:flutter/material.dart';
import 'package:flutter_novel/base/view/base_view.dart';
import 'package:flutter_novel/entity/net/entity_forum_comment.dart';
import 'package:flutter_novel/entity/net/entity_forum_post_info.dart';
import 'package:flutter_novel/forum/viewmodel/forum_comment_view_model.dart';
import 'package:flutter_novel/forum/viewmodel/forum_detail_view_model.dart';
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
      return Container(
        padding: EdgeInsets.all(16),
        alignment: AlignmentDirectional.centerStart,
        color: Colors.white12,
        child: Text(value.value?.content ?? ''),
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
        color: Colors.white12,
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
        children: [
          ClipOval(
            child: Container(
              width: 40,
              height: 40,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(child: Text('${commentInfo.content ?? ''}'))
        ],
      ),
    );
  }
}
