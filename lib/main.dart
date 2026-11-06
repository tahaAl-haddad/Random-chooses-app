import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'الاختيار العشوائي',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: FlexThemeData.light(
              scheme: FlexScheme.brandBlue,
              surfaceMode: FlexSurfaceMode.level,
              blendLevel: 7,
              appBarStyle: FlexAppBarStyle.primary,
              fontFamily: 'Tajawal',
            ),
            darkTheme: FlexThemeData.dark(
              scheme: FlexScheme.brandBlue,
              surfaceMode: FlexSurfaceMode.level,
              blendLevel: 15,
              appBarStyle: FlexAppBarStyle.primary,
              fontFamily: 'Tajawal',
            ),
            locale: Locale(themeProvider.currentLanguage),
            supportedLocales: [
              Locale('ar', ''),
              Locale('en', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}