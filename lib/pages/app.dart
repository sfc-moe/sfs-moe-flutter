import 'package:flutter/material.dart';
import '../pages/container.dart';
import '../utils/settings.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => new _AppWidgetState();
}

class _AppWidgetState extends State<StatefulWidget> {
  static const String _title = 'SFS Moe';
  ThemeData theme = ThemeData.light();

  void _handleThemeChanged(bool darkMode) {
    if (darkMode) {
      setState(() {
        theme = ThemeData.dark();
      });
    } else {
      setState(() {
        theme = ThemeData.light();
      });
    }
    Settings.setDarkMode(darkMode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: ContainerWidget(
        onThemeChanged: _handleThemeChanged,
      ),
      theme: theme,
    );
  }
}
