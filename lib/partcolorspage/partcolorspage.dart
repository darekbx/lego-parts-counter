import 'package:flutter/material.dart';
import 'package:lego_parts_counter/rebrickable/model/color.dart';
import 'package:lego_parts_counter/rebrickable/rebrickableapi.dart';
import 'package:lego_parts_counter/setslist/setslistpage.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';

class PartColorsPage extends StatefulWidget {

  String partNumber;

  PartColorsPage(this.partNumber);

  @override
  _PartColorsPageState createState() => _PartColorsPageState();
}

class _PartColorsPageState extends State<PartColorsPage> {

  ScrollController _scrollController = new ScrollController();

  List<Color> _colors = List();
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
            title: Text("Lego Part Colors - for ${widget.partNumber}")
        ),
        body: _buildList(),
        resizeToAvoidBottomPadding: false
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: _colors.length + 1 /* For progress */,
      controller: _scrollController,
      itemBuilder: (context, index) {
        if (index == _colors.length) {
          return _buildProgressIndicator();
        } else {
          var result = _colors[index];
          return
            Card(child: ListTile(
                leading: SizedBox(
                    width: 80, child: Image.network(result.partImgUrl)),
                title: Text("${result.colorName}"),
                subtitle: Text("In sets: ${result.numSets}", style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue)),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      SetsListPage(widget.partNumber, result.colorId))); }
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
    var response = await RebrickableApi(apiKey).fetchPartColors(widget.partNumber, page++);
    hasMore = response.next != null;

    var filtered = response.results.where((color) => color.numSets > 0);
    setState(() {
      isLoading = false;
      _colors.addAll(filtered);
    });
  }

  Future<String> loadApiKey() async => await LocalStorage().getApiKey();
}