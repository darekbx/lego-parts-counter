import 'package:flutter_test/flutter_test.dart';

import 'package:lego_parts_counter/rebrickable/rebrickableapi.dart';

import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main() {

  Future<dynamic> _readCredentials() async {
    final contents = await File('credentials.json').readAsString();
    return jsonDecode(contents);
  }

  test('Test set list', () async {
    var credentials = await _readCredentials();
    var rebrickable = RebrickableApi(credentials["api_key"]);
    var result = await rebrickable.sets("42055", 1);
    expect(result.results.length, 1);
    expect(result.results[0].name, "Bucket Wheel Excavator");
  });

  test('Test set parts list', () async {
    var credentials = await _readCredentials();
    var rebrickable = RebrickableApi(credentials["api_key"]);
    var result = await rebrickable.setParts("42055-1", 1);
    expect(result.results.length, 100);
    expect(result.results[0].quantity, 4);
  });
}
