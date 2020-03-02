import 'package:flutter/material.dart';
import 'package:lego_parts_counter/partdetails/partdetailspage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lego_parts_counter/rebrickable/baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/setpart.dart';
import 'package:lego_parts_counter/rebrickable/rebrickableapi.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';

class SetPartsPage extends StatefulWidget {

  String setNumber;

  SetPartsPage(this.setNumber);

  @override
  _SetPartsPageState createState() => _SetPartsPageState();
}

class _SetPartsPageState extends State<SetPartsPage> {

  ScrollController _scrollController = new ScrollController();
  BaseResponse<SetPart> contents;

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
              onTap: () { _showPartDialog(result); },
            ));
        }
      },
    );
  }

  _showPartDialog(SetPart setPart) async {
    _showLoadingDialog();

    var apiKey = await loadApiKey();
    var response = await RebrickableApi(apiKey).searchPart(
        "${setPart.part.partNum}");

    // close loading dialog
    Navigator.pop(context);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(setPart.part.name),

              content: Container(
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(child: SizedBox(
                        width: 80, child: Image.network(response.partImgUrl))),
                    InkWell(
                        child: Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            child: Text("Open in browser",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue))
                        ),
                        onTap: () => _launchURL(response.partUrl)),
                    Row(children: <Widget>[
                      Text("Part num: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${response.partNum}"),
                    ]),
                    Row(children: <Widget>[
                      Text("Years: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${response.yearFrom} -  ${response.yearTo}"),
                    ]),
                    Row(children: <Widget>[
                      Text("In sets: ",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      InkWell(
                        child: Text("${setPart.numSets}",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) =>
                              PartDetailsPage(response.partNum)));
                        },
                      ),
                    ])
                  ],
                ),
              ));
        });
  }

  void _showLoadingDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Loading..."),
            content: Container(
                height: 100,
                child: Center(child: CircularProgressIndicator())
            ),
          );
        }
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}