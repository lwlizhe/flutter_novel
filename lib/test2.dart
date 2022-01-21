import 'package:flutter/material.dart';
import 'package:flutter_novel/common/palette/palette.dart';
import 'package:flutter_novel/common/util.dart';

class Test2Page extends StatefulWidget {
  const Test2Page({Key? key}) : super(key: key);

  @override
  _Test2PageState createState() => _Test2PageState();
}

class _Test2PageState extends State<Test2Page> {
  final colorList = <MaterialAccentColor>[
    Colors.redAccent,
    Colors.blueAccent,
    Colors.yellowAccent,
    Colors.greenAccent
  ];

  Color themeColor = Colors.transparent;
  final themeColorList = <int>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Staggered',
      child: Container(
        child: Column(
          children: [
            buildButton(
                context: context,
                onPressCallback: () async {
                  var value = Color(0xffff0000).value;

                  var result = await Palette().decodePic();
                  setState(() {
                    result.sort((o1, o2) {
                      return o2.mPopulation - o1.mPopulation;
                    });

                    themeColor = Color(result[0].getRgb());
                    themeColorList.clear();
                    themeColorList.addAll(result.map((e) => e.getRgb()));
                  });
                },
                childWidgetBuilder: (context) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('test'),
                  );
                }),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  height: 100,
                  width: double.infinity,
                  color: Color(themeColorList[index]),
                  alignment: AlignmentDirectional.center,
                  child: Text('${themeColorList[index].toRadixString(16)}'),
                );
              },
              itemCount: themeColorList.length,
            ))
          ],
        ),
      ),
      // child: SingleChildScrollView(
      //   child: StaggeredGrid.count(
      //     crossAxisCount: 4,
      //     mainAxisSpacing: 4,
      //     crossAxisSpacing: 4,
      //     children: const [
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 2,
      //         mainAxisCellCount: 2,
      //         child: Tile(index: 0),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 1,
      //         mainAxisCellCount: 3,
      //         child: Tile(index: 1),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 1,
      //         mainAxisCellCount: 1,
      //         child: Tile(index: 2),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 1,
      //         mainAxisCellCount: 1,
      //         child: Tile(index: 3),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 2,
      //         mainAxisCellCount: 3,
      //         child: Tile(index: 4),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 2,
      //         mainAxisCellCount: 1,
      //         child: Tile(index: 5),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 3,
      //         mainAxisCellCount: 2,
      //         child: Tile(index: 6),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 1,
      //         mainAxisCellCount: 2,
      //         child: Tile(index: 7),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 3,
      //         mainAxisCellCount: 1,
      //         child: Tile(index: 8),
      //       ),
      //       StaggeredGridTile.count(
      //         crossAxisCellCount: 1,
      //         mainAxisCellCount: 2,
      //         child: Tile(index: 9),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

const _defaultColor = Color(0xFF34568B);

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    required this.title,
    this.topPadding = 0,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: child,
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: backgroundColor ?? _defaultColor,
      height: extent,
      child: Center(
        child: CircleAvatar(
          minRadius: 20,
          maxRadius: 20,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: Text('$index', style: const TextStyle(fontSize: 20)),
        ),
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}

class ImageTile extends StatelessWidget {
  const ImageTile({
    Key? key,
    required this.index,
    required this.width,
    required this.height,
  }) : super(key: key);

  final int index;
  final int width;
  final int height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://picsum.photos/$width/$height?random=$index',
      width: width.toDouble(),
      height: height.toDouble(),
      fit: BoxFit.cover,
    );
  }
}

class InteractiveTile extends StatefulWidget {
  const InteractiveTile({
    Key? key,
    required this.index,
    this.extent,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;

  @override
  _InteractiveTileState createState() => _InteractiveTileState();
}

class _InteractiveTileState extends State<InteractiveTile> {
  Color color = _defaultColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (color == _defaultColor) {
            color = Colors.red;
          } else {
            color = _defaultColor;
          }
        });
      },
      child: Tile(
        index: widget.index,
        extent: widget.extent,
        backgroundColor: color,
        bottomSpace: widget.bottomSpace,
      ),
    );
  }
}
