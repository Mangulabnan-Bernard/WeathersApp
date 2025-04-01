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
  String feelsLike = "";
  String pressure = "";
  String visibility = "";
  IconData? weatherStatus;
  String weather = "";
  String humidity = "";
  String windSpeed = "";
  String sunrise = "";
  String sunset = "";
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

          feelsLike = weatherData["main"]["feels_like"].toStringAsFixed(0);
          pressure = weatherData["main"]["pressure"].toString() + " hPa";
          visibility = (weatherData["visibility"] / 1000).toString() + " km";

          humidity = weatherData["main"]["humidity"].toString() + "%";
          windSpeed = weatherData["wind"]["speed"].toString() + (isMetric ? " kph" : " mph");
          weather = weatherData["weather"][0]["description"];

          sunrise = _convertToTime(weatherData["sys"]["sunrise"]);
          sunset = _convertToTime(weatherData["sys"]["sunset"]);

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

  String _convertToTime(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.hour}:${date.minute}";
  }

  Color _getTemperatureColor(double temp) {
    if (temp >= 30) {
      return CupertinoColors.systemRed; // High temp, red
    } else if (temp >= 20) {
      return CupertinoColors.systemOrange; // Moderate temp, orange
    } else {
      return CupertinoColors.systemBlue; // Low temp, blue
    }
  }

  Color _getWeatherIconColor(double temp) {
    if (temp >= 30) {
      return CupertinoColors.systemRed;
    } else if (temp >= 20) {
      return CupertinoColors.systemOrange;
    } else {
      return CupertinoColors.systemBlue;
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
              ? Container(
            decoration: BoxDecoration(
              color: CupertinoColors.darkBackgroundGray, // Keep the dark mode background
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    Text(
                      'My Location',
                      style: TextStyle(
                        fontSize: 35,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      location,
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '$temp°C',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: _getTemperatureColor(double.parse(temp)),
                      ),
                    ),
                    Icon(
                      weatherStatus,
                      color: _getWeatherIconColor(double.parse(temp)),
                      size: 100,
                    ),
                    SizedBox(height: 10),
                    Text(
                      weather,
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Humidity: $humidity',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Wind: $windSpeed',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Feels like: $feelsLike°C',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'Pressure: $pressure',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Visibility: $visibility',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Sunrise: $sunrise | Sunset: $sunset',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              : Center(child: CupertinoActivityIndicator()),
        ),
      ),
    );
  }
}
