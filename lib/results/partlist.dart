import 'package:flutter/material.dart';
import 'package:lego_parts_counter/rebrickable/model/part.dart';
import 'package:lego_parts_counter/utils/partdialog.dart';

class PartList extends StatelessWidget {

  Part result;

  PartList(this.result);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return
          Card(child: ListTile(
            leading: SizedBox(width: 80, child: Image.network(result.partImgUrl)),
            title: Text("${result.partNum} ${result.name}"),
            subtitle: Text(
                "Years: ${result.yearFrom} -  ${result.yearTo}"),
            onTap: () { PartDialog(context).showPartDialog(result); },
          ));
      },
    );
  }
}