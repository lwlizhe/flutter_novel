import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class NovelBookFindView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _FindMenuItem(MenuItemType.TYPE_LEADER_BOARD),
          _FindMenuItem(MenuItemType.OTHER),
        ],
      ),
    );
  }
}

class _FindMenuItem extends StatelessWidget {
  final MenuItemType itemType;

  _FindMenuItem(this.itemType);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Builder(builder: (context) {
              switch (itemType) {
                case MenuItemType.TYPE_LEADER_BOARD:
                  return Icon(
                    Feather.bar_chart_2,
                    size: 18,
                  );
                case MenuItemType.OTHER:
                default:
                return Icon(
                  Feather.check_square,
                  size: 18,
                );              }
            }),
          ),
          Expanded(child: Builder(builder: (context) {
            switch (itemType) {
              case MenuItemType.TYPE_LEADER_BOARD:
                return Text("排行榜",style: TextStyle(fontSize: 16),);
              case MenuItemType.OTHER:
              default:
                return Text("还没想好放啥",style: TextStyle(fontSize: 16),);
            }
          })),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}

enum MenuItemType { TYPE_LEADER_BOARD, OTHER }
