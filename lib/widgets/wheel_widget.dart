import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class WheelWidget extends StatefulWidget {
  final List<String> items;
  final Function(String) onSelected;

  const WheelWidget({
    Key? key,
    required this.items,
    required this.onSelected,
  }) : super(key: key);

  @override
  _WheelWidgetState createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _rotation = 0;
  bool _isSpinning = false;
  Timer? _spinTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          _rotation = _controller.value * 2 * pi * 5;
        });
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isSpinning = false;
        });
        _determineWinner();
      }
    });
  }

  void _spinWheel() {
    if (widget.items.isEmpty || _isSpinning) return;

    setState(() {
      _isSpinning = true;
    });

    _controller.forward(from: 0);
  }

  void _determineWinner() {
    if (widget.items.isEmpty) return;

    final random = Random();
    final winnerIndex = random.nextInt(widget.items.length);
    
    widget.onSelected(widget.items[winnerIndex]);
  }

  @override
  void dispose() {
    _controller.dispose();
    _spinTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _spinWheel,
      child: Container(
        width: 300,
        height: 300,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // العجلة
            Transform.rotate(
              angle: _rotation,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      Colors.red,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow,
                      Colors.purple,
                      Colors.orange,
                      Colors.pink,
                      Colors.teal,
                      Colors.red,
                    ],
                    stops: List.generate(9, (i) => i / 8),
                  ),
                ),
                child: CustomPaint(
                  painter: WheelPainter(items: widget.items),
                ),
              ),
            ),
            // السهم
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_upward,
                color: Colors.red,
                size: 30,
              ),
            ),
            if (_isSpinning)
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 4,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  final List<String> items;

  WheelPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.5);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    // رسم خطوط التقسيم وإضافة النصوص
    int itemCount = items.length;
    if (itemCount > 0) {
      for (int i = 0; i < itemCount; i++) {
        final angle = i * (2 * pi / itemCount);
        final start = Offset(size.width / 2, size.height / 2);
        final end = Offset(
          size.width / 2 + cos(angle) * size.width / 2,
          size.height / 2 + sin(angle) * size.height / 2,
        );
        canvas.drawLine(start, end, paint);

        // رسم النص
        final textAngle = angle + (pi / itemCount);
        final textPosition = Offset(
          size.width / 2 + cos(textAngle) * size.width * 0.35,
          size.height / 2 + sin(textAngle) * size.height * 0.35,
        );

        final textSpan = TextSpan(
          text: items[i].length > 10 ? '${items[i].substring(0, 10)}...' : items[i],
          style: textStyle,
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.rtl,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            textPosition.dx - textPainter.width / 2,
            textPosition.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}