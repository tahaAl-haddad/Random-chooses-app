import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  final List<Color> availableColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          // وضع الظلام
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المظهر',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.brightness_auto),
                    title: Text('تلقائي'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.brightness_5),
                    title: Text('فاتح'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.brightness_2),
                    title: Text('داكن'),
                    trailing: Radio<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: themeProvider.themeMode,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setThemeMode(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // الألوان الأساسية
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اللون الأساسي',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: availableColors.map((color) {
                      return GestureDetector(
                        onTap: () => themeProvider.setPrimaryColor(color),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: themeProvider.primaryColor == color
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: themeProvider.primaryColor == color
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // اللغة
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اللغة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('العربية'),
                    trailing: Radio<String>(
                      value: 'ar',
                      groupValue: themeProvider.currentLanguage,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setLanguage(value);
                        }
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.language),
                    title: Text('English'),
                    trailing: Radio<String>(
                      value: 'en',
                      groupValue: themeProvider.currentLanguage,
                      onChanged: (value) {
                        if (value != null) {
                          themeProvider.setLanguage(value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // إعدادات الرسوم المتحركة
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الرسوم المتحركة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SwitchListTile(
                    title: Text('تفعيل الرسوم المتحركة'),
                    subtitle: Text('إضافة تأثيرات بصرية ممتعة'),
                    value: themeProvider.useAnimations,
                    onChanged: themeProvider.setUseAnimations,
                  ),
                ],
              ),
            ),
          ),

          // معلومات التطبيق
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'الاختيار العشوائي',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'الإصدار 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.star),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.info),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}