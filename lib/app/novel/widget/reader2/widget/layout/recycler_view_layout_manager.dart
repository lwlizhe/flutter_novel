import 'package:flutter/widgets.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/recycler_view.dart';

abstract class LayoutManager {
  var itemDecorationList = <ItemDecoration>[];
  OnPaintTransformCallback? onPaintTransformCallback;

  LayoutManager({this.onPaintTransformCallback});

  void addItemDecoration(ItemDecoration decoration) {
    itemDecorationList.add(decoration);
  }

  void removeItemDecoration(ItemDecoration decoration) {
    itemDecorationList.remove(decoration);
  }

  Matrix4? onPaintTransform(int index,ItemDecorationState state) {
    if (onPaintTransformCallback != null) {
      return onPaintTransformCallback!(index, state);
    }
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

  LinearLayoutManager({OnPaintTransformCallback? onPaintTransformCallback}) : super(onPaintTransformCallback: onPaintTransformCallback);
}

class PathLayoutManager extends LayoutManager{
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

  Path path;

  PathLayoutManager(this.path,{OnPaintTransformCallback? onPaintTransformCallback}) : super(onPaintTransformCallback: onPaintTransformCallback);
}

typedef OnDrawCallback(
    Canvas c, RecyclerView? parent, ItemDecorationState state);
typedef OnDrawOverCallback(
    Canvas c, RecyclerView? parent, ItemDecorationState state);
typedef Rect OnGetItemOffsetRectCallback(int index, ItemDecorationState state);
typedef Matrix4? OnPaintTransformCallback(int index, ItemDecorationState state);

class ItemDecoration {
  OnDrawCallback? onDrawCallback;
  OnDrawOverCallback? onDrawOverCallback;
  OnGetItemOffsetRectCallback? onGetItemOffsetRectCallback;

  ItemDecoration({
    this.onDrawCallback,
    this.onDrawOverCallback,
    this.onGetItemOffsetRectCallback,
  });

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

  Rect getItemOffsetRect(int index, ItemDecorationState state) {
    if (onGetItemOffsetRectCallback != null) {
      return onGetItemOffsetRectCallback!(index, state);
    } else {
      return Rect.zero;
    }
  }
}

class ItemDecorationState {
  Offset? itemOffset;

  Rect? contentRangeRect;
}
