import 'package:flutter/cupertino.dart';
import 'weather_page.dart';

void main() => runApp(
  CupertinoApp(
    debugShowCheckedModeBanner: false,
    locale: Locale('en', 'US'), // Set the locale to ensure Directionality is provided
    home: WeatherPage(),
  ),
);
