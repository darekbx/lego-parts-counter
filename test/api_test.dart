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

  test('Test serach by set number', () async {
    var credentials = await _readCredentials();
    var rebrickable = RebrickableApi(credentials["api_key"]);
    var result = await rebrickable.searchSets("42055", 1);
    expect(result.results.length, 1);
    expect(result.results[0].name, "Bucket Wheel Excavator");
  });

  test('Test search by part number', () async {
    var credentials = await _readCredentials();
    var rebrickable = RebrickableApi(credentials["api_key"]);
    var result = await rebrickable.searchPart("6020");
    expect(result.name, "Bar 7 x 3 with Double Clips (Ladder)");
  });

  test('Test part sets list', () async {
    var credentials = await _readCredentials();
    var rebrickable = RebrickableApi(credentials["api_key"]);
    var result = await rebrickable.fetchPartSets("6020", 0, 1);
    expect(result.results.length, 100);
    expect(result.results[0].name, "Caboose");
  });

  test('Test set parts list', () async {
    var credentials = await _readCredentials();
    var rebrickable = RebrickableApi(credentials["api_key"]);
    var result = await rebrickable.fetchSetParts("42055-1", 1);
    expect(result.results.length, 100);
    expect(result.results[0].quantity, 4);
  });

  test('Test part color list', () async {
    var credentials = await _readCredentials();
    var rebrickable = RebrickableApi(credentials["api_key"]);
    var result = await rebrickable.fetchPartColors("6020", 1);
    expect(result.results.length, 14);
    expect(result.results[0].colorName, "Black");
  });
}
