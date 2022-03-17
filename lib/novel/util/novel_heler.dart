import 'package:flutter/material.dart';
import 'package:flutter_novel/novel/viewmodel/novel_content_view_model.dart';
import 'package:flutter_novel/reader/layout/novel_layout_manager.dart';
import 'package:flutter_novel/reader/layout/simulation/controller/power_list_scroll_simulation_controller.dart';
import 'package:flutter_novel/reader/layout/simulation/power_list_simulation_layout_manager.dart';
import 'package:flutter_novel/widget/scroll/controller/power_list_scroll_controller.dart';
import 'package:flutter_novel/widget/scroll/layout/manager/layout_manager.dart';

ScrollController? buildNovelScrollController(ReaderTurnPageMode turnPageMode) {
  switch (turnPageMode) {
    case ReaderTurnPageMode.coverMode:
      return PowerListPageScrollController();
    case ReaderTurnPageMode.simulationMode:
      return PowerListScrollSimulationController();
    case ReaderTurnPageMode.normalMode:
    default:
      return PowerListPageScrollController();
  }
}

LayoutManager? buildNovelLayoutManager(ReaderTurnPageMode turnPageMode) {
  switch (turnPageMode) {
    case ReaderTurnPageMode.coverMode:
      return PowerListCoverLayoutManager();
    case ReaderTurnPageMode.simulationMode:
      return PowerListSimulationTurnLayoutManager();
    case ReaderTurnPageMode.normalMode:
    default:
      return PowerListLinearLayoutManager();
  }
}
