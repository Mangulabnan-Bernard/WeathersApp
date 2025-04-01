import 'package:flutter/cupertino.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final List<Map<String, dynamic>> members = [
    {"name": "Mervin Magat", "role": "Lead Developer", "icon":
    CupertinoIcons.star, "color": CupertinoColors.systemBlue},
    {"name": "Bernard Mangulabnan", "role": "Developer/UI Designer", "icon":
    CupertinoIcons.paintbrush, "color": CupertinoColors.systemGreen},
    {"name": "Renz Samson", "role": "Backend Developer", "icon":
    CupertinoIcons.gear, "color": CupertinoColors.systemOrange},
    {"name": "Paul Vismonte", "role": "Tester/Testing", "icon":
    CupertinoIcons.checkmark_seal, "color": CupertinoColors.systemPurple},
    {"name": "Steven Lising", "role": "Content Writer/Accessibility Tester", "icon":
    CupertinoIcons.doc_text, "color": CupertinoColors.systemRed},
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('We are the Developers'),
        backgroundColor: CupertinoColors.systemBlue,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Meet the Team',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: CupertinoColors.black),
              ),
            ),
            Expanded(
              child: CupertinoListSection.insetGrouped(
                children: members.map((member) {
                  return CupertinoListTile(
                    leading: Icon(member['icon'], color: member['color']),
                    title: Text(member['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(member['role']),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
