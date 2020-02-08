import 'package:flutter/material.dart';

import 'package:lego_parts_counter/query/querypage.dart';

class LegoPartsCountApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lego Parts Count',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: QueryPage(),
    );
  }
}