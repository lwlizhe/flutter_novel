import 'package:flutter_novel/app/novel/entity/entity_novel_book_chapter.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/helper_reader_content.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';

class ReaderProgressManager {
  NovelReaderViewModel readerViewModel;

  ReaderProgressManager(this.readerViewModel);

  ReaderProgressStateEnum currentState = ReaderProgressStateEnum.STATE_NORMAL;

  ReaderProgressStateEnum getCurrentProgressState() {
    if (readerViewModel?.getCurrentPage() == null) {
      currentState = ReaderProgressStateEnum.STATE_LOADING;
    } else if (!readerViewModel.isCanGoNext()) {
      currentState = ReaderProgressStateEnum.STATE_NO_NEXT;
    } else if (!readerViewModel.isCanGoPre()) {
      currentState = ReaderProgressStateEnum.STATE_NO_PRE;
    } else {
      currentState = ReaderProgressStateEnum.STATE_NORMAL;
    }
    return currentState;
  }

  Future<bool> nextPage() async {
    if (currentState == ReaderProgressStateEnum.STATE_NO_NEXT) {
      return false;
    }

    ReaderContentDataValue currentDataValue =
        readerViewModel.getCurrentContentDataValue()!;
    if (currentDataValue.currentPageIndex! <
        currentDataValue.chapterContentConfigs.length - 1) {
      goToNextPage();
    } else {
      goToNextChapter(false);
    }

    return true;
  }

  Future<bool> prePage() async {
    if (currentState == ReaderProgressStateEnum.STATE_NO_PRE) {
      return false;
    }

    ReaderContentDataValue currentDataValue =
        readerViewModel.getCurrentContentDataValue()!;
    if (currentDataValue.currentPageIndex! > 0) {
      goToPrePage();
    } else {
      goToPreChapter(false);
    }

    return true;
  }

  Future<bool> goToTargetPage(int index) async {
    ReaderContentDataValue? currentDataValue =
        readerViewModel.getCurrentContentDataValue();

    if (index >= 0 &&
        index <= currentDataValue!.chapterContentConfigs.length - 1 &&
        index != currentDataValue.currentPageIndex) {
      if (index == currentDataValue.currentPageIndex! + 1) {
        goToNextPage();
      } else if (index == currentDataValue.currentPageIndex! - 1) {
        goToPrePage();
      } else {
        currentDataValue.currentPageIndex = index;
      }
      return true;
    }
    return false;
  }

  Future<bool> goToTargetChapter(int index) async {
    NovelBookChapter? chapter = readerViewModel.getCatalog();

    ReaderContentDataValue currentDataValue =
        readerViewModel.getCurrentContentDataValue()!;

    if (index == currentDataValue.chapterIndex! + 1) {
      goToNextChapter(true);
    } else if (index == currentDataValue.chapterIndex! - 1) {
      goToPreChapter(true);
    } else {
      currentDataValue.clear();
      currentDataValue.chapterIndex = index;

      ReaderContentDataValue preDataValue =
          readerViewModel.getPreContentDataValue()!;
      preDataValue.clear();

      ReaderContentDataValue nextDataValue =
          readerViewModel.getNextContentDataValue()!;
      nextDataValue.clear();

      preDataValue.chapterIndex = index - 1;

      if (index < chapter!.chapters!.length - 1) {
        nextDataValue.chapterIndex = index + 1;
      } else {
        nextDataValue.chapterIndex = -1;
      }
    }

    readerViewModel.getContentParseQueue()!.clear();
    readerViewModel.getMicroContentParseQueue()!.clear();

    checkChapterCache();
    checkPageCache();

    readerViewModel.notifyRefresh();

    return true;
  }

  void goToNextPage() async {
    readerViewModel.getCurrentContentDataValue()!.currentPageIndex++;

    if (!isHasNextPage() && !isHasNextChapter()) {
      /// 如果当前章没有下一张
      currentState = ReaderProgressStateEnum.STATE_NO_NEXT;
    } else {
      if (readerViewModel.getNextPage() == null) {
        currentState = ReaderProgressStateEnum.STATE_LOADING;
      } else {
        currentState = ReaderProgressStateEnum.STATE_NORMAL;
      }
    }

    checkPageCache();
  }

  Future<bool> goToNextChapter(bool resetIndex) async {
    if (!isHasNextChapter()) {
      return false;
    }

    ReaderContentDataValue? preDataValue =
        readerViewModel.getPreContentDataValue();
    ReaderContentDataValue? currentDataValue =
        readerViewModel.getCurrentContentDataValue();
    ReaderContentDataValue? nextDataValue =
        readerViewModel.getNextContentDataValue();

    readerViewModel.getContentParseQueue()!.removeWhere((dataValue) =>
        ((dataValue.novelId == preDataValue!.novelId) &&
            (dataValue.chapterIndex == preDataValue.chapterIndex)));

    preDataValue = currentDataValue;
    currentDataValue = nextDataValue;

    readerViewModel.setPreContentDataValue(preDataValue);
    readerViewModel.setCurrentContentDataValue(currentDataValue);

    nextDataValue = ReaderContentDataValue()
      ..novelId = currentDataValue!.novelId;

    if (isHasNextChapter()) {
      nextDataValue.chapterIndex = currentDataValue.chapterIndex! + 1;
    } else {
      nextDataValue..chapterIndex = -1;
    }
    nextDataValue.chapterCanvasDataMap.clear();

    readerViewModel.setNextContentDataValue(nextDataValue);

    if (resetIndex) {
      nextDataValue.currentPageIndex = 0;
      currentDataValue.currentPageIndex = 0;
      preDataValue!.currentPageIndex = 0;
    } else {
      nextDataValue.currentPageIndex = 0;
      currentDataValue.currentPageIndex = 0;
      preDataValue!.currentPageIndex =
          preDataValue.chapterContentConfigs.length - 1;
    }

    readerViewModel.getContentParseQueue()!.clear();
    readerViewModel.getMicroContentParseQueue()!.clear();

    checkChapterCache();
    checkPageCache();

    return true;
  }

  void goToPrePage() async {
    readerViewModel.getCurrentContentDataValue()!.currentPageIndex--;

    if (!isHasPrePage() && !isHasPreChapter()) {
      /// 如果当前章没有上一张
      currentState = ReaderProgressStateEnum.STATE_NO_PRE;
    } else {
      if (readerViewModel.getPrePage() == null) {
        currentState = ReaderProgressStateEnum.STATE_LOADING;
      } else {
        currentState = ReaderProgressStateEnum.STATE_NORMAL;
      }
    }

    checkPageCache();
  }

  Future<bool> goToPreChapter(bool resetIndex) async {
    if (!isHasPreChapter()) {
      return false;
    }

    ReaderContentDataValue? preDataValue =
        readerViewModel.getPreContentDataValue();
    ReaderContentDataValue? currentDataValue =
        readerViewModel.getCurrentContentDataValue();
    ReaderContentDataValue? nextDataValue =
        readerViewModel.getNextContentDataValue();

    readerViewModel.getContentParseQueue()!.removeWhere((dataValue) =>
        ((dataValue.novelId == nextDataValue!.novelId) &&
            (dataValue.chapterIndex == nextDataValue.chapterIndex)));

    nextDataValue = currentDataValue;
    currentDataValue = preDataValue;

    readerViewModel.setNextContentDataValue(nextDataValue);
    readerViewModel.setCurrentContentDataValue(currentDataValue);

    preDataValue = ReaderContentDataValue()..novelId = currentDataValue!.novelId;
    if (isHasPreChapter()) {
      preDataValue.chapterIndex = currentDataValue.chapterIndex! - 1;
    } else {
      preDataValue..chapterIndex = -1;
    }
    preDataValue.chapterCanvasDataMap.clear();

    print("设置前一章,当前章节:" +
        currentDataValue.chapterIndex.toString() +
        "， 设置目标前章节:" +
        preDataValue.chapterIndex.toString());
    readerViewModel.setPreContentDataValue(preDataValue);

    if (resetIndex) {
      nextDataValue!.currentPageIndex = 0;
      currentDataValue.currentPageIndex = 0;
      preDataValue.currentPageIndex = 0;
    } else {
      currentDataValue.currentPageIndex =
          currentDataValue.chapterContentConfigs.length - 1;
      nextDataValue!.currentPageIndex = 0;
      preDataValue.currentPageIndex = 0;
    }

    readerViewModel.getContentParseQueue()!.clear();
    readerViewModel.getMicroContentParseQueue()!.clear();

    checkChapterCache();
    checkPageCache();

    return true;
  }

