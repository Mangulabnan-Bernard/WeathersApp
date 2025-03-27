import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapps/settings_list/abouts.dart';

class SettingsPage extends StatefulWidget {
  final String initialLocation;
  final bool isMetric;

  const SettingsPage({required this.initialLocation, required this.isMetric});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isMetric = true;
  bool _isLightMode = false;
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
    final textController = TextEditingController(text: _locationName);

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Change Location'),
          content: CupertinoTextField(
            controller: textController,
            placeholder: 'Enter city name',
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('Save'),
              onPressed: () async {
                final cityToCheck = textController.text.trim();
                final isValid = await _checkCityValid(cityToCheck);
                if (isValid) {
                  setState(() {
                    _locationName = cityToCheck;
                  });
                  Navigator.pop(context);
                } else {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: Text('City Not Found'),
                      content: Text('Please enter a valid city name.'),
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
            ),
            CupertinoDialogAction(
              child: Text('Close', style: TextStyle(color: CupertinoColors.destructiveRed)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Text('Done'),
          onPressed: _onDone,
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Location Section
            CupertinoListTile(
              leading: Icon(CupertinoIcons.location, color: CupertinoColors.activeOrange),
              title: Text('Location'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_locationName, style: TextStyle(color: CupertinoColors.systemGrey)),
                  SizedBox(width: 8),
                  Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.systemGrey2),
                ],
              ),
              onTap: _changeLocation,
            ),

            // Icon Section
            CupertinoListTile(
              leading: Icon(CupertinoIcons.photo_fill_on_rectangle_fill, color: CupertinoColors.systemRed),
              title: Text('Icon'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.systemRed,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.systemGrey2),
                ],
              ),
              onTap: () {},
            ),

          
            CupertinoListTile(
              leading: Icon(CupertinoIcons.speedometer, color: CupertinoColors.systemGreen),
              title: Text('Metric System'),
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
              title: Text('About'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Members', style: TextStyle(color: CupertinoColors.systemGrey)),
                  SizedBox(width: 8),
                  Icon(CupertinoIcons.chevron_forward, color: CupertinoColors.systemGrey2),
                ],
              ),
              onTap: _showAboutPage,
            ),
          ],
        ),
      ),
    );
  }
}