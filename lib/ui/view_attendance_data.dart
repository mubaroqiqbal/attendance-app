import 'package:attendance_app/stores/map_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewAttendanceData extends StatefulWidget {
  const ViewAttendanceData({Key? key}) : super(key: key);

  @override
  State<ViewAttendanceData> createState() => _ViewAttendanceDataState();
}

class _ViewAttendanceDataState extends State<ViewAttendanceData> {
  final MapStore _mapStore = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          centerTitle: true,
          title: const Text("Attendance Data"),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: ListView.builder(
              itemCount: _mapStore.listAttendaceData.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_mapStore.listAttendaceData[index].address),
                    subtitle: Text("lat: " +
                        _mapStore.listAttendaceData[index].latitude.toString() +
                        ", long: " +
                        _mapStore.listAttendaceData[index].longitude.toString()),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
