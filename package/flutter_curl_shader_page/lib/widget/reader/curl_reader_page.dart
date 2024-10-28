import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import '../../const.dart';
import '../scrollable/custom_carousel.dart';
import '../scrollable/custom_carousel_scroll_controller.dart';
import 'util/curl_effects_utils.dart';

enum CurlShaderMode {
  normal,
  cover,
  simulation,
  vertical,
}

class CurlShaderReaderPage extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;

  const CurlShaderReaderPage({super.key, required this.itemBuilder});

  @override
  State<CurlShaderReaderPage> createState() => _CurlShaderReaderPageState();
}

class _CurlShaderReaderPageState extends State<CurlShaderReaderPage>
    with SingleTickerProviderStateMixin {
  late CustomCarouselScrollController _controller;

  int _selectedIndex = 0;

  CurlShaderMode currentMode = CurlShaderMode.simulation;

  ScrollStartNotification? startNotification;
  ScrollUpdateNotification? updateNotification;

  Tween<Offset>? offsetTween;

  @override
  void initState() {
    _controller = CustomCarouselScrollController(initialItem: 100000000);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification) {
              startNotification = notification;
            }

            if (notification is ScrollUpdateNotification) {
              updateNotification = notification;
            }

            if (notification is ScrollEndNotification) {
              startNotification = null;
              updateNotification = null;
            }

            return false;
          },
          child: ShaderBuilder(
            (context, shader, _) {
              return CustomCarousel(
                physics: CurlEffectsUtils.buildPhysicsForMode(currentMode),
                itemCountBefore: CurlEffectsUtils.effectCount,
                itemCountAfter: CurlEffectsUtils.effectCount,
                alignment: Alignment.center,
                scrollDirection: CurlEffectsUtils.buildAxisForMode(currentMode),
                scrollSpeed: 0.5,
                tapToSelect: false,
                loop: false,
                controller: _controller,
                onSelectedItemChanged: (i) =>
                    setState(() => _selectedIndex = i),
                effectsBuilder: (int index, double scrollRatio,
                    BoxConstraints constraints, Widget child) {
                  return CurlEffectsUtils.buildEffectForMode(
                      child,
                      constraints,
                      scrollRatio,
                      shader,
                      currentMode,
                      startNotification,
                      updateNotification);
                },
                itemCount: 200000000,
                itemBuilder: (BuildContext context, int index) {
                  return widget.itemBuilder.call(context,index);
                },
              );
            },
            assetKey: curlShaderAssetKey,
          ),
        ),
      ),
    );
  }
}


