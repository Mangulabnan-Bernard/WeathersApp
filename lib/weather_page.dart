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
  bool isDarkMode = false; // New: Track dark mode
  IconData cloudIcon = CupertinoIcons.cloud; // New: Track cloud icon
  bool isLoading = true; // Track loading state
  String errorMessage = ""; // Track error messages

  Future<void> getWeatherData() async {
    setState(() {
      isLoading = true; // Show loading indicator
      errorMessage = ""; // Reset error message
    });

    try {
      final unit = isMetric ? 'metric' : 'imperial';
      final link =
          "https://api.openweathermap.org/data/2.5/weather?q=$location&units=$unit&appid=8a5d356fbd1d1e14b2fc12eebc4946a1";
      final response = await http.get(Uri.parse(link));

      if (response.statusCode == 200) {
        weatherData = jsonDecode(response.body);

        setState(() {
          if (weatherData["cod"] == 200) {
            double temperature = weatherData["main"]["temp"];
            temp = temperature.toStringAsFixed(0);
            feelsLike = weatherData["main"]["feels_like"].toStringAsFixed(0);
            pressure = weatherData["main"]["pressure"].toString() + " hPa";
            visibility = (weatherData["visibility"] / 1000).toString() + " km";
            humidity = weatherData["main"]["humidity"].toString() + "%";
            windSpeed = weatherData["wind"]["speed"].toString() +
                (isMetric ? " kph" : " mph");
            weather = weatherData["weather"][0]["description"];
            sunrise = _convertToTime(weatherData["sys"]["sunrise"]);
            sunset = _convertToTime(weatherData["sys"]["sunset"]);

            if (weather.contains("clear")) {
              weatherStatus = CupertinoIcons.sun_max;
            } else if (weather.contains("cloud")) {
              weatherStatus = cloudIcon; // Use the selected cloud icon
            } else if (weather.contains("haze")) {
              weatherStatus = CupertinoIcons.sun_haze;
            } else if (weather.contains("rain")) {
              weatherStatus = CupertinoIcons.cloud_rain;
            }
          } else {
            errorMessage = "Invalid City";
          }
        });
      } else {
        errorMessage = "Failed to fetch weather data";
      }
    } catch (e) {
      errorMessage = "Error: $e";
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  String _convertToTime(int timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return "${date.hour}:${date.minute}";
  }

  Color _getTemperatureColor(double temp) {
    if (temp >= 37) {
      return CupertinoColors.systemRed; // High temp, red
    } else if (temp >= 26) {
      return CupertinoColors.systemBlue; // Moderate temp, orange
    } else {
      return CupertinoColors.systemYellow; // Low temp, yellow
    }
  }

  Color _getWeatherIconColor(double temp) {
    if (temp >= 37) {
      return CupertinoColors.systemRed; // High temp, red
    } else if (temp >= 26) {
      return CupertinoColors.systemBlue; // Moderate temp, orange
    } else {
      return CupertinoColors.systemYellow; // Low temp, yellow
    }
  }

  void _navigateToSettings() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SettingsPage(
          initialLocation: location,
          isMetric: isMetric,
          isDarkMode: isDarkMode,
          cloudIcon: cloudIcon,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        location = result['location'];
        isMetric = result['isMetric'];
        isDarkMode = result['isDarkMode']; // Update dark mode
        cloudIcon = result['cloudIcon']; // Update cloud icon
      });
      getWeatherData();
    }
  }

  @override
  void initState() {
    super.initState();
    getWeatherData(); // Fetch weather data on app start
  }

  Widget _buildTransparentBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: isDarkMode
              ? CupertinoColors.systemGrey.withOpacity(0.2) // Dark mode: Transparent gray
              : CupertinoColors.systemGrey.withOpacity(0.2), // Light mode: Transparent gray
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light, // Apply dark mode
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text("MyWeather", style: TextStyle(color: isDarkMode ? CupertinoColors.white : CupertinoColors.black)),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.settings, color: isDarkMode ? CupertinoColors.white : CupertinoColors.black),
              onPressed: _navigateToSettings,
            ),
          ),
          child: SafeArea(
            child: isLoading
                ? Center(child: CupertinoActivityIndicator()) // Show loading indicator
                : errorMessage.isNotEmpty
                ? Center(
              child: Text(
                errorMessage,
                style: TextStyle(
                  color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                  fontSize: 18,
                ),
              ),
            ) // Show error message
                : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    'My Location',
                    style: TextStyle(
                      fontSize: 35,
                      color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    location,
                    style: TextStyle(
                      color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
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
                      color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _buildTransparentBox('Humidity', humidity),
                      _buildTransparentBox('Wind', windSpeed),
                    ],
                  ),
                  Row(
                    children: [
                      _buildTransparentBox('Feels Like', '$feelsLike°C'),
                      _buildTransparentBox('Pressure', pressure),
                    ],
                  ),
                  Row(
                    children: [
                      _buildTransparentBox('Visibility', visibility),
                      _buildTransparentBox('Sunrise', sunrise),
                      _buildTransparentBox('Sunset', sunset),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}