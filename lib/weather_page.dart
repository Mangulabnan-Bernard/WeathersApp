import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'settings_page.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage();

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String location = "San Fernando";
  String temp = "";
  IconData? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";
  Map<String, dynamic> weatherData = {};
  bool isMetric = true;

  Future<void> getWeatherData() async {
    try {
      final unit = isMetric ? 'metric' : 'imperial';
      final link = "https://api.openweathermap.org/data/2.5/weather?q=$location&units=$unit&appid=8a5d356fbd1d1e14b2fc12eebc4946a1";
      final response = await http.get(Uri.parse(link));
      weatherData = jsonDecode(response.body);

      setState(() {
        if (weatherData["cod"] == 200) {
          double temperature = weatherData["main"]["temp"];
          temp = temperature.toStringAsFixed(0);

          humidity = weatherData["main"]["humidity"].toString() + "%";
          windSpeed = weatherData["wind"]["speed"].toString() + (isMetric ? " kph" : " mph");
          weather = weatherData["weather"][0]["description"];

          if (weather.contains("clear")) {
            weatherStatus = CupertinoIcons.sun_max;
          } else if (weather.contains("cloud")) {
            weatherStatus = CupertinoIcons.cloud;
          } else if (weather.contains("haze")) {
            weatherStatus = CupertinoIcons.sun_haze;
          } else if (weather.contains("rain")) {
            weatherStatus = CupertinoIcons.cloud_rain;
          }
        } else {
          print("Invalid City");
        }
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("MyWeather"),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(CupertinoIcons.settings),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SettingsPage(initialLocation: location, isMetric: isMetric),
                ),
              );

              if (result != null) {
                setState(() {
                  location = result['location'];
                  isMetric = result['isMetric'];
                });
                getWeatherData();
              }
            },
          ),
        ),
        child: SafeArea(
          child: temp.isNotEmpty
              ? Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Text('My Location', style: TextStyle(fontSize: 35)),
                SizedBox(height: 5),
                Text(location),
                SizedBox(height: 10),
                Text(temp, style: TextStyle(fontSize: 80)),
                Icon(weatherStatus, color: CupertinoColors.systemOrange, size: 100),
                SizedBox(height: 10),
                Text(weather),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('H: $humidity'),
                    SizedBox(width: 10),
                    Text('W: $windSpeed'),
                  ],
                ),
              ],
            ),
          )
              : Center(child: CupertinoActivityIndicator()),
        ),
      ),
    );
  }
}
