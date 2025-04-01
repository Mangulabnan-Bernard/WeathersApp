import 'package:flutter/cupertino.dart';

class LocationPage extends StatelessWidget {
  final String initialLocation;

  const LocationPage({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Location')),
      child: SafeArea(
        child: Center(child: Text('Location Page: $initialLocation')),
      ),
    );
  }
}
