import 'package:flutter/material.dart';
import 'package:lego_parts_counter/settings/settingspage.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';
import 'package:lego_parts_counter/utils/widgetutils.dart';

class QueryPage extends StatefulWidget {

  final _localStorage = LocalStorage();

  @override
  State<StatefulWidget> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {

  String _numberHint = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Lego Parts"),
            actions: <Widget>[_buildSettingsAction(context)]
        ),
        body: FutureBuilder(
            future: _checkApiKeyAndBuild(context),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              return WidgetUtils.handleFuture(snapshot, (data) => data);
            }
        )
    );
  }

  Future<Widget> _checkApiKeyAndBuild(BuildContext context) async {
    if (await widget._localStorage.hasApiKey()) {
      return _buildPage(context);
    } else {
      return Center(child: Text(
          "No Rebrickable api key, please provide key in settings screen."));
    }
  }

  Widget _buildPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child:
          DropdownButton<String>(
            hint: Text("Define, what to search"),
            onChanged: (String newValue) {
              setState(() {
                if (newValue == "Set") {
                  _numberHint = "Enter set number";
                } else if (newValue == "Part") {
                  _numberHint = "Enter part number";
                }
              });
            },
            items: <String>['Set', 'Part'].map<DropdownMenuItem<String>>((
                String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          )
        ),

        TextField(
          //controller: _apiInputController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: _numberHint),
        )

      ],
    );
  }

  Widget _buildSettingsAction(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsPage()));
      },
    );
  }
}