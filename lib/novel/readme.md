# 阅读器模块

记录一下现在LayoutManager的配置要求：

1. 覆盖翻页，```PowerListCoverLayoutManager``` 需要开启ListView的 ```addRepaintBoundaries```
2. 仿真翻页，```addRepaintBoundaries``` 要设置为false；同时搭配 ```PowerListScrollSimulationController```