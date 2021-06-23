import 'dart:math';

import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/layout/recycler_view_layout_manager.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/recycler_view.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/util/diff_util.dart';

class NovelPageReader2 extends StatefulWidget {
  NovelPageReader2(Key readerKey) : super();

  @override
  _NovelPageReaderState createState() => _NovelPageReaderState();
}

class _NovelPageReaderState extends State<NovelPageReader2> {
  List<int> list = [];
  var dataList = <ValueListenable<int>>[];
  ValueNotifier<List<int>> dataList2Notify = ValueNotifier<List<int>>([]);

  List<MaterialColor> colorsList = [
    Colors.red,
    Colors.blue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.yellow
  ];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      list.add(i);
    }

    dataList = list.map((e) => new ValueNotifier<int>(e)).toList();
    dataList2Notify.value = list;
  }

  @override
  Widget build(BuildContext context) {
    // var testList1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
    // var testList2 = [1, 2, 11, 4, 5, 6, 7, 8, 9, 0];
    //
    // DiffUtil.calculateDiff(
    //     Callback<int>(isContentsTheSameFunc: (oldPosition, newPosition) {
    //   return testList1[oldPosition] == testList2[newPosition];
    // }, isItemsSameFunc: (oldPosition, newPosition) {
    //   return testList1[oldPosition] == testList2[newPosition];
    // }, newListSizeFunc: () {
    //   return testList1.length;
    // }, oldListSizeFunc: () {
    //   return testList2.length;
    // }));

    return Container(
      child: RecyclerView.builder(
          scrollDirection: Axis.horizontal,
          // physics: RecyclerViewAlwaysScrollableScrollPhysics(),
          layoutManager: LinearLayoutManager()
            ..addItemDecoration(ItemDecoration(
              onDrawCallback: (_canvas, _parent, _state) {
                _canvas.drawRect(
                    Rect.fromLTRB(
                        _state.itemOffset.dx + 250,
                        _state.itemOffset.dy + 300,
                        _state.itemOffset.dx + 250 + 50,
                        _state.itemOffset.dy + 300 + 50),
                    new Paint()..color = Colors.red);
              },
              onDrawOverCallback: (_canvas, _parent, _state) {
                _canvas.drawRect(
                    Rect.fromLTRB(
                        _state.itemOffset.dx + 200,
                        _state.itemOffset.dy + 200,
                        _state.itemOffset.dx + 200 + 50,
                        _state.itemOffset.dy + 200 + 50),
                    new Paint()..color = Colors.black);
              },
              onGetItemOffsetsCallback:
                  (Offset outOffset, _item, _parent, _state) {
                return Offset(outOffset.dx + 100, outOffset.dy);
              },
            )),
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            ValueListenable<int> item = dataList[index];
            return ValueListenableBuilder<int>(
                valueListenable: item,
                builder: (context, value, child) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.white,
                          colorsList[value.toInt() % (colorsList.length - 1)],
                        ]), //背景渐变
                        borderRadius: BorderRadius.circular(40.0), //3像素圆角
                        boxShadow: [
                          //阴影
                          BoxShadow(
                              color: Colors.black54,
                              offset: Offset(3.0, -2.0),
                              blurRadius: 4.0)
                        ]),
                    child: Container(
                        alignment: AlignmentDirectional.center,
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        // height: MediaQuery.of(context).size.height,
                        child: Text(
                          value.toString(),
                        )),
                  );
                });
          }),
    );
  }
}

// class RecyclerViewAlwaysScrollableScrollPhysics extends ClampingScrollPhysics {
//   const RecyclerViewAlwaysScrollableScrollPhysics({ScrollPhysics parent})
//       : super(parent: parent);
//
//   @override
//   RecyclerViewAlwaysScrollableScrollPhysics applyTo(ScrollPhysics ancestor) {
//     return RecyclerViewAlwaysScrollableScrollPhysics(
//         parent: buildParent(ancestor));
//   }
//
//   @override
//   double applyBoundaryConditions(ScrollMetrics position, double value) {
//     assert(() {
//       if (value == position.pixels) {
//         throw FlutterError.fromParts(<DiagnosticsNode>[
//           ErrorSummary(
//               '$runtimeType.applyBoundaryConditions() was called redundantly.'),
//           ErrorDescription(
//             'The proposed new position, $value, is exactly equal to the current position of the '
//             'given ${position.runtimeType}, ${position.pixels}.\n'
//             'The applyBoundaryConditions method should only be called when the value is '
//             'going to actually change the pixels, otherwise it is redundant.',
//           ),
//           DiagnosticsProperty<ScrollPhysics>(
//               'The physics object in question was', this,
//               style: DiagnosticsTreeStyle.errorProperty),
//           DiagnosticsProperty<ScrollMetrics>(
//               'The position object in question was', position,
//               style: DiagnosticsTreeStyle.errorProperty),
//         ]);
//       }
//       return true;
//     }());
//     if (value < position.pixels &&
//         position.pixels <= position.minScrollExtent) // underscroll
//       return value - position.pixels;
//     if (position.maxScrollExtent + 100 <= position.pixels &&
//         position.pixels < value) // overscroll
//       return value - position.pixels;
//     if (value < position.minScrollExtent &&
//         position.minScrollExtent < position.pixels) // hit top edge
//       return value - position.minScrollExtent;
//     if (position.pixels <= position.maxScrollExtent + 100 &&
//         position.maxScrollExtent + 100 < value) // hit bottom edge
//       return value - (position.maxScrollExtent + 100);
//     return 0.0;
//   }
// }
