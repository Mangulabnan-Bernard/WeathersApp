import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'city_list.dart';
import 'Settings/about.dart';

class SettingsPage extends StatefulWidget {
  final String initialLocation;
  final bool isMetric;
  final bool isDarkMode; // Track dark mode
  final IconData cloudIcon; // Track cloud icon

  const SettingsPage({
    required this.initialLocation,
    required this.isMetric,
    required this.isDarkMode,
    required this.cloudIcon,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _isMetric;
  late String _locationName;
  late bool _isDarkMode; // Track dark mode
  late IconData _cloudIcon; // Track cloud icon

  @override
  void initState() {
    super.initState();
    _locationName = widget.initialLocation;
    _isMetric = widget.isMetric;
    _isDarkMode = widget.isDarkMode; // Initialize dark mode
    _cloudIcon = widget.cloudIcon; // Initialize cloud icon
  }

  Future<bool> _checkCityValid(String city) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=b565a0e5c08b8b96b4a12f1b993b26bd";
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["cod"] == 200) {
          return true;
        }
      }
    } catch (e) {}
    return false;
  }

  void _changeLocation() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Select City'),
        actions: philippineCities.map((city) {
          return CupertinoActionSheetAction(
            child: Text(city),
            onPressed: () async {
              final isValid = await _checkCityValid(city);
              if (isValid) {
                setState(() {
                  _locationName = city;
                });
                Navigator.pop(context);
              } else {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('City Not Found'),
                    content: Text('Please select a valid city name.'),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('OK'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _onDone() {
    Navigator.pop(
      context,
      {
        'location': _locationName,
        'isMetric': _isMetric,
        'isDarkMode': _isDarkMode, // Pass dark mode state
        'cloudIcon': _cloudIcon, // Pass cloud icon
      },
    );
  }

  void _showAboutPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AboutPage(isDarkMode: _isDarkMode), // Pass dark mode state
      ),
    );
  }

  void _pickCloudIcon() {
    // List of predefined cloud icons
    final cloudIcons = [
      CupertinoIcons.cloud,
      CupertinoIcons.cloud_fill,
      CupertinoIcons.cloud_rain,
      CupertinoIcons.cloud_snow,
      CupertinoIcons.cloud_bolt,
    ];
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Pick a Cloud Icon'),
        actions: cloudIcons.map((icon) {
          return CupertinoActionSheetAction(
            child: Icon(icon, size: 40),
            onPressed: () {
              setState(() {
                _cloudIcon = icon; // Update the selected icon
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light, // Apply dark mode
      ),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Settings', style: TextStyle(color: CupertinoColors.white)),
          backgroundColor: CupertinoColors.systemBlue,
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text('Done', style: TextStyle(color: CupertinoColors.inactiveGray)),
            onPressed: _onDone,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Weather Experience',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isDarkMode ? CupertinoColors.white : CupertinoColors.systemGrey,
                  ),
                ),
              ),
              CupertinoListTile(
                leading: Icon(CupertinoIcons.location_solid, color: CupertinoColors.systemBlue),
                title: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Current: $_locationName', style: TextStyle(color: _isDarkMode ? CupertinoColors.white : CupertinoColors.systemGrey)),
                onTap: _changeLocation,
              ),
              CupertinoListTile(
                leading: Icon(CupertinoIcons.thermometer, color: CupertinoColors.systemGreen),
                title: Text('Metric System', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Switch between Celsius and Fahrenheit', style: TextStyle(color: _isDarkMode ? CupertinoColors.white : CupertinoColors.systemGrey)),
                trailing: CupertinoSwitch(
                  value: _isMetric,
                  onChanged: (value) {
                    setState(() {
                      _isMetric = value;
                    });
                  },
                ),
              ),
              CupertinoListTile(
                leading: Icon(CupertinoIcons.moon, color: CupertinoColors.systemIndigo),
                title: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Enable or disable dark mode', style: TextStyle(color: _isDarkMode ? CupertinoColors.white : CupertinoColors.systemGrey)),
                trailing: CupertinoSwitch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ),
              CupertinoListTile(
                leading: Icon(_cloudIcon, color: CupertinoColors.systemBlue),
                title: Text('Cloud Icon', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Customize the cloud icon', style: TextStyle(color: _isDarkMode ? CupertinoColors.white : CupertinoColors.systemGrey)),
                onTap: _pickCloudIcon,
              ),
              CupertinoListTile(
                leading: Icon(CupertinoIcons.info_circle_fill, color: CupertinoColors.activeBlue),
                title: Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Learn more about the Developers', style: TextStyle(color: _isDarkMode ? CupertinoColors.white : CupertinoColors.systemGrey)),
                onTap: _showAboutPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}