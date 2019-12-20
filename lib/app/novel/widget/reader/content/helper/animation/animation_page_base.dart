import 'package:flutter/material.dart';
import 'package:flutter_novel/app/novel/widget/reader/content/helper/manager_reader_page.dart';
import 'package:flutter_novel/app/novel/view_model/view_model_novel_reader.dart';
import 'package:flutter_novel/base/util/utils_screen.dart';

abstract class BaseAnimationPage{

  Offset mTouch=Offset(0,0);

  AnimationController mAnimationController;

  Size currentSize=Size(ScreenUtils.getScreenWidth(),ScreenUtils.getScreenHeight());

//  @protected
//  ReaderContentViewModel contentModel=ReaderContentViewModel.instance;

  NovelReaderViewModel readerViewModel;

//  void setData(ReaderChapterPageContentConfig prePageConfig,ReaderChapterPageContentConfig currentPageConfig,ReaderChapterPageContentConfig nextPageConfig){
//    currentPageContentConfig=pageConfig;
//  }

  void setSize(Size size){
    currentSize=size;
//    mTouch=Offset(currentSize.width, currentSize.height);
  }
  void setContentViewModel(NovelReaderViewModel viewModel){
    readerViewModel=viewModel;
//    mTouch=Offset(currentSize.width, currentSize.height);
  }

  void onDraw(Canvas canvas);
  void onTouchEvent(TouchEvent event);
  void setAnimationController(AnimationController controller){
    mAnimationController=controller;
  }

  bool isShouldAnimatingInterrupt(){
   return false;
  }

  bool isCanGoNext(){
    return readerViewModel.isCanGoNext();
  }
  bool isCanGoPre(){
    return readerViewModel.isCanGoPre();
  }

  bool isCancelArea();
  bool isConfirmArea();

  Animation<Offset> getCancelAnimation(AnimationController controller,GlobalKey canvasKey);
  Animation<Offset> getConfirmAnimation(AnimationController controller,GlobalKey canvasKey);
  Simulation getFlingAnimationSimulation(AnimationController controller,DragEndDetails details);

}

enum ANIMATION_TYPE { TYPE_CONFIRM, TYPE_CANCEL,TYPE_FILING }
