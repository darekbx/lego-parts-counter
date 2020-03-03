import 'package:flutter/material.dart';
import 'package:lego_parts_counter/rebrickable/model/setpart.dart';
import 'package:lego_parts_counter/rebrickable/rebrickableapi.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';
import 'package:lego_parts_counter/utils/setpartdialog.dart';

class SetPartsPage extends StatefulWidget {

  String setNumber;

  SetPartsPage(this.setNumber);

  @override
  _SetPartsPageState createState() => _SetPartsPageState();
}

class _SetPartsPageState extends State<SetPartsPage> {

  ScrollController _scrollController = new ScrollController();

  List<SetPart> _parts = List();
  int page = 1;
  bool hasMore = true;
  bool isLoading = false;

  @override
  void initState() {
    _loadNextPage();
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Lego Parts - from ${widget.setNumber}")
        ),
        body: _buildList(),
        resizeToAvoidBottomPadding: false
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _parts.length + 1 /* For progress */,
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == _parts.length) {
          return _buildProgressIndicator();
        } else {
          var result = _parts[index];
          return
            Card(child: ListTile(
              leading: SizedBox(
                  width: 80, child: Image.network(result.part.partImgUrl)),
              title: Text("${result.part.name}, count: ${result.quantity}"),
              subtitle: Text("In sets: ${result.numSets}"),
              onTap: () { SetPartDialog(context).showSetPartDialog(result); },
            ));
        }
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _loadNextPage() async {
    if (isLoading || !hasMore) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    var apiKey = await loadApiKey();
    var response = await RebrickableApi(apiKey).fetchSetParts(widget.setNumber, page++);
    hasMore = response.next != null;

    setState(() {
      isLoading = false;
      _parts.addAll(response.results);
    });
  }

  Future<String> loadApiKey() async => await LocalStorage().getApiKey();
}