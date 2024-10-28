import 'package:flutter/material.dart';
import 'package:flutter_curl_shader_page/flutter_page_curl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter CURL Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: CurlShaderReaderPage(
        itemBuilder: (BuildContext context, int index) {
          return _ReaderItemPage(index);
        },
      ),
    );
  }
}

class _ReaderItemPage extends StatelessWidget {
  final int index;

  const _ReaderItemPage(this.index, {super.key});

  final List<Color> colorList = const [
    Colors.red,
    Colors.redAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: colorList[index % colorList.length],
      child: Text(
        index.toString(),
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

// class _MyHomePageState extends State<MyHomePage>
//     with SingleTickerProviderStateMixin {
//   Offset downPosition = Offset.zero;
//   Offset updatePosition = Offset.zero;
//
//   Offset changeOffset = Offset.zero;
//
//   double currentTime = 1.0;
//
//   AnimationController? _controller;
//   Animation<Offset>? _animation;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//
//     _controller?.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           downPosition = Offset.zero;
//           updatePosition = Offset.zero;
//         });
//       }
//     });
//
//     _controller?.addListener(() {
//       if (_animation?.isCompleted ?? true) {
//         return;
//       }
//       developer
//           .log('_controller call : value:${_animation?.value ?? Offset.zero}');
//       setState(() {
//         updatePosition = _animation?.value ?? Offset.zero;
//       });
//     });
//   }
//
//   void _startAnimation(Offset startPos, Offset endPos, {Duration? duration}) {
//     setState(() {
//       downPosition = startPos;
//       updatePosition = startPos;
//     });
//     if (duration != null) {
//       _controller?.duration = duration;
//     }
//
//     _controller?.duration ??= const Duration(seconds: 2);
//
//     _animation = Tween<Offset>(
//       begin: startPos,
//       end: endPos,
//     ).animate(CurvedAnimation(
//       parent: _controller!,
//       curve: Curves.easeInOut,
//     ));
//     _controller?.forward(from: 0.0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: LayoutBuilder(
//         builder: (BuildContext context, BoxConstraints constraints) {
//           return Stack(
//             children: <Widget>[
//               Positioned.fill(
//                 child: Container(
//                   height: double.infinity,
//                   width: double.infinity,
//                   color: Colors.orange.shade100,
//                   padding: const EdgeInsets.all(
//                     16,
//                   ),
//                   child: const Text(
//                     'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
//                     'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
//                     '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n'
//                     '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n',
//                     style: TextStyle(fontSize: 15),
//                   ),
//                 ),
//               ),
//               Positioned.fill(
//                 child: GestureDetector(
//                   onPanUpdate: (details) {
//                     setState(() {
//                       if (downPosition == Offset.zero) {
//                         downPosition = details.localPosition;
//                       }
//                       updatePosition = details.localPosition;
//                       developer.log(details.localPosition.toString(),
//                           name: 'update');
//                     });
//                   },
//                   onPanEnd: (details) {
//                     Offset currentEndPos = Offset(updatePosition.dx, updatePosition.dy);
//                     setState(() {
//                       downPosition = Offset.zero;
//                       updatePosition = Offset.zero;
//                     });
//
//                     if (details.velocity.pixelsPerSecond.dx <= 0) {
//                       _startAnimation(
//                           currentEndPos,
//                           -Offset(
//                               constraints.biggest.width,
//                               currentEndPos.dy <= constraints.maxHeight/2
//                                   ? 0
//                                   : constraints.maxHeight),
//                           duration: const Duration(milliseconds: 500));
//                     } else {
//                       _startAnimation(
//                           currentEndPos,
//                           Offset(
//                               constraints.biggest.width,
//                               currentEndPos.dy <= constraints.maxHeight/2
//                                   ? 0
//                                   : constraints.maxHeight),
//                           duration: const Duration(milliseconds: 500));
//                     }
//                   },
//                   onPanCancel: () {
//                     setState(() {
//                       downPosition = Offset.zero;
//                       updatePosition = Offset.zero;
//                     });
//                   },
//                   child: ShaderBuilder(
//                     (context, shader, _) {
//                       return AnimatedSampler(
//                         (image, size, canvas) {
//                           shader
//                             ..setFloat(0, size.width) // resolution
//                             ..setFloat(1, size.height) // resolution
//                             ..setFloat(2, updatePosition.dx) // mouse
//                             ..setFloat(3, updatePosition.dy) // mouse
//                             ..setFloat(4, downPosition.dx) // mouse
//                             ..setFloat(5, downPosition.dy) // mousernerRadius
//                             ..setImageSampler(0, image); // image
//                           developer.log(
//                               'sampler call : updatePosition:$updatePosition , downPosition:$downPosition');
//
//                           PageCurlConfigUtils.drawShaderRect(
//                               shader, size, canvas);
//                         },
//                         child: Container(
//                           height: double.infinity,
//                           width: double.infinity,
//                           color: Colors.red,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                           ),
//                           child: const Text(
//                             'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
//                             'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
//                             '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n'
//                             '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n',
//                             style: TextStyle(fontSize: 15),
//                           ),
//                         ),
//                       );
//                     },
//                     assetKey: curlShaderAssetKey,
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: Row(
//                   children: [
//                     TextButton(
//                         onPressed: () {
//                           _startAnimation(Offset(-constraints.biggest.width, 1),
//                               Offset(constraints.biggest.width, 1));
//                         },
//                         child: Text('上一页')),
//                     TextButton(
//                         onPressed: () {
//                           _startAnimation(Offset(constraints.biggest.width, 1),
//                               Offset(-constraints.biggest.width, 1));
//                         },
//                         child: Text('下一页')),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
