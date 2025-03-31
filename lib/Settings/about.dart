import 'package:flutter/cupertino.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('About')),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Members',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView(
                children: const [
                  CupertinoListTile(
                    leading: Icon(CupertinoIcons.person),
                    title: Text('Mervin Magat'),
                  ),
                  CupertinoListTile(
                    leading: Icon(CupertinoIcons.person),
                    title: Text('Bernard Mangulabnan'),
                  ),
                  CupertinoListTile(
                    leading: Icon(CupertinoIcons.person),
                    title: Text('Steven Lising'),
                  ),
                  CupertinoListTile(
                    leading: Icon(CupertinoIcons.person),
                    title: Text('Paul Vismonte'),
                  ),
                  CupertinoListTile(
                    leading: Icon(CupertinoIcons.person),
                    title: Text('Renz Samson'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
