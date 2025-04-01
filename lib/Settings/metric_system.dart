import 'package:flutter/cupertino.dart';

class MetricSystemPage extends StatefulWidget {
  final bool isMetric;

  const MetricSystemPage({super.key, required this.isMetric});

  @override
  State<MetricSystemPage> createState() => _MetricSystemPageState();
}

class _MetricSystemPageState extends State<MetricSystemPage> {
  late bool _isMetric;

  @override
  void initState() {
    super.initState();
    _isMetric = widget.isMetric;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text('Metric System')),
      child: SafeArea(
        child: Center(
          child: CupertinoSwitch(
            value: _isMetric,
            onChanged: (value) {
              setState(() => _isMetric = value);
            },
          ),
        ),
      ),
    );
  }
}
