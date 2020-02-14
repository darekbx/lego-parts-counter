import 'package:flutter/material.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _apiInputController = TextEditingController();
  var _localStorage = LocalStorage();

  @override
  void initState() {
    super.initState();
    _loadKey();
    _apiInputController.addListener(() {
      _localStorage.setApiKey(_apiInputController.text);
    });
  }

  @override
  void dispose() {
    _apiInputController.dispose();
    super.dispose();
  }

  void _loadKey() async {
    var apiKey = await _localStorage.getApiKey();
    setState(() {
      _apiInputController.text = apiKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Settings")),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Rebrickable API key"),
                TextField(
                  controller: _apiInputController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(hintText: "API key"),
                )
              ],
            )));
  }
}