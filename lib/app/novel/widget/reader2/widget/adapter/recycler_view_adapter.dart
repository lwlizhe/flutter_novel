import 'package:flutter/widgets.dart';
import 'package:flutter_novel/app/novel/widget/reader2/widget/holder/recycler_view_holder.dart';

abstract class Adapter<VH extends ViewHolder> {

  int getItemType();

  int getItemCount();

  VH onCreateViewHolder(Widget parent, int viewType);
}
