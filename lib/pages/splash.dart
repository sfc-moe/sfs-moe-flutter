import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission/permission.dart';
import 'package:sfs/pages/login.dart';

class SplashWidget extends StatefulWidget {
  @override
  _SplashWidgetState createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  _SplashWidgetState() {
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    List<PermissionName> permissionList = [];
    if (Platform.isIOS) {
      permissionList = [PermissionName.Internet];
    } else if (Platform.isAndroid) {
      permissionList = [];
    }

    if (permissionList.isEmpty) {
      return _permissionPassed();
    }
    var permissions = await Permission.getPermissionsStatus(permissionList);
    if (permissions
        .map((p) =>
            (p.permissionStatus == PermissionStatus.always) ||
            (p.permissionStatus == PermissionStatus.allow))
        .reduce((a, b) => a && b)) {
      return _permissionPassed();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Permission Required"),
              content: Text("SFS-Moe requires Internet Permission for Working"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Go to Settings'),
                  onPressed: () async {
                    await Permission.requestPermissions(permissionList);
                    await _checkPermission();
                  },
                ),
              ],
            );
          });
    }
  }

  void _permissionPassed() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginWidget()));
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Loading'));
  }
}
