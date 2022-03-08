# 阅读器模块

记录一下现在LayoutManager的配置要求：

1. 覆盖翻页，```PowerListCoverLayoutManager``` : 需要开启ListView的 ```addRepaintBoundaries```  , controller 用的是 ```PowerListPageScrollController``` 的话，就启用SliverFill，item默认填满ViewPort
2. 仿真翻页，```PowerListSimulationTurnLayoutManager``` : ```addRepaintBoundaries``` 要设置为false；同时搭配 ```PowerListScrollSimulationController```