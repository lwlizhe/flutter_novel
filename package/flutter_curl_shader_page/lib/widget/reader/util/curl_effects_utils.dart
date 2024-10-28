import 'package:flutter/material.dart';
import 'package:flutter_curl_shader_page/util/page_curl_config_utils.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'dart:developer' as developer;

import '../curl_reader_page.dart';

class CurlEffectsUtils {
  static int effectCount = 2;

  static Widget buildEffectForMode(
      Widget itemChild,
      BoxConstraints constraints,
      double scrollRatio,
      FragmentShader shader,
      CurlShaderMode mode,
      ScrollStartNotification? startNotification,
      ScrollUpdateNotification? updateNotification) {
    if (mode != CurlShaderMode.vertical) {
      return _buildEffectPageTypeMode(itemChild, constraints, scrollRatio,
          shader, mode, startNotification, updateNotification);
    } else {
      return _buildEffectVerticalMode(itemChild, constraints, scrollRatio);
    }
  }

  static ScrollPhysics buildPhysicsForMode(CurlShaderMode mode) {
    if (mode != CurlShaderMode.vertical) {
      return const PageScrollPhysics();
    } else {
      return const AlwaysScrollableScrollPhysics();
    }
  }

  static Axis buildAxisForMode(CurlShaderMode mode) {
    if (mode != CurlShaderMode.vertical) {
      return Axis.horizontal;
    } else {
      return Axis.vertical;
    }
  }

  /// 垂直滑动
  static Widget _buildEffectVerticalMode(
    Widget itemChild,
    BoxConstraints constraints,
    double scrollRatio,
  ) {
    double height = constraints.maxHeight;
    double scrollIndex = scrollRatio / (1.0 / 5.0) / 2;
    double scrollOffset = scrollIndex * height;
    return Transform(
      transform: Matrix4.identity()..translate(0.0, scrollOffset),
      alignment: Alignment.center,
      child: itemChild,
    );
  }

  static Widget _buildEffectPageTypeMode(
    Widget itemChild,
    BoxConstraints constraints,
    double scrollRatio,
    FragmentShader shader,
    CurlShaderMode mode,
    ScrollStartNotification? startNotification,
    ScrollUpdateNotification? updateNotification,
  ) {
    double width = constraints.maxWidth;
    double scrollIndex = scrollRatio / (1.0 / (effectCount * 2 + 1)) / 2;
    double scrollOffset = scrollIndex * width;

    switch (mode) {
      case CurlShaderMode.cover:
        return _buildEffectCoverMode(
            itemChild, width, scrollIndex, scrollOffset);
      case CurlShaderMode.simulation:
        return _buildEffectSimulationMode(shader, itemChild, constraints,
            scrollIndex, scrollOffset, startNotification, updateNotification);
      default:
        return _buildEffectNormalMode(itemChild, scrollOffset);
    }
  }

  /// 普通PageView模式
  static Widget _buildEffectNormalMode(Widget itemChild, double scrollOffset) {
    return Transform(
      transform: Matrix4.identity()..translate(scrollOffset, 0.0),
      alignment: Alignment.center,
      child: itemChild,
    );
  }

  /// 普通Cover模式
  static Widget _buildEffectCoverMode(
      Widget itemChild, double width, double scrollIndex, double scrollOffset) {
    if (scrollIndex < 0) {
      if (scrollIndex > -1) {
        return Transform(
          transform: Matrix4.identity()..translate(scrollOffset, 0.0),
          alignment: Alignment.center,
          child: itemChild,
        );
      } else {
        return Transform(
          transform: Matrix4.identity()..translate(-width, 0.0),
          alignment: Alignment.center,
          child: itemChild,
        );
      }
    } else {
      return Transform(
        transform: Matrix4.identity(),
        alignment: Alignment.center,
        child: itemChild,
      );
    }
  }

  static ScrollUpdateNotification? _lastScrollNotification;

  /// 仿真翻页模式
  static Widget _buildEffectSimulationMode(
    FragmentShader shader,
    Widget itemChild,
    BoxConstraints constraints,
    double scrollIndex,
    double scrollOffset,
    ScrollStartNotification? startNotification,
    ScrollUpdateNotification? updateNotification,
  ) {
    double width = constraints.maxWidth;
    Offset updatePosition =
        (updateNotification?.dragDetails?.localPosition ?? Offset.zero);
    if (scrollIndex < 0) {
      if (scrollIndex > -1) {
        Tween<Offset>? animationOffsetTween;
        if (updateNotification != null) {
          if (updateNotification.dragDetails == null) {
            bool isGoNext = (updateNotification.scrollDelta ?? 0) > 0;
            animationOffsetTween = Tween(
                begin: _lastScrollNotification?.dragDetails?.localPosition ??
                    Offset.zero,
                end: Offset(
                    isGoNext ? -constraints.maxWidth : constraints.maxWidth,
                    (startNotification?.dragDetails?.localPosition ??
                                    Offset.zero)
                                .dy >
                            constraints.maxHeight / 2
                        ? constraints.maxHeight
                        : 0));
            final lastPixel = updateNotification.metrics.pixels -
                (_lastScrollNotification?.metrics.pixels ?? 0);
            final totalPixel = ((((updateNotification.metrics.pixels ~/
                                updateNotification.metrics.viewportDimension) +
                            (isGoNext ? 1 : 0)) *
                        updateNotification.metrics.viewportDimension) -
                    (_lastScrollNotification?.metrics.pixels ?? 0));
            final percent = lastPixel / totalPixel;

            final animationScrollOffset =
                animationOffsetTween.transform(percent);
            updatePosition = animationScrollOffset;
          } else {
            _lastScrollNotification = updateNotification;
          }
        } else {
          _lastScrollNotification = null;
        }

        return AnimatedSampler(
          (image, size, canvas) {
            final downPosition =
                (startNotification?.dragDetails?.localPosition ?? Offset.zero);
            shader
              ..setFloat(0, size.width) // resolution
              ..setFloat(1, size.height) // resolution
              ..setFloat(2, updatePosition.dx) // mouse
              ..setFloat(3, updatePosition.dy) // mouse
              ..setFloat(4, downPosition.dx) // mouse
              ..setFloat(5, downPosition.dy) // mousernerRadius
              ..setImageSampler(0, image); // image
            PageCurlConfigUtils.drawShaderRect(shader, size, canvas);
          },
          child: itemChild,
        );
      } else {
        return Transform(
          transform: Matrix4.identity()..translate(-width, 0.0),
          alignment: Alignment.center,
          child: itemChild,
        );
      }
    } else {
      return Transform(
        transform: Matrix4.identity(),
        alignment: Alignment.center,
        child: itemChild,
      );
    }
  }
}
