import 'package:flutter/material.dart';
import 'package:flutter_book_reader/reader/scroll/widget/reader_view.dart';
import 'package:flutter_curl_shader_page/flutter_page_curl.dart';

class NovelReader extends StatefulWidget {
  const NovelReader({super.key});

  @override
  State<NovelReader> createState() => _NovelReaderState();
}

class _NovelReaderState extends State<NovelReader> {
  var controller = PageController();

  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onPanUpdate: (details) {
    //     setState(() {
    //       _offset = details.localPosition;
    //     });
    //   },
    //   onPanEnd: (details) {
    //     setState(() {
    //       _offset = Offset.zero;
    //     });
    //   },
    //   onPanCancel: () {
    //     setState(() {
    //       _offset = Offset.zero;
    //     });
    //   },
    //   child: ShaderBuilder(
    //     (context, shader, _) {
    //       return Stack(
    //         children: [
    //           Container(
    //             color: Colors.blue,
    //             width: double.infinity,
    //             height: double.infinity,
    //             child: Text('第1页'),
    //           ),
    //           AnimatedSampler(
    //             (image, size, canvas) {
    //               shader
    //                 ..setFloat(0, size.width) // resolution
    //                 ..setFloat(1, size.height) // resolution
    //                 ..setFloat(2, _offset.dx) // mouse
    //                 ..setFloat(3, _offset.dy) // mouse
    //                 ..setFloat(4, size.width) // mouse
    //                 ..setFloat(5, size.height) // mousernerRadius
    //                 ..setImageSampler(0, image); // image
    //
    //               PageCurlConfigUtils.drawShaderRect(shader, size, canvas);
    //             },
    //             child: Container(
    //               color: Colors.red,
    //               width: double.infinity,
    //               height: double.infinity,
    //               child: Text(
    //                   '第0页第0页第0页第0页第0页第0页第0页第0页\n第0页第0页第0页第0页第0页第0页第0页第0页\n第0页第0页第0页第0页第0页第0页第0页第0页\n第0页第0页第0页第0页第0页第0页第0页第0页\n第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页\n第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页\n第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页\n第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页第0页\n',style: TextStyle(fontSize: 23),),
    //             ),
    //           )
    //         ],
    //       );
    //       return ReaderView.builder(
    //         controller: controller,
    //         itemBuilder: (context, index) {
    //           if (index == 0) {
    //             return AnimatedSampler(
    //               (image, size, canvas) {
    //                 shader
    //                   ..setFloat(0, size.width) // resolution
    //                   ..setFloat(1, size.height) // resolution
    //                   ..setFloat(2, _offset.dx) // mouse
    //                   ..setFloat(3, _offset.dy) // mouse
    //                   ..setFloat(4, size.width) // mouse
    //                   ..setFloat(5, 0) // mousernerRadius
    //                   ..setImageSampler(0, image); // image
    //
    //                 PageCurlConfigUtils.drawShaderRect(shader, size, canvas);
    //               },
    //               child: Container(
    //                 color: index.isEven ? Colors.red : Colors.blue,
    //                 width: double.infinity,
    //                 height: double.infinity,
    //                 child: Text('第$index页'),
    //               ),
    //             );
    //           } else {
    //             return Container(
    //               color: index.isEven ? Colors.red : Colors.blue,
    //               width: double.infinity,
    //               height: double.infinity,
    //               child: Text('第$index页'),
    //             );
    //           }
    //         },
    //         itemCount: 3,
    //       );
    //     },
    //     assetKey: curlShaderAssetKey,
    //   ),
    // );

    return ShaderBuilder(
      (context, shader, _) {
        return ReaderView.builder(
          controller: controller,
          itemBuilder: (context, index) {
            if (index == 0) {
              return AnimatedSampler(
                (image, size, canvas) {
                  shader
                    ..setFloat(0, size.width) // resolution
                    ..setFloat(1, size.height) // resolution
                    ..setFloat(2, size.width / 2) // mouse
                    ..setFloat(3, size.height / 3) // mouse
                    ..setFloat(4, size.width) // mouse
                    ..setFloat(5, 0) // mousernerRadius
                    ..setImageSampler(0, image); // image

                  PageCurlConfigUtils.drawShaderRect(shader, size, canvas);
                },
                child: Container(
                  color: index.isEven ? Colors.red : Colors.blue,
                  width: double.infinity,
                  height: double.infinity,
                  child: Text('第$index页'),
                ),
              );
            } else {
              return Container(
                color: index.isEven ? Colors.red : Colors.blue,
                width: double.infinity,
                height: double.infinity,
                child: Text('第$index页'),
              );
            }
          },
          itemCount: 3,
        );
      },
      assetKey: curlShaderAssetKey,
    );
  }
}
