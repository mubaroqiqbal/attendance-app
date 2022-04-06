import 'package:attendance_app/ui/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'stores/map_store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final MapStore _mapStore = Get.put(MapStore());

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Attendance App',
      home: Home(),
    );
  }
}
