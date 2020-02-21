import 'package:flutter/material.dart';
import 'package:lego_parts_counter/results/resultspage.dart';
import 'package:lego_parts_counter/settings/settingspage.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';

enum QueryType {
  SET,
  PART
}

class QueryPage extends StatefulWidget {

  final _dropDownItems = [QueryType.SET, QueryType.PART];
  final _apiInputController = TextEditingController();
  final _localStorage = LocalStorage();
  final _typeNameMap = { QueryType.SET: "Set", QueryType.PART: "Part" };

  @override
  State<StatefulWidget> createState() => _QueryPageState();
}

class _QueryPageState extends State<QueryPage> {

  QueryType _selectedType;
  String _numberHint = "";
  bool _editEnabled = false;
  bool _hasApiAKey = true;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  void _checkApiKey() async {
    var result = await widget._localStorage.hasApiKey();
    setState(() {
      _hasApiAKey = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Lego Parts"),
            actions: <Widget>[_buildSettingsAction(context)]
        ),
        body: _createBody()
    );
  }

  Widget _createBody() {
    if (_hasApiAKey) {
      return _buildPage(context);
    } else {
      return Center(child: Text(
          "No Rebrickable api key, please provide key in settings screen."));
    }
  }

  Widget _buildPage(BuildContext context) {
    return Center(child: Container(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _createTypeSelect(),
        _createNumberInput()
      ],
    ), width: _calculateWidth(context)));
  }

  _createNumberInput() =>
      Padding(padding: EdgeInsets.only(left: 24, right: 24), child:
      TextField(
        controller: widget._apiInputController,
        enabled: _editEnabled,
        onSubmitted: (number) => _displayResultsPage(number),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(hintText: _numberHint),
      ));

  _createTypeSelect() =>
      DropdownButton<QueryType>(
        value: _selectedType,
        hint: Text("Define, what to search"),
        onChanged: (QueryType newValue) => _updateQueryState(newValue),
        items: _createDropdownItems(),
      );

  _createDropdownItems() =>
      widget._dropDownItems
          .map<DropdownMenuItem<QueryType>>((QueryType value) =>
          _createDropdownItem(value))
          .toList();

  _createDropdownItem(QueryType value) =>
      DropdownMenuItem<QueryType>(
        value: value,
        child: Text(widget._typeNameMap[value]),
      );

  _updateQueryState(QueryType type) {
    setState(() {
      widget._apiInputController.clear();
      _selectedType = type;
      if (type == QueryType.SET) {
        _numberHint = "Enter set number";
      } else if (type == QueryType.PART) {
        _numberHint = "Enter part number";
      }
      _editEnabled = true;
    });
  }

  _calculateWidth(BuildContext context) =>
      MediaQuery
          .of(context)
          .size
          .width / 2;

  _displayResultsPage(String number) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      if (_selectedType == QueryType.SET) {
        return ResultsPage(setNumber: number);
      } else {
        return ResultsPage(partNumber: number);
      }
    }));
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