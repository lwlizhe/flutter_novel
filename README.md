## 前言

如果想自己编译，建议flutter环境使用最新的stable分支（我目前使用的是stable分支的1.12.13+hotfix.5），由于项目中使用了较新的技术点，所以如果是老版本的环境应该会因为找不到类或者方法而报错。

另外……ios因为没设备，所以也不知道具体是否正常，讲道理应该没啥问题的。plugin，代码这块也是基本的flutter代码，应该没什么特殊的…………

本人也是在不断摸索学习flutter中，所以这个项目中存在的错误或者低性能部分，还请不吝提issue或者pr。

总之，欢迎pr、fork、star，或者在issue区中提出有意义的意见或者建议。

顺便提一下：

<span style="color:orange;">**多图流量警告！**</span>

## 效果图

**书库**

![书库-无书](https://s2.ax1x.com/2019/12/27/lEzN6K.gif)
![书库-有书](https://s2.ax1x.com/2019/12/27/lEzw0e.gif)

**搜索页**

![搜索页](https://s2.ax1x.com/2019/12/27/lEzrtA.gif)

**详情页**

![详情页](https://s2.ax1x.com/2019/12/27/lVSIbD.gif)

**阅读页**

![设置-仿真翻页](https://s2.ax1x.com/2019/12/27/lEzmlV.gif)
![章节内页面跳转](https://s2.ax1x.com/2019/12/27/lEzg6f.gif)
![上一章和下一章](https://s2.ax1x.com/2019/12/27/lEzIts.gif)
![目录页](https://s2.ax1x.com/2019/12/27/lVppVg.gif)
![设置-字体大小](https://s2.ax1x.com/2019/12/27/lEz8YR.gif)
![设置-行高](https://s2.ax1x.com/2019/12/27/lEzlTJ.gif)
![设置-覆盖翻页](https://s2.ax1x.com/2019/12/27/lEzuOU.gif)
![设置-滚动翻页](https://s2.ax1x.com/2019/12/27/lEzMmF.gif)
![设置-背景](https://s2.ax1x.com/2019/12/27/lVSO2t.gif)


## 核心技术点（非UI）简单概括

整体架构：
1. 基于provider的实现的mvvm思想的模板框架

书库页：
1. 数据库sqflite使用

搜索页
1. rxdart的一种小小应用

详情介绍页
1. 可以折叠展开的text
2. 主题色随图片

阅读页(核心)

1. Flutter中textPainter的使用，包含绘制、测量等.
2. canvas的使用.
3. 三种翻页动画（左右仿真翻页、上下滑动翻页、覆盖翻页）的实现.
4. 离线缓存
5. sharedPreference、屏幕亮度等用户设置内容。
6. stream的一种小小应用
7. dart中协程以及flutter的isolate的一些使用方法
8. 一种超低耦合的listView按index跳转的方式(目录页)

## 里程碑(暂定)

未实现的部分：

1. 排行榜
2. 书评
3. 下载
4. 本地书籍导入、wifi传书等其他导入书籍方式
5. 非txt格式的数据支持
6. 网页抓包处理解析(用于解析网页而非接口获取的书籍信息)
7. 音量键翻页
8. 语言读书，自动翻页

## 特别感谢

[flutter_app](https://github.com/shichunlei/flutter_app)(追书神器的接口以及介绍页来自于这个项目)

[BookPage](https://github.com/AnliaLee/BookPage)(阅读页的实现思路参考自这个项目)

## 免责声明

本项目仅用于研究学习,请勿用于商业,否则后果与本人无关。

