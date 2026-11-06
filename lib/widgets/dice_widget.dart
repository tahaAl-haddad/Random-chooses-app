import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';
import '../models/item_model.dart';

class DiceWidget extends StatefulWidget {
  final List<ChoiceItem> items; // استقبال قائمة العناصر كاملة
  final Function(ChoiceItem) onRolled;

  const DiceWidget({
    Key? key,
    required this.items,
    required this.onRolled,
  }) : super(key: key);

  @override
  _DiceWidgetState createState() => _DiceWidgetState();
}

class _DiceWidgetState extends State<DiceWidget>
    with SingleTickerProviderStateMixin {
  ChoiceItem? _currentItem;
  bool _isRolling = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isRolling = false;
          // اختيار عنصر عشوائي من القائمة
          if (widget.items.isNotEmpty) {
            final randomIndex = Random().nextInt(widget.items.length);
            _currentItem = widget.items[randomIndex];
          }
        });
        if (_currentItem != null) {
          widget.onRolled(_currentItem!);
        }
      }
    });

    // تعيين عنصر افتراضي
    if (widget.items.isNotEmpty) {
      _currentItem = widget.items[0];
    }
  }

  void _rollDice() {
    if (_isRolling || widget.items.isEmpty) return;
    setState(() {
      _isRolling = true;
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
            Icon(Icons.casino, size: 50, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد عناصر', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: _rollDice,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..rotateX(_animation.value * 2)
              ..rotateY(_animation.value)
              ..rotateZ(_animation.value / 2),
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).primaryColor,
                  width: 3,
                ),
              ),
              child: _isRolling
                  ? Center(
                      child: Icon(
                        Icons.casino,
                        size: 80,
                        color: Theme.of(context).primaryColor.withOpacity(0.5),
                      ),
                    )
                  : _currentItem != null
                      ? _buildItemContent(_currentItem!)
                      : Center(
                          child: Text(
                            '?',
                            style: TextStyle(
                              fontSize: 80,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemContent(ChoiceItem item) {
    // إذا كان للعنصر صورة، اعرض الصورة
    if (item.imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(27), // 30 - 3 للحدود
        child: Image.file(
          File(item.imagePath!),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } 
    // إذا لم يكن هناك صورة، اعرض النص
    else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            item.text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
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