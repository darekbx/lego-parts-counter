import 'package:flutter/material.dart';
import 'package:lego_parts_counter/utils/widgetutils.dart';

class ResultsPage extends StatefulWidget {
  String partNumber;
  String setNumber;

  ResultsPage({this.partNumber, this.setNumber});

  @override
  _ResultsPageState createState() => _ResultsPageState();

  bool isForSet() => setNumber != null;
}

class _ResultsPageState extends State<ResultsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Lego Parts - Set No. ${widget.partNumber ?? widget.setNumber}")
        ),
        body: FutureBuilder(
            future: _buildList(context),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              return WidgetUtils.handleFuture(snapshot, (data) => data);
            }
        )
    );
  }

  Future<Widget> _buildList(BuildContext context) {
    if (widget.isForSet()) {
      return _buildSetsList(context);
    } else {
      return _buildPartsList(context);
    }
  }

  Future<Widget> _buildSetsList(BuildContext context) {

  }

  Future<Widget> _buildPartsList(BuildContext context) {

  }
}