import 'dart:math';
import 'dart:ui' as ui;

import 'dart:math' as math;
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/layout/recycler_view_layout_manager.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/recycler_view.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/util/diff_util.dart';
import 'package:flutter_novel/base/util/utils_toast.dart';

class NovelPageReader2 extends StatefulWidget {
  NovelPageReader2(Key readerKey) : super();

  @override
  _NovelPageReaderState createState() => _NovelPageReaderState();
}

class _NovelPageReaderState extends State<NovelPageReader2> {
  List<int> list = [];
  var dataList = <ValueListenable<int>>[];
  ValueNotifier<List<int>> dataList2Notify = ValueNotifier<List<int>>([]);
  var random = new Random();

  List<MaterialColor> colorsList = [
    Colors.red,
    Colors.blue,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.green,
    Colors.yellow
  ];

  late Path targetPath;
  Paint painter = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5;

  GlobalKey _myCanvasKey = new GlobalKey();
  ImageEditor editor = ImageEditor();

  bool isDrawFinish = false;
  bool isShowPath = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 10; i++) {
      list.add(i);
    }

    dataList = list.map((e) => new ValueNotifier<int>(e)).toList();
    dataList2Notify.value = list;

    targetPath = Path();
  }

  Widget _buildImage() {
    return Container(
      child: GestureDetector(
        onPanDown: (detailData) {
          editor.update(detailData.localPosition);
          _myCanvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
        },
        onPanUpdate: (detailData) {
          editor.update(detailData.localPosition);
          _myCanvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
        },
        child: CustomPaint(
          key: _myCanvasKey,
          painter: editor,
        ),
      ),
    );
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

    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: AlignmentDirectional.center,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.amber,
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            targetPath = editor.drawPath ?? Path();
                            isDrawFinish = true;
                          });
                        },
                        child: Text('画完了路径')),
                    TextButton(
                        onPressed: () {
                          editor.drawPath?.reset();
                          editor.drawPath = null;
                          _myCanvasKey.currentContext
                              ?.findRenderObject()
                              ?.markNeedsPaint();
                          setState(() {
                            isDrawFinish = false;
                          });
                        },
                        child: Text('清空路径，重设')),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isShowPath = !isShowPath;
                          });
                        },
                        child: Text(isShowPath ? '隐藏路径' : '显示路径')),
                  ],
                ),
                Text(isDrawFinish
                    ? '现在是listView，横向滑动以登月'
                    : '现在是customPaint，在屏幕中画出路径，以蓝色显示'),
                Expanded(
                    child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "img/bg_mid_autumn.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned.fill(child:
                          LayoutBuilder(builder: (_context, _constraint) {
                        if (!isDrawFinish) {
                          return _buildImage();
                        }

                        return RecyclerView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: ScrollController(
                                initialScrollOffset: -_constraint.maxWidth),
                            itemCount: 2,
                            reverse: true,
                            addRepaintBoundaries: false,
                            layoutManager: PathLayoutManager(targetPath,
                                onPaintTransformCallback: (_index, _state) {
                              var ratio = -(_state.itemOffset!.dx / (800));
                              var angle = (ratio) * pi;
                              var scale = ratio;

                              print(
                                  'ratio is $ratio , scale is $scale, angle is $angle , offset is ${_state.itemOffset!.dx} , ');
                              var result = Matrix4.identity();

                              // result.multiply(Matrix4.translationValues(_state.itemOffset?.dx??0, 0, 0));

                              // if((_state.itemOffset?.dx??0)!=0) {
                              //     var translation = Alignment.topLeft.alongSize(_state.contentRangeRect?.size??Size.zero);
                              //     result.translate(translation.dx, translation.dy);
                              // }

                              // result.multiply(Matrix4.rotationX(angle));
                              // result.multiply(Matrix4.rotationY(angle));
                              // result.multiply(Matrix4.rotationZ(angle));
                              // result.multiply(Matrix4.rotationZ(angle));
                              // var result = Matrix4.identity();
                              // result.multiply(
                              //     Matrix4.diagonal3Values(1 - scale, 1 - scale, 1.0));
                              return result;
                              // return Matrix4.rotationZ(angle);
                            })
                              ..addItemDecoration(ItemDecoration(
                                onDrawCallback: (_canvas, _parent, _state) {
                                  // _canvas.drawRect(Rect.fromLTRB(0, 0, 300, 300),
                                  //     new Paint()..color = Colors.red);
                                  //
                                  // final textStyle = TextStyle(
                                  //   color: Colors.black,
                                  //   fontSize: 16,
                                  // );
                                  // final textSpan = TextSpan(
                                  //   text: 'Recycler View on Draw Test',
                                  //   style: textStyle,
                                  // );
                                  // final textPainter = TextPainter(
                                  //   text: textSpan,
                                  //   textDirection: TextDirection.ltr,
                                  // );
                                  // textPainter.layout(
                                  //   minWidth: 0,
                                  //   maxWidth: 500,
                                  // );
                                  // final offset = Offset(10, 100);
                                  // textPainter.paint(_canvas, offset);
                                  if (isShowPath) {
                                    _canvas.drawPath(targetPath, painter);
                                  }
                                },
                                onDrawOverCallback: (_canvas, _parent, _state) {
                                  // var drawRect = Rect.fromLTRB(
                                  //     (_state.itemOffset?.dx ?? 0) + 200,
                                  //     (_state.itemOffset?.dy ?? 0) + 200,
                                  //     (_state.itemOffset?.dx ?? 0) + 200 + 50,
                                  //     (_state.itemOffset?.dy ?? 0) + 200 + 50);
                                  //
                                  // _canvas.drawRect(drawRect, new Paint()..color = Colors.black);

                                  // _canvas.drawCircle(Offset(50, 150), 50,
                                  //     Paint()..color = Colors.amber);
                                },
                                onGetItemOffsetRectCallback:
                                    (int index, _state) {
                                  return Rect.fromLTRB(0, 0, 0, 0);
                                  // return Rect.fromLTRB(
                                  //     (random.nextInt(100) * random.nextInt(4)) + 50,
                                  //     0,
                                  //     50,
                                  //     0);
                                },
                              )),
                            itemBuilder: (context, index) {
                              ValueListenable<int> item = dataList[index];

                              return GestureDetector(
                                onTap: () {
                                  ToastUtils.showToast('嫦娥被抓住了');
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.red,
                                  child: Stack(
                                    alignment:AlignmentDirectional.center,children: [
                                    Positioned.fill(child: Image.asset(
                                      "img/img_chang_e.png",
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 100,
                                    )),
                                    Text('$index'),
                                  ],),
                                ),
                              );

                              return Container(
                                alignment: AlignmentDirectional.topStart,
                                height: 100,
                                width: 200,
                                child: ValueListenableBuilder<int>(
                                    valueListenable: item,
                                    builder: (context, value, child) {
                                      return GestureDetector(
                                        onTap: () {
                                          ToastUtils.showToast(
                                            index == 0 ? '这个是能酱' : '这个是鹏少',
                                          );
                                        },
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(colors: [
                                                Colors.white,
                                                colorsList[value.toInt() %
                                                    (colorsList.length - 1)],
                                              ]),
                                              //背景渐变
                                              borderRadius:
                                                  BorderRadius.circular(40.0),
                                              //3像素圆角
                                              boxShadow: [
                                                //阴影
                                                BoxShadow(
                                                    color: Colors.black54,
                                                    offset: Offset(3.0, -2.0),
                                                    blurRadius: 4.0)
                                              ]),
                                          child: Container(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              width: 200,
                                              height: 100,
                                              // height: MediaQuery.of(context).size.height,
                                              child: Text(
                                                index == 0 ? '这个是能酱' : '这个是鹏少',
                                              )),
                                        ),
                                      );
                                    }),
                              );
                            });
                      })),
                    ],
                  ),
                ))
              ],
            ),

            // child: LayoutBuilder(builder: (_context, _constraint) {
            //   if (!isDrawFinish) {
            //     return _buildImage();
            //   }
            //
            //   return RecyclerView.builder(
            //       scrollDirection: Axis.horizontal,
            //       controller: ScrollController(
            //           initialScrollOffset: -_constraint.maxWidth),
            //       itemCount: 3,
            //       reverse: true,
            //       addRepaintBoundaries: false,
            //       layoutManager: PathLayoutManager(targetPath,
            //           onPaintTransformCallback: (_index, _state) {
            //             var ratio = -(_state.itemOffset!.dx / (400));
            //             var angle = (ratio) * pi;
            //             var scale = ratio;
            //
            //             print(
            //                 'ratio is $ratio , scale is $scale, angle is $angle , offset is ${_state.itemOffset!.dx} , ');
            //             var result = Matrix4.identity();
            //
            //             // result.multiply(Matrix4.translationValues(_state.itemOffset?.dx??0, 0, 0));
            //
            //             // if((_state.itemOffset?.dx??0)!=0) {
            //             //     var translation = Alignment.topLeft.alongSize(_state.contentRangeRect?.size??Size.zero);
            //             //     result.translate(translation.dx, translation.dy);
            //             // }
            //
            //             // result.multiply(Matrix4.rotationX(angle));
            //             // result.multiply(Matrix4.rotationY(angle));
            //             // result.multiply(Matrix4.rotationZ(angle));
            //             // result.multiply(Matrix4.rotationZ(angle));
            //             // var result = Matrix4.identity();
            //             // result.multiply(
            //             //     Matrix4.diagonal3Values(1 - scale, 1 - scale, 1.0));
            //             return result;
            //             // return Matrix4.rotationZ(angle);
            //           })
            //         ..addItemDecoration(ItemDecoration(
            //           onDrawCallback: (_canvas, _parent, _state) {
            //             // _canvas.drawRect(Rect.fromLTRB(0, 0, 300, 300),
            //             //     new Paint()..color = Colors.red);
            //             //
            //             // final textStyle = TextStyle(
            //             //   color: Colors.black,
            //             //   fontSize: 16,
            //             // );
            //             // final textSpan = TextSpan(
            //             //   text: 'Recycler View on Draw Test',
            //             //   style: textStyle,
            //             // );
            //             // final textPainter = TextPainter(
            //             //   text: textSpan,
            //             //   textDirection: TextDirection.ltr,
            //             // );
            //             // textPainter.layout(
            //             //   minWidth: 0,
            //             //   maxWidth: 500,
            //             // );
            //             // final offset = Offset(10, 100);
            //             // textPainter.paint(_canvas, offset);
            //           },
            //           onDrawOverCallback: (_canvas, _parent, _state) {
            //             // var drawRect = Rect.fromLTRB(
            //             //     (_state.itemOffset?.dx ?? 0) + 200,
            //             //     (_state.itemOffset?.dy ?? 0) + 200,
            //             //     (_state.itemOffset?.dx ?? 0) + 200 + 50,
            //             //     (_state.itemOffset?.dy ?? 0) + 200 + 50);
            //             //
            //             // _canvas.drawRect(drawRect, new Paint()..color = Colors.black);
            //
            //             _canvas.drawPath(targetPath, painter);
            //             _canvas.drawCircle(
            //                 Offset(50, 150), 50, Paint()..color = Colors.amber);
            //           },
            //           onGetItemOffsetRectCallback: (int index, _state) {
            //             return Rect.fromLTRB(0, 0, 0, 0);
            //             // return Rect.fromLTRB(
            //             //     (random.nextInt(100) * random.nextInt(4)) + 50,
            //             //     0,
            //             //     50,
            //             //     0);
            //           },
            //         )),
            //       itemBuilder: (context, index) {
            //         ValueListenable<int> item = dataList[index];
            //
            //         return Container(
            //           alignment: AlignmentDirectional.topStart,
            //           height: 100,
            //           width: 200,
            //           child: ValueListenableBuilder<int>(
            //               valueListenable: item,
            //               builder: (context, value, child) {
            //                 return GestureDetector(
            //                   onTap: () {
            //                     ToastUtils.showToast(
            //                       index == 0 ? '这个是能酱' : '这个是鹏少',
            //                     );
            //                   },
            //                   child: DecoratedBox(
            //                     decoration: BoxDecoration(
            //                         gradient: LinearGradient(colors: [
            //                           Colors.white,
            //                           colorsList[value.toInt() %
            //                               (colorsList.length - 1)],
            //                         ]),
            //                         //背景渐变
            //                         borderRadius: BorderRadius.circular(40.0),
            //                         //3像素圆角
            //                         boxShadow: [
            //                           //阴影
            //                           BoxShadow(
            //                               color: Colors.black54,
            //                               offset: Offset(3.0, -2.0),
            //                               blurRadius: 4.0)
            //                         ]),
            //                     child: Container(
            //                         alignment: AlignmentDirectional.center,
            //                         width: 200,
            //                         height: 100,
            //                         // height: MediaQuery.of(context).size.height,
            //                         child: Text(
            //                           index == 0 ? '这个是能酱' : '这个是鹏少',
            //                         )),
            //                   ),
            //                 );
            //               }),
            //         );
            //       });
            // }),
          ),
        ),
      ),
    );
  }
}

class ImageEditor extends CustomPainter {
  ImageEditor();

  Path? drawPath;

  final Paint painter = new Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10;

  void update(Offset offset) {
    if (drawPath == null) {
      drawPath = Path()..moveTo(offset.dx, offset.dy);
    }

    drawPath?.lineTo(offset.dx, offset.dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (drawPath != null) {
      canvas.drawPath(drawPath!, painter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
