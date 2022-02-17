import 'package:flutter/material.dart';
import 'package:flutter_novel/widget/reorder/grid/book_shelf_reorder_grid.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// test
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

  var dataList = List.filled(10, "", growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedListSample(),
      ),
    );
  }
}

class AnimatedListSample extends StatefulWidget {
  const AnimatedListSample({Key? key}) : super(key: key);

  @override
  State<AnimatedListSample> createState() => _AnimatedListSampleState();
}

class _AnimatedListSampleState extends State<AnimatedListSample> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<int> _list;
  int? _selectedItem;

  var key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _list = List.generate(30, (index) => index, growable: true);
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(BuildContext context, int index) {
    return CardItem(
      // animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        Fluttertoast.showToast(msg: 'item 点击了');
      },
    );
  }

  // Used to build an item after it has been removed from the list. This
  // method is needed because a removed item remains visible until its
  // animation has completed (even though it's gone as far this ListModel is
  // concerned). The widget will be used by the
  // [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
      int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      // animation: animation,
      item: item,
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    setState(() {
      // final int index =
      //     _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
      // _list.insert(0, _nextItem++);
    });
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem!));
      setState(() {
        _selectedItem = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BookShelfGrid.builder(
      sliverGridKey: key,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 3.0 / 4.8),
      itemBuilder: (context, index) {
        return _buildItem(context, index);
      },
      itemCount: _list.length,
      onReOrder: (toIndex, fromIndex) {
        print('to is $toIndex, from is $fromIndex');
        setState(() {
          _list.insert(toIndex, _list.removeAt(fromIndex));
        });
      },
    );
  }
}

typedef RemovedItemBuilder<T> = Widget Function(
    T item, BuildContext context, Animation<double> animation);

/// Displays its integer item as 'item N' on a Card whose color is based on
/// the item's value.
///
/// The text is displayed in bright green if [selected] is
/// true. This widget's height is based on the [animation] parameter, it
/// varies from 0 to 128 as the animation varies from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    this.onTap,
    this.selected = false,
    // required this.animation,
    required this.item,
  })  : assert(item >= 0),
        super(key: key);

  // final Animation<double> animation;
  final VoidCallback? onTap;
  final int item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline4!;
    if (selected) {
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: 80.0,
          child: Card(
            color: Colors.primaries[item % Colors.primaries.length],
            child: Center(
              child: Text('Item $item', style: textStyle),
            ),
          ),
        ),
      ),
      // child: SizeTransition(
      //   sizeFactor: animation,
      //   child: GestureDetector(
      //     behavior: HitTestBehavior.opaque,
      //     onTap: onTap,
      //     child: SizedBox(
      //       height: 80.0,
      //       child: Card(
      //         color: Colors.primaries[item % Colors.primaries.length],
      //         child: Center(
      //           child: Text('Item $item', style: textStyle),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
