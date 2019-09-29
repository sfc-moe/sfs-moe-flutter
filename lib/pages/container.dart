import 'package:flutter/material.dart';
import 'dart:io';
import '../utils/settings.dart';

class ContainerWidget extends StatefulWidget {
  ContainerWidget({Key key, @required this.onThemeChanged}) : super(key: key);

  final ValueChanged<bool> onThemeChanged;
  @override
  _ContainerWidgetState createState() => _ContainerWidgetState(onThemeChanged: onThemeChanged);
}

class _ContainerWidgetState extends State<ContainerWidget> {
  _ContainerWidgetState({@required this.onThemeChanged}) {
    Settings.darkMode.then((value) {
      this.setState(() {
        _darkMode = value;
        onThemeChanged(value);
      });
    });
  }

  final ValueChanged<bool> onThemeChanged;
  int _selectedIndex = 0;
  bool _darkMode = false;
  bool _isLoading = false;

  static const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Timetable',
      style: optionStyle,
    ),
    Text(
      'Index 1: Assignments',
      style: optionStyle,
    ),
    Text(
      'Index 2: Bus Timer',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SFS Moe'),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            _widgetOptions.elementAt(_selectedIndex),
            _showCircularProgress(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
          icon: Icon(Icons.school),
          title: Text('Timetable'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Assignments'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            title: Text('Bus Timer'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(
                child: Image.asset('assets/images/logo.png')
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.web),
              title: Text('Go To SFC-SFS'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_activity),
              title: Text('Go To Wellness'),
              onTap: () async {
                print(Platform.operatingSystem);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: _darkMode,
              onChanged: (darkMode) {
                setState(() {
                  _darkMode = darkMode;
                });
                this.onThemeChanged(darkMode);
              },
              secondary: const Icon(Icons.lightbulb_outline),
            ),
          ],
        ),
      ),
    );
  }
}
