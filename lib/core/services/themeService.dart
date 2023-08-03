import 'dart:math';

import 'package:flutter/material.dart';

class ThemeService {
  ThemeService() {
    // HiveService.hiveDbService.createBox('theme_mode');
  }

  MaterialColor generateMaterialColor(Color color) {
    return MaterialColor(color.value, {
      50: tintColor(color, 0.9),
      100: tintColor(color, 0.8),
      200: tintColor(color, 0.6),
      300: tintColor(color, 0.4),
      400: tintColor(color, 0.2),
      500: color,
      600: shadeColor(color, 0.1),
      700: shadeColor(color, 0.2),
      800: shadeColor(color, 0.3),
      900: shadeColor(color, 0.4),
    });
  }

  int tintValue(int value, double factor) => max(0, min((value + ((255 - value) * factor)).round(), 255));

  Color tintColor(Color color, double factor) => Color.fromRGBO(tintValue(color.red, factor), tintValue(color.green, factor), tintValue(color.blue, factor), 1);

  int shadeValue(int value, double factor) => max(0, min(value - (value * factor).round(), 255));

  Color shadeColor(Color color, double factor) => Color.fromRGBO(shadeValue(color.red, factor), shadeValue(color.green, factor), shadeValue(color.blue, factor), 1);

  ThemeData getLightTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: const Color(0xff356EBE),
        secondaryHeaderColor: const Color(0xffF3F7FA),
        primarySwatch: generateMaterialColor(const Color(0xffF2E8CE)),

        // backgroundColor: Color(0xffF3F7FA),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 0, foregroundColor: Color(0xff143F91), shape: CircleBorder()),
        scaffoldBackgroundColor: const Color(0xffE8F3F9),
        brightness: Brightness.light,
        //  colorSchemeSeed: const Color(0xffec008c),
        dividerColor: Colors.grey.shade800,
        focusColor: const Color(0xff143F91),
        hintColor: Colors.grey,
        splashColor: Colors.grey.shade200,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: const Color(0xff143F91),
          ),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        colorScheme: const ColorScheme.light(
          primary: Color(0xff143F91),
          secondary: Color(0xff143F91),
        ),
        useMaterial3: true,
        errorColor: Colors.red,
        textTheme: const TextTheme(
          titleSmall: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Color(0xff263238), height: 1.2),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, color: Color(0xff263238), height: 1.2),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Color(0xff263238), height: 1.3),
          headlineSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Color(0xff263238), height: 1.3),
          headlineMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Color(0xff263238), height: 1.3),
          headlineLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Color(0xff263238), height: 1.5),
          displaySmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Color(0xff263238), height: 1.3),
          displayMedium: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Color(0xff263238), height: 1.4),
          displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Color(0xff263238), height: 1.4),
          bodySmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Color(0xff263238), height: 1.2),
          bodyMedium: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Color(0xff263238), height: 1.2),
          bodyLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Color(0xff263238), height: 1.2),
        )

        //GoogleFonts.latoTextTheme(const )

        );
  }

  ThemeData getDarkTheme() {
    // TODO change font dynamically
    return ThemeData(
        primaryColor: const Color(0xff143F91),
        primarySwatch: generateMaterialColor(const Color(0xff143F91)),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(elevation: 0, foregroundColor: Color(0xff143F91), backgroundColor: Colors.black, shape: CircleBorder()),
        scaffoldBackgroundColor: const Color(0xffedf1f3),
        brightness: Brightness.dark,
        // colorSchemeSeed: Colors.blue,
        dividerColor: Colors.white38,
        focusColor: const Color(0xff143F91),
        hintColor: Colors.white38,
        toggleableActiveColor: const Color(0xff143F91),
        splashColor: const Color(0xFF2C2C2C),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: const Color(0xff143F91),
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff143F91),
          secondary: Colors.white38,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff143F91),
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700, color: Color(0xff143F91), height: 1.3),
          headline5: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Color(0xff143F91), height: 1.3),
          headline4: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400, color: Colors.white, height: 1.3),
          headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3),
          headline2: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: Color(0xff143F91), height: 1.4),
          headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w300, color: Colors.white, height: 1.4),
          subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2),
          subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Color(0xff143F91), height: 1.2),
          bodyText2: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: Colors.white, height: 1.2),
          bodyText1: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Color(0xff2b2b2b), height: 1.2),
          caption: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300, color: Color(0xff143F91), height: 1.2),
        )

        //  GoogleFonts.getTextTheme("Poppins",)

        );
  }

  ThemeMode getThemeMode() {
    String? themeMode = ThemeMode.light.toString();
    switch (themeMode) {
      case 'ThemeMode.light':
        // SystemChrome.setSystemUIOverlayStyle(
        //   SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.white),
        // );
        return ThemeMode.light;
      case 'ThemeMode.dark':
        // SystemChrome.setSystemUIOverlayStyle(
        //   SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: Colors.black),
        // );
        return ThemeMode.dark;
      default:
        // SystemChrome.setSystemUIOverlayStyle(
        //   SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.white),
        // );
        return ThemeMode.light;
    }
  }

// Locale getLocale() {
//   String? locale = GetStorage().read<String>('language');
//   print('locale:$locale');
//   if (locale == null || locale.isEmpty) {
//     locale = 'en_US';
//   }
//   print('locale:$locale');
//   return Get.find<TranslationService>().fromStringToLocale(locale);
// }
}
