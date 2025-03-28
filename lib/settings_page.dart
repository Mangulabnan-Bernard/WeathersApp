import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapps/settings_list/abouts.dart';
import 'city_list.dart';

class SettingsPage extends StatefulWidget {
  final String initialLocation;
  final bool isMetric;

  const SettingsPage({required this.initialLocation, required this.isMetric});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isMetric = true;
  late String _locationName;

  @override
  void initState() {
    super.initState();
    _locationName = widget.initialLocation;
    _isMetric = widget.isMetric;
  }

  Future<bool> _checkCityValid(String city) async {
    try {
      final url = "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=b565a0e5c08b8b96b4a12f1b993b26bd";
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
    Navigator.pop(context, {'location': _locationName, 'isMetric': _isMetric});
  }

  void _showAboutPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AboutPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Settings', style: TextStyle(color: CupertinoColors.white)),
          backgroundColor: CupertinoColors.systemBlue,
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Text('Done', style: TextStyle(color: CupertinoColors.white)),
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
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
              CupertinoListTile(
                leading: Icon(CupertinoIcons.location_solid, color: CupertinoColors.systemBlue),
                title: Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Current: $_locationName', style: TextStyle(color: CupertinoColors.systemGrey)),
                onTap: _changeLocation,
              ),
              CupertinoListTile(
                leading: Icon(CupertinoIcons.thermometer, color: CupertinoColors.systemGreen),
                title: Text('Metric System', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Switch between Celsius and Fahrenheit', style: TextStyle(color: CupertinoColors.systemGrey)),
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
                leading: Icon(CupertinoIcons.info_circle_fill, color: CupertinoColors.activeBlue),
                title: Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Learn more about the Developers', style: TextStyle(color: CupertinoColors.systemGrey)),
                onTap: _showAboutPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
