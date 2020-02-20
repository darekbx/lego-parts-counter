import 'package:flutter/material.dart';
import 'package:lego_parts_counter/rebrickable/baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/set.dart';

class SetList extends StatelessWidget {

  BaseResponse<Set> contents;

  SetList(this.contents);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contents.count,
      itemBuilder: (context, index) {
        var result = contents.results[index];
        return
          Card(child: ListTile(
            leading: Image.network(result.imageUrl),
            title: Text("${result.number} ${result.name}"),
            subtitle: Text(
                "Year: ${result.year}, Parts count: ${result.partsCount}"),
          ));
      },
    );
  }
}