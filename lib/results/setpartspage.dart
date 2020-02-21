import 'package:flutter/material.dart';
import 'package:lego_parts_counter/rebrickable/baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/setpart.dart';
import 'package:lego_parts_counter/rebrickable/rebrickableapi.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';
import 'package:lego_parts_counter/utils/widgetutils.dart';

class SetPartsPage extends StatefulWidget {

  String setNumber;

  SetPartsPage(this.setNumber);

  @override
  _SetPartsPageState createState() => _SetPartsPageState();
}

class _SetPartsPageState extends State<SetPartsPage> {

  BaseResponse<SetPart> contents;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Lego Parts - from ${widget.setNumber}")
        ),
        body: FutureBuilder(
            future: _buildList(),
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              return WidgetUtils.handleFuture(snapshot, (data) => data);
            }
        )
    );
  }

  Future<Widget> _buildList() async {
    var apiKey = await loadApiKey();
    var response = await RebrickableApi(apiKey).fetchSetParts(widget.setNumber, 1);

    return ListView.builder(
      itemCount: response.count,
      itemBuilder: (context, index) {
        var result = response.results[index];
        return
          Card(child: ListTile(
            leading: SizedBox(width: 80, child: Image.network(result.part.partImgUrl)),
            title: Text("${result.part.name}, count: ${result.quantity}"),
            subtitle: Text("In sets: ${result.numSets}"),
          ));
      },
    );
  }

  Future<String> loadApiKey() async => await LocalStorage().getApiKey();
}