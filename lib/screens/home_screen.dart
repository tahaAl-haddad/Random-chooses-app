import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';
import '../providers/theme_provider.dart';
import '../widgets/wheel_widget.dart';
import '../widgets/dice_widget.dart';
import '../widgets/coin_widget.dart';
import 'add_item_screen.dart';
import 'settings_screen.dart';
import '../models/item_model.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<ChoiceItem> items = [];
  ChoiceItem? selectedItem; // تغيير من String? إلى ChoiceItem?
  int selectedMethod = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> selectionMethods = [
    {'name': 'عجلة الحظ', 'icon': Icons.track_changes},
    {'name': 'النرد', 'icon': Icons.casino},
    {'name': 'عملة', 'icon': Icons.monetization_on},
    {'name': 'اختيار عشوائي', 'icon': Icons.shuffle},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBarSafe(String message) {
    if (mounted) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  void _makeRandomChoice() {
    if (items.isEmpty) {
      _showSnackBarSafe('الرجاء إضافة عناصر أولاً');
      return;
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          final random = Random();
          final randomIndex = random.nextInt(items.length);
          selectedItem = items[randomIndex];
        });
        _animationController.forward(from: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('الاختيار العشوائي'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeProvider.primaryColor.withOpacity(0.1),
              themeProvider.primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            // طرق الاختيار
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selectionMethods.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ChoiceChip(
                      label: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(selectionMethods[index]['icon']),
                          Text(selectionMethods[index]['name']),
                        ],
                      ),
                      selected: selectedMethod == index,
                      onSelected: (selected) {
                        setState(() {
                          selectedMethod = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            // عرض طريقة الاختيار
            Expanded(
              child: Center(
                child: selectedMethod == 3
                    ? _buildRandomChoice()
                    : _buildSelectionMethod(),
              ),
            ),

            // النتيجة (مع عرض الصورة إذا وجدت)
            if (selectedItem != null)
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: themeProvider.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: themeProvider.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'النتيجة:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      if (selectedItem!.imagePath != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(selectedItem!.imagePath!),
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                      Text(
                        selectedItem!.text,
                        style: TextStyle(
                          fontSize: 24,
                          color: themeProvider.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddItemsScreen()),
          );
          if (result != null && result is List<ChoiceItem>) {
            setState(() {
              items = result;
            });
            _showSnackBarSafe('تم إضافة ${result.length} عناصر بنجاح');
          }
        },
        icon: Icon(Icons.add),
        label: Text('إضافة عناصر'),
      ),
    );
  }

  Widget _buildRandomChoice() {
    return GestureDetector(
      onTap: _makeRandomChoice,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shuffle,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 20),
            Text(
              'انقر للاختيار العشوائي',
              style: TextStyle(fontSize: 18),
            ),
            if (items.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'عدد العناصر: ${items.length}',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionMethod() {
    switch (selectedMethod) {
      case 0:
        if (items.isEmpty) {
          return _buildEmptyState();
        }
        return WheelWidget(
          items: items.map((item) => item.text).toList(),
          onSelected: (result) {
            // البحث عن العنصر المختار
            final selected = items.firstWhere(
              (item) => item.text == result,
              orElse: () => items.first,
            );
            SchedulerBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  selectedItem = selected;
                });
                _animationController.forward(from: 0);
              }
            });
          },
        );
     case 1:
  if (items.isEmpty) {
    return _buildEmptyState();
  }
  return DiceWidget(
    items: items, // تمرير قائمة العناصر كاملة
    onRolled: (selectedItem) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            this.selectedItem = selectedItem;
          });
          _animationController.forward(from: 0);
        }
      });
    },
  );
      case 2:
  if (items.isEmpty) {
    return _buildEmptyState();
  }
  return CoinWidget(
    items: items, // تمرير قائمة العناصر كاملة
    onFlipped: (selectedItem) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            this.selectedItem = selectedItem;
          });
          _animationController.forward(from: 0);
        }
      });
    },
  );
      default:
        return Container();
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, size: 50, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'لا توجد عناصر في القائمة',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddItemsScreen()),
              ).then((result) {
                if (result != null && result is List<ChoiceItem>) {
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        items = result;
                      });
                    }
                  });
                }
              });
            },
            child: Text('إضافة عناصر الآن'),
          ),
        ],
      ),
    );
  }
}