import 'dart:collection';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/helper_reader_content.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';
import 'package:flutter_novel/app/novel/widget/reader/model/model_reader_config.dart';
import 'dart:ui' as ui;
import 'package:flutter_novel/base/util/utils_screen.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'dart:math' as math;

class NovelReaderContentModel {
  NovelReaderViewModel viewModel;

  NovelReaderContentModel(this.viewModel);

  ReaderContentDataValue dataValue;
  ReaderContentDataValue preDataValue;
  ReaderContentDataValue nextDataValue;

  ListQueue<ReaderContentDataValue> microContentParseQueue = ListQueue();
  ListQueue<ReaderContentDataValue> contentParseQueue = ListQueue();

  var _isolate;

  bool isStartLooper = false;

  void startParseLooper() async {
    if (isStartLooper) {
      return;
    }

    while (true) {
      /// 如果卡的话，调整这个参数即可，越大越不卡，不过加载速度会下降
      await Future.delayed(Duration(milliseconds: 50));

      isStartLooper = true;

      if (viewModel == null || viewModel.isDisposed) {
        break;
      }

      if (microContentParseQueue.isNotEmpty) {
        print("微队列容量:" + microContentParseQueue.length.toString());
        await _parseCacheContent(microContentParseQueue.first);

        if (microContentParseQueue.isNotEmpty) {
          microContentParseQueue.removeFirst();
        }
      }

      if (contentParseQueue.isNotEmpty) {
        print("队列容量:" + contentParseQueue.length.toString());

        await _parseCacheContent(contentParseQueue.first);

        if (contentParseQueue.isNotEmpty) {
          contentParseQueue.removeFirst();
        }
      }
    }
  }

  _parseCacheContent(ReaderContentDataValue targetData) async {
    if (targetData.chapterContentConfigs != null &&
        targetData.chapterContentConfigs.length - 1 >=
            targetData.currentPageIndex) {
      ui.Picture picture = drawContent(
          targetData.chapterContentConfigs[targetData.currentPageIndex]);
      ui.Image image = await picture.toImage(
          ScreenUtils.getScreenWidth().toInt(),
          ScreenUtils.getScreenHeight().toInt());
      ReaderContentCanvasDataValue canvasDataValue =
          ReaderContentCanvasDataValue()
            ..pageIndex = targetData.currentPageIndex
            ..pagePicture = picture
            ..pageImage = image;

      if (targetData.isSameChapter(dataValue)) {
        dataValue.chapterCanvasDataMap[targetData.currentPageIndex] =
            canvasDataValue;

        /// 如果正好是当前加载页，那么通知显示
        if (dataValue.currentPageIndex == targetData.currentPageIndex) {
          viewModel.notifyRefresh();
        }
      } else if (targetData.isSameChapter(nextDataValue)) {
        nextDataValue.chapterCanvasDataMap[targetData.currentPageIndex] =
            canvasDataValue;
      } else if (targetData.isSameChapter(preDataValue)) {
        preDataValue.chapterCanvasDataMap[targetData.currentPageIndex] =
            canvasDataValue;
      }
    }
  }

  void parseChapterContent(ReaderParseContentDataValue contentData) async {
    if (contentData.content == null || contentData.content.length == 0) {
      return;
    }

    ReaderContentDataValue contentDataValue = ReaderContentDataValue();
    contentDataValue.chapterIndex = contentData.chapterIndex;
    contentDataValue.novelId = contentData.novelId;

    ReceivePort receivePort = ReceivePort();
    //创建并生成与当前Isolate共享相同代码的Isolate
    _isolate = await FlutterIsolate.spawn(dataLoader, receivePort.sendPort);
    // 流的第一个元素
    SendPort sendPort = await receivePort.first;
    // 流的第一个元素被收到后监听会关闭，所以需要新打开一个ReceivePort以接收传入的消息
    ReceivePort response = ReceivePort();
    ReaderConfigEntity configEntity = viewModel.getConfigData();
    //通过此发送端口向其对应的“ReceivePort”①发送异步[消息]，这个“消息”指的是发送的参数②。
    sendPort.send([
      response.sendPort,
      contentData.chapterIndex,
      contentData.novelId,
      contentData.content,
      configEntity.pageSize.dy -
          (2 * configEntity.contentPadding) -
          configEntity.bottomTipHeight -
          configEntity.titleHeight,
      configEntity.pageSize.dx - (2 * configEntity.contentPadding),
      configEntity.fontSize,
      configEntity.lineHeight,
      configEntity.paragraphSpacing
    ]);

    await for (var msg in response) {
      // 获取端口发送来的数据③
      String jsonResult = msg[0];
      int chapterIndex = msg[1];
      String content = msg[3];

      if (viewModel == null) {
        return;
      }

      _isolate?.kill();
      _isolate = null;
      var result = jsonDecode(jsonResult);
      List<ReaderChapterPageContentConfig> contentConfigs = List();
      for (Map map in result) {
        contentConfigs.add(ReaderChapterPageContentConfig.fromMap(map));
      }

      if (dataValue.chapterIndex == chapterIndex) {
        dataValue.chapterContentConfigs.clear();
        dataValue.chapterContentConfigs.addAll(contentConfigs);
        dataValue.contentData = content;
        loadReaderContentDataValue(contentConfigs, dataValue, true, false);
        viewModel.checkChapterCache();
      } else if (preDataValue.chapterIndex == chapterIndex) {
        preDataValue.chapterContentConfigs.clear();
        preDataValue.chapterContentConfigs.addAll(contentConfigs);
        preDataValue.currentPageIndex =
            preDataValue.chapterContentConfigs.length - 1;
        preDataValue.contentData = content;
        loadReaderContentDataValue(contentConfigs, preDataValue, false, true);
      } else if (nextDataValue.chapterIndex == chapterIndex) {
        nextDataValue.chapterContentConfigs.clear();
        nextDataValue.chapterContentConfigs.addAll(contentConfigs);
        nextDataValue.contentData = content;
        loadReaderContentDataValue(contentConfigs, nextDataValue, false, false);
      }
    }
  }

  void loadReaderContentDataValue(List<ReaderChapterPageContentConfig> configs,
      ReaderContentDataValue targetData, bool isCurrent, bool isPre) async {
    ///  加个延迟让更多cpu去做页面绘制？（目前单章给个100毫秒的延迟效果比较好）
    ///  如果同时加载前一章、后一章、当前章是不是就会很卡呢……
    ///  更新：全部放到队列中去做，Flutter的这个单线程模型真是有点怕了，一言不合就jank
    ///
    for (int index = (isPre ? targetData.chapterContentConfigs.length - 1 : 0);
        isPre
            ? (index >
                math.max(targetData.chapterContentConfigs.length - 1 - 10, -1))
            : (index <
                (isCurrent ? targetData.chapterContentConfigs.length : 10));
        isPre ? index-- : index++) {
      if (viewModel == null) {
        break;
      }

      ReaderContentDataValue parseDataValue = ReaderContentDataValue()
        ..currentPageIndex = index
        ..chapterContentConfigs = targetData.chapterContentConfigs
        ..chapterIndex = targetData.chapterIndex
        ..novelId = targetData.novelId;
      await Future.delayed(Duration.zero);

      if (isPre && index > targetData.chapterContentConfigs.length - 1 - 3) {
        if (!microContentParseQueue.contains(parseDataValue) &&
            !contentParseQueue.contains(parseDataValue) &&
            targetData.chapterCanvasDataMap[parseDataValue.currentPageIndex] ==
                null) {
          microContentParseQueue.add(parseDataValue);
        }
      } else if (isCurrent &&
          (index > targetData.currentPageIndex - 5 &&
              index < targetData.currentPageIndex + 5)) {
        if (!microContentParseQueue.contains(parseDataValue) &&
            !contentParseQueue.contains(parseDataValue) &&
            targetData.chapterCanvasDataMap[parseDataValue.currentPageIndex] ==
                null) {
          microContentParseQueue.add(parseDataValue);
        }
      } else {
        if (!microContentParseQueue.contains(parseDataValue) &&
            !contentParseQueue.contains(parseDataValue) &&
            targetData.chapterCanvasDataMap[parseDataValue.currentPageIndex] ==
                null) {
          contentParseQueue.add(parseDataValue);
        }
      }
    }

    if (viewModel != null && isCurrent) {
      viewModel.notifyRefresh();
    }
  }

  static void dataLoader(SendPort sendPort) async {
    // 打开ReceivePort①以接收传入的消息
    ReceivePort port = ReceivePort();

    // 通知其他的isolates，本isolate 所监听的端口
    sendPort.send(port.sendPort);
    // 获取其他端口发送的异步消息 msg② -> ["https://jsonplaceholder.typicode.com/posts", response.sendPort]
    await for (var msg in port) {
      SendPort replyToPort = msg[0];
      int chapterIndex = msg[1];
      String novelId = msg[2];
      String content = msg[3];
      double height = msg[4];
      double width = msg[5];
      int fontSize = msg[6];
      int lineHeight = msg[7];
      int paragraphSpacing = msg[8];

      List<ReaderChapterPageContentConfig> contentConfigs =
          ReaderContentProvider.getChapterPageContentConfigList(0, content,
              height, width, fontSize, lineHeight, paragraphSpacing);

      /// The content of message can be: primitive values (null, num, bool, double, String), instances of SendPort, and lists and maps whose elements are any of these. List and maps are also allowed to be cyclic.
      /// In the special circumstances when two isolates share the same code and are running in the same process (e.g. isolates created via Isolate.spawn), it is also possible to send object instances (which would be copied in the process). This is currently only supported by the dartvm. For now, the dart2js compiler only supports the restricted messages described above.
      /// 所以只能构造一个jsonList返回去……

      String result = jsonEncode(contentConfigs);

      replyToPort.send([result, chapterIndex, novelId, content]);
    }
  }

  ui.Picture drawContent(ReaderChapterPageContentConfig pageContentConfig) {
    ui.PictureRecorder pageRecorder = new ui.PictureRecorder();
    Canvas pageCanvas = new Canvas(pageRecorder);

    ReaderConfigEntity configEntity = viewModel.getConfigData();

    pageCanvas.drawRect(
        Offset.zero &
            Size(ScreenUtils.getScreenWidth(), ScreenUtils.getScreenHeight()),
        viewModel.bgPaint);

//    /// 好像这玩意要结合具体动画类型来做……标题和底部由具体动画实现Helper来做吧……但是这样好像缓存就没用了，随时都会切换动画效果
//    viewModel.textPainter.text = TextSpan(
//        text: "顶部标题",
//        style: TextStyle(
//            color: Colors.black,
//            height: configEntity.titleHeight.toDouble()/pageContentConfig.currentContentFontSize,
//            fontSize: pageContentConfig.currentContentFontSize.toDouble()));
//    viewModel.textPainter.layout(maxWidth: configEntity.pageSize.dx-(2*configEntity.contentPadding));
//    viewModel.textPainter.paint(pageCanvas, Offset(configEntity.contentPadding.toDouble(), configEntity.contentPadding.toDouble()));

    Offset offset = Offset(
        configEntity.contentPadding.toDouble(),
        configEntity.contentPadding.toDouble() +
            configEntity.titleHeight.toDouble());

    List<String> paragraphContents = pageContentConfig.paragraphContents;
    for (String content in paragraphContents) {
      viewModel.textPainter.text = TextSpan(
          text: content,
          style: TextStyle(
              color: Colors.black,
              height: pageContentConfig.currentContentLineHeight /
                  pageContentConfig.currentContentFontSize,
              fontSize: pageContentConfig.currentContentFontSize.toDouble()));
      viewModel.textPainter.layout(maxWidth: configEntity.pageSize.dx-(2*configEntity.contentPadding));
      viewModel.textPainter.paint(pageCanvas, offset);

      offset = Offset(
          configEntity.contentPadding.toDouble(),
          offset.dy +
              viewModel.textPainter.computeLineMetrics().length *
                  pageContentConfig.currentContentLineHeight);

      offset = Offset(configEntity.contentPadding.toDouble(),
          offset.dy + pageContentConfig.currentContentParagraphSpacing);
    }

//    viewModel.textPainter.text = TextSpan(
//        text: "底部页数什么的",
//        style: TextStyle(
//            color: Colors.black,
//            height: configEntity.bottomTipHeight.toDouble()/pageContentConfig.currentContentFontSize,
//            fontSize: pageContentConfig.currentContentFontSize.toDouble()));
//    viewModel.textPainter.layout(maxWidth: configEntity.pageSize.dx-(2*configEntity.contentPadding));
//    viewModel.textPainter.paint(pageCanvas, offset);

    return pageRecorder.endRecording();
  }

  void clear() {
    viewModel = null;
    isStartLooper = false;
    dataValue = null;
    preDataValue = null;
    nextDataValue = null;
    contentParseQueue.clear();
    contentParseQueue = null;
    microContentParseQueue.clear();
    microContentParseQueue = null;

    _isolate?.kill();
    _isolate = null;
  }
}
