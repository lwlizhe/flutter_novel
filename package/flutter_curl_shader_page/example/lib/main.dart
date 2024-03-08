import 'package:flutter/material.dart';
import 'dart:developer' as developer;

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

class _MyHomePageState extends State<MyHomePage> {
  Offset downPosition = Offset.zero;
  Offset updatePosition = Offset.zero;

  Offset changeOffset = Offset.zero;

  double currentTime = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.orange.shade100,
              padding: const EdgeInsets.all(
                16,
              ),
              child: const Text(
                'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
                'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
                '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n'
                '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onPanDown: (details) {
                setState(() {
                  downPosition = details.localPosition;
                  updatePosition = details.localPosition;
                  developer.log(details.toString(), name: 'down');
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  updatePosition = details.localPosition;
                  developer.log(details.localPosition.toString(),
                      name: 'update');
                });
              },
              onPanEnd: (details) {
                setState(() {
                  downPosition = Offset.zero;
                  updatePosition = Offset.zero;
                  developer.log(details.velocity.toString(), name: 'end');
                });
              },
              onPanCancel: () {
                setState(() {
                  downPosition = Offset.zero;
                  updatePosition = Offset.zero;
                  developer.log('', name: 'cancel');
                });
              },
              child: ShaderBuilder(
                (context, shader, _) {
                  return AnimatedSampler(
                    (image, size, canvas) {
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
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.red,
                      padding: const EdgeInsets.all(
                        16,
                      ),
                      child: const Text(
                        'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
                        'a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text，a lot of text\n\n'
                        '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n'
                        '很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字很多文字\n\n',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  );
                },
                assetKey: curlShaderAssetKey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
