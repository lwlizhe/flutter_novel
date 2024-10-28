import 'dart:ui' as ui;

class PageCurlConfigUtils{
  static void drawShaderRect(
      ui.FragmentShader shader, ui.Size size, ui.Canvas canvas) {
    canvas.drawRect(
      ui.Rect.fromCenter(
        center: ui.Offset(size.width / 2, size.height / 2),
        width: size.width,
        height: size.height,
      ),
      ui.Paint()..shader = shader,
    );
  }
}

