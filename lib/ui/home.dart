import 'package:attendance_app/models/pinned_area_data.dart';
import 'package:attendance_app/stores/map_store.dart';
import 'package:attendance_app/ui/create_attendance.dart';
import 'package:attendance_app/ui/pin_area.dart';
import 'package:attendance_app/utils/app_permissions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final MapStore _mapStore = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    AppPermissions.request(Permission.locationWhenInUse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text("Attendance Master Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text("Address:"),
            ),
            Center(
              child: Text(_mapStore.pinnedAreaData.value.address, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text("Latitude: " + _mapStore.pinnedAreaData.value.latitude.toString()),
            ),
            Center(
              child: Text("Longitude: " + _mapStore.pinnedAreaData.value.longitude.toString()),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PinArea(callback: _callback);
                  }));
                },
                icon: const Icon(Icons.location_pin),
                label: const Text("Pin Attendance Area"),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PinArea(callback: _callback);
                  }));
                },
                icon: const Icon(Icons.history),
                label: const Text("View Attendance Data"),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_mapStore.pinnedAreaData.value.latitude != 0 &&
              _mapStore.pinnedAreaData.value.longitude != 0 &&
              _mapStore.pinnedAreaData.value.address.isNotEmpty) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CreateAttendance();
            }));
          } else {
            Fluttertoast.showToast(
                msg: "Silahkan Pin Attendance Area terlebih dahulu",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 14.0);
          }
        },
        label: Text('Create Attendance'.toUpperCase()),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _callback(PinnedAreaData value) => setState(() {
        _mapStore.pinnedAreaData.value = value;
      });
}
