import 'package:flutter/widgets.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/recycler_view.dart';

abstract class LayoutManager {
  var itemDecorationList = <ItemDecoration>[];

  void addItemDecoration(ItemDecoration decoration) {
    itemDecorationList.add(decoration);
  }

  void removeItemDecoration(ItemDecoration decoration) {
    itemDecorationList.remove(decoration);
  }
}

class LinearLayoutManager extends LayoutManager {
  @override
  int getItemCount() {
    return 0;
  }

  @override
  int getItemType() {
    return 0;
  }

  @override
  Widget? getItemWidget() {
    return null;
  }
}

typedef OnDrawCallback(
    Canvas c, RecyclerView? parent, ItemDecorationState state);
typedef OnDrawOverCallback(
    Canvas c, RecyclerView? parent, ItemDecorationState state);
typedef Offset OnGetItemOffsetsCallback(Offset childPaddingOffset, RenderBox? view,
    RecyclerView? parent, ItemDecorationState state);

class ItemDecoration {
  OnDrawCallback? onDrawCallback;
  OnDrawOverCallback? onDrawOverCallback;
  OnGetItemOffsetsCallback? onGetItemOffsetsCallback;

  ItemDecoration(
      {this.onDrawCallback,
      this.onDrawOverCallback,
      this.onGetItemOffsetsCallback});

  void onDraw(Canvas c, ItemDecorationState state) {
    if (onDrawCallback != null) {
      onDrawCallback!(c, null, state);
    }
  }

  void onDrawOver(Canvas c, ItemDecorationState state) {
    if (onDrawOverCallback != null) {
      onDrawOverCallback!(c, null, state);
    }
  }

  Offset getItemOffsets(Offset childPaddingRect, RenderBox? view, ItemDecorationState state) {
    if (onGetItemOffsetsCallback != null) {
      return onGetItemOffsetsCallback!(childPaddingRect, view, null, state);
    } else {
      return childPaddingRect;
    }
  }
}

class ItemDecorationState {
  late Offset itemOffset;
}
