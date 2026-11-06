import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import '../models/item_model.dart';

class CoinWidget extends StatefulWidget {
  final List<ChoiceItem> items; // استقبال قائمة العناصر
  final Function(ChoiceItem) onFlipped; // إرجاع العنصر المختار

  const CoinWidget({
    Key? key,
    required this.items,
    required this.onFlipped,
  }) : super(key: key);

  @override
  _CoinWidgetState createState() => _CoinWidgetState();
}

class _CoinWidgetState extends State<CoinWidget>
    with SingleTickerProviderStateMixin {
  ChoiceItem? _currentSide;
  bool _isFlipping = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isFlipping = false;
          // اختيار عنصر عشوائي من القائمة (العملة تختار عنصراً واحداً)
          if (widget.items.isNotEmpty) {
            final randomIndex = Random().nextInt(widget.items.length);
            _currentSide = widget.items[randomIndex];
          }
        });
        if (_currentSide != null) {
          widget.onFlipped(_currentSide!);
        }
      }
    });

    // تعيين عنصر افتراضي
    if (widget.items.isNotEmpty) {
      _currentSide = widget.items[0];
    }
  }

  void _flipCoin() {
    if (_isFlipping || widget.items.isEmpty) return;
    setState(() {
      _isFlipping = true;
    });
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد عناصر', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _flipCoin,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          // قيمة الدوران الحالية
          final double rotationValue = _animation.value;
          // هل نحن في الجهة الخلفية؟
          final bool isShowingBack = (rotationValue % (2 * pi)) > pi / 2 && 
                                     (rotationValue % (2 * pi)) < (3 * pi) / 2;
          
          return Transform(
            transform: Matrix4.identity()
              ..rotateY(rotationValue),
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.amber.shade300,
                    Colors.amber.shade700,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Colors.amber.shade900,
                  width: 4,
                ),
              ),
              child: _isFlipping
                  ? Center(
                      child: Icon(
                        Icons.autorenew,
                        size: 80,
                        color: Colors.white,
                      ),
                    )
                  : _buildCoinContent(_currentSide!, isShowingBack),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCoinContent(ChoiceItem item, bool isShowingBack) {
    // إذا كانت العملة تظهر الوجه الخلفي (أثناء الدوران)
    if (isShowingBack) {
      return Center(
        child: Icon(
          Icons.monetization_on,
          size: 80,
          color: Colors.white.withOpacity(0.5),
        ),
      );
    }

    // عرض محتوى العنصر على العملة
    if (item.imagePath != null) {
      // إذا كان للعنصر صورة، اعرض الصورة بشكل دائري
      return ClipOval(
        child: Image.file(
          File(item.imagePath!),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // إذا لم يكن هناك صورة، اعرض النص
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            item.text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
  }
}