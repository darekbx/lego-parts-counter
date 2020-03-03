import 'package:flutter/material.dart';
import 'package:lego_parts_counter/rebrickable/baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/set.dart';
import 'package:lego_parts_counter/rebrickable/rebrickableapi.dart';
import 'package:lego_parts_counter/results/setlist.dart';
import 'package:lego_parts_counter/storage/localstorage.dart';

class SetsListPage extends StatefulWidget {

  String partNumber;
  int partColor;

  SetsListPage(this.partNumber, this.partColor);

  @override
  _SetsListState createState() => _SetsListState();
}

class _SetsListState extends State<SetsListPage> {

  ScrollController _scrollController = new ScrollController();

  List<Set> _sets = List<Set>();
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
            title: Text("Lego Sets - for ${widget.partNumber} & ${widget.partColor}")
        ),
        body: SetList(BaseResponse<Set>(this._sets.length, null, this._sets)),
        resizeToAvoidBottomPadding: false
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
    var response = await RebrickableApi(apiKey)
        .fetchPartSets(widget.partNumber, widget.partColor, page++);
    hasMore = response.next != null;

    setState(() {
      isLoading = false;
      response.results.forEach((item) => _sets.add(item));
    });
  }

  Future<String> loadApiKey() async => await LocalStorage().getApiKey();
}