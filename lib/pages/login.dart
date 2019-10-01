import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:euc/euc.dart';
import 'package:dio/dio.dart';
import 'package:sfs/utils/sfs-auth.dart';
import '../utils/consts.dart';

import './app.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = new GlobalKey<FormState>();
  String _username;
  String _password;
  bool _isLoading = false;
  bool _autoLogin = false;

  _LoginWidgetState() {
    SfsAuth.profile.then((profile) {
      if (profile != null) {
        _username = profile.username;
        _password = profile.password;
        login();
      }
    });
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0, width: 0.0,);
  }

  void login() async {
    setState(() {
      _isLoading = true;
    });

    final client = Dio();
    try {
      final res = await client.post(
        '${Consts.SFS_HOST}/login.cgi',
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.bytes,
        ),
        data: FormData.fromMap({
          'u_login': _username,
          'u_pass': _password,
          'lang': 'ja',
        }),
      );

      var raw = EucJP().decode(res.data);
      var document = parse(raw);
      var meta = document.querySelector('meta').attributes['content'];

      if (meta == null || meta[0] != '0') {
        setState(() {
          _isLoading = false;
        });

        print(meta);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Login Failed"),
              content: Text("Please Check your Username or Password"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Dismiss'),
                  onPressed: () { Navigator.of(context).pop(); },
                ),
              ],
            );
          }
        );
        return;
      }

      var uri = Uri.parse(meta.substring(7));
      await SfsAuth.setToken(uri.queryParameters['id']);

      if (this._autoLogin) {
        await SfsAuth.updateProfile(SfsCredential(
          username: this._username,
          password: this._password,
        ));
      }
      
      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => AppWidget())
      );

    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error Occured"),
            content: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Dismiss'),
                onPressed: () { Navigator.of(context).pop(); },
              ),
            ],
          );
        }
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in to SFC-SFS'),
      ),
      body:Stack(
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    new Hero(
                      tag: 'hero',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 48.0,
                        child: Image.asset('assets/images/logo.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
                      child: new TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: new InputDecoration(
                            hintText: 'Username',
                            icon: new Icon(
                              Icons.person,
                              color: Colors.grey,
                            )),
                        validator: (value) => value.isEmpty ? 'Username can\'t be empty' : null,
                        onChanged: (value) => _username = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                      child: new TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        decoration: new InputDecoration(
                            hintText: 'Password',
                            icon: new Icon(
                              Icons.lock,
                              color: Colors.grey,
                            )),
                        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
                        onChanged: (value) => _password = value.trim(),
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('Auto Login'),
                      value: _autoLogin,
                      onChanged: (val) {
                        setState(() {
                          _autoLogin = val;
                        });
                      },
                    ),
                    new Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      child: SizedBox(
                        height: 40.0,
                        child: new RaisedButton(
                          elevation: 5.0,
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.blue,
                          child: new Text('Login',
                                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
                          onPressed: () {
                            login();
                          },
                        ),
                      )
                    ),
                    new FlatButton(
                      child: new Text('Forget Password',
                              style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                      onPressed: () {
                        // TODO: Forget Password
                      },
                    ),
                  ],
                ),
              )
            ),
          ),
          _showCircularProgress(),
        ],
      )
    );
  }
}