  void checkChapterCache() {
    ReaderContentDataValue? preDataValue =
        readerViewModel.getPreContentDataValue();
    ReaderContentDataValue? nextDataValue =
        readerViewModel.getNextContentDataValue();

    NovelBookChapter? catalogData = readerViewModel.getCatalog();

    if (preDataValue != null && preDataValue.chapterIndex != -1) {
      if (preDataValue.contentState == ContentState.STATE_NORMAL) {
        if (preDataValue.chapterContentConfigs == null ||
            preDataValue.chapterContentConfigs.length == 0) {
          preDataValue.chapterCanvasDataMap.clear();

          readerViewModel.requestNewContent(
              catalogData!.chapters![preDataValue.chapterIndex!]
                ..novelId = catalogData.book);
        } else {
          readerViewModel.loadReaderContentDataValue(
              preDataValue.chapterContentConfigs, preDataValue, false, true);
        }
      }
    } else {
      preDataValue!.chapterContentConfigs.clear();
      preDataValue.chapterCanvasDataMap.clear();
    }
    if (nextDataValue != null && nextDataValue.chapterIndex != -1) {
      if (nextDataValue.contentState == ContentState.STATE_NORMAL) {
        if (nextDataValue.chapterContentConfigs == null ||
            nextDataValue.chapterContentConfigs.length == 0) {
          nextDataValue.chapterCanvasDataMap.clear();

          readerViewModel.requestNewContent(
              catalogData!.chapters![nextDataValue.chapterIndex!]
                ..novelId = catalogData.book);
        } else {
          readerViewModel.loadReaderContentDataValue(
              nextDataValue.chapterContentConfigs, nextDataValue, false, true);
        }
      }
    } else {
      nextDataValue!.chapterContentConfigs.clear();
      nextDataValue.chapterCanvasDataMap.clear();
    }
  }

  void checkPageCache() {
    ReaderContentDataValue? currentDataValue =
        readerViewModel.getCurrentContentDataValue();
    NovelBookChapter? catalogData = readerViewModel.getCatalog();

    if (currentDataValue != null && (currentDataValue.chapterIndex != -1)) {
      if (currentDataValue.chapterContentConfigs == null ||
          currentDataValue.chapterContentConfigs.length == 0) {
        currentDataValue.chapterCanvasDataMap.clear();

        readerViewModel.requestNewContent(
            catalogData!.chapters![currentDataValue.chapterIndex!]
              ..novelId = catalogData.book);
      } else if (currentDataValue.chapterCanvasDataMap.length !=
          currentDataValue.chapterContentConfigs.length) {
        readerViewModel.loadReaderContentDataValue(
            currentDataValue.chapterContentConfigs,
            currentDataValue,
            true,
            false);
      }
    }
  }

  /// page 页数不足，或者是page最后一页，但不是最后一个chapter，或者是page最后一页，也是最后一个chapter，但不是最后一个volume
  bool isCanGoNext() {
    ReaderContentDataValue currentDataValue =
        readerViewModel.getCurrentContentDataValue()!;

    return (currentDataValue.currentPageIndex! + 1 <
            currentDataValue.chapterContentConfigs.length) ||
        (isHasNextChapter() &&
            readerViewModel.getNextPage()!.pagePicture != null);
  }

  bool isHasNextPage() {
    ReaderContentDataValue currentDataValue =
        readerViewModel.getCurrentContentDataValue()!;

    return (currentDataValue.currentPageIndex! + 1 <
        currentDataValue.chapterContentConfigs.length);
  }

  bool isHasNextChapter() {
    ReaderContentDataValue currentDataValue =
        readerViewModel.getCurrentContentDataValue()!;

    return currentDataValue.chapterIndex! + 1 <
        readerViewModel.getCatalog()!.chapters!.length;
  }

  bool isCanGoPre() {
    return (readerViewModel.getCurrentContentDataValue()!.currentPageIndex! >
            0) ||
        (isHasPreChapter() && readerViewModel.getPrePage()!.pagePicture != null);
  }

  bool isHasPrePage() {
    return readerViewModel.getCurrentContentDataValue()!.currentPageIndex! > 0;
  }

  bool isHasPreChapter() {
    return readerViewModel.getCurrentContentDataValue()!.chapterIndex! > 0;
  }
}

enum ReaderProgressStateEnum {
  STATE_NORMAL,
  STATE_LOADING,
  STATE_NO_PRE,
  STATE_NO_NEXT
}

enum ReaderOperateEnum {
  OPERATE_NEXT_PAGE,
  OPERATE_PRE_PAGE,
  OPERATE_PRE_CHAPTER,
  OPERATE_NEXT_CHAPTER,
  OPERATE_JUMP_PAGE,
  OPERATE_JUMP_CHAPTER,
}
