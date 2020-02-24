import 'package:flutter/material.dart';
import 'package:lego_parts_counter/rebrickable/baseresponse.dart';
import 'package:lego_parts_counter/rebrickable/model/set.dart';
import 'package:lego_parts_counter/results/setpartspage.dart';

class SetList extends StatelessWidget {

  BaseResponse<Set> contents;

  SetList(this.contents);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contents.results.length,
      itemBuilder: (context, index) {
        if (contents.next != null && index == contents.results.length - 1) {
          var diff = contents.count - contents.results.length;
          return Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                  "There are still $diff more sets, enter a more detailed query.",
                  style: TextStyle(fontWeight: FontWeight.bold))
          );
        } else {
          var result = contents.results[index];
          return
            Card(child: ListTile(
              leading: SizedBox(
                  width: 80, child: _image(result.imageUrl)),
              title: Text("${result.number} ${result.name}"),
              subtitle: Text(
                  "Year: ${result.year}, Parts count: ${result.partsCount}"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(
                    builder: (context) => SetPartsPage(result.number)));
              },
            ));
        }
      },
    );
  }

  Widget _image(String url) {
    if (url != null) {
      return Image.network(url);
    }
    else {
      return Icon( Icons.image);
    }
  }
}