import 'package:flutter/material.dart';
import 'package:flutter_novel/base/widget/base_list_item_holder.dart';

typedef void OnItemTaped<T>(BuildContext context,T data, int index,int currentItemType);

abstract class BaseListItemHolderBuilder<T> {
  List<T> currentListData;

  BaseListItemHolderBuilder();

  Widget build(BuildContext context, int index, List<T> listData,
      {OnItemTaped<T> itemTapCallback}) {
    BaseItemHolder<T> result;

    currentListData = listData;

    result = getItemHolder(context, index, getItemType(listData[index], index));

    return GestureDetector(
        child: result,
        onTap: () {
          if (itemTapCallback != null) {
              itemTapCallback(
                  context,listData[index], index, getItemType(listData[index], index));
          }
        });
  }

  BaseItemHolder<T> getItemHolder(
      BuildContext context, int index, int itemType);

  int getItemType(T data, int index) {
    return 0;
  }
}
