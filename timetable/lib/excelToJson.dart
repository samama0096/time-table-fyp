import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<Map<String, dynamic>> extractDataFromExcel(
    {required Uint8List bytes, required String day}) {
  Excel excel = Excel.decodeBytes(bytes);
  final List<Map<String, dynamic>> result = [];
  final Map<String, dynamic> createMap = {};
  final keys = <String>[];
  print(excel.tables.keys.first);

  final int n = excel.tables[excel.tables.keys.first]?.rows.length ?? 0;
  debugPrint('n => $n');

  for (int i = 0; i < n; i++) {
    final rows = excel.tables[excel.tables.keys.first]!.rows[i];

    for (int j = 1; j < rows.length; j++) {
      final row = rows[j];
      // Create Header(Keys) for map
      if (i == 0 && row != null) {
        // get header/key from excel and make it list
        keys.add('${row.value}'); // Store key as string
        // Default value is empty
        createMap['${row.value}'] = "";
      } else if (row == null) {
        keys.add('day');
      }
      // add value in map
      else if (i > 0) {
        createMap[keys[j]] = row.value;
      }
    }

    if (i != 0) result.add(Map<String, dynamic>.from(createMap));
  }
  return result;
}
