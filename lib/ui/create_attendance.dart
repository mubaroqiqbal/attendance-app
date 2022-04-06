import 'dart:async';
import 'dart:convert';

import 'package:attendance_app/models/pinned_area_data.dart';
import 'package:attendance_app/stores/map_store.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateAttendance extends StatefulWidget {
  const CreateAttendance({Key? key}) : super(key: key);

  @override
  State<CreateAttendance> createState() => CreateAttendanceState();
}

class CreateAttendanceState extends State<CreateAttendance> {
  final MapStore _mapStore = Get.find();
  final Completer<GoogleMapController> _controller = Completer();

  String? address;

  late LatLng _initialPosition;

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final location = await Geolocator.getCurrentPosition();
      _initialPosition = LatLng(location.latitude, location.longitude);
      _isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    tilt: 59,
                    zoom: 18,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  onCameraIdle: () async {
                    final List<Placemark> placemark = await placemarkFromCoordinates(_initialPosition.latitude, _initialPosition.longitude);

                    final Placemark placeMark = placemark[0];
                    final String? subLocality = placeMark.subLocality;
                    final String? locality = placeMark.locality;
                    final String? administrativeArea = placeMark.administrativeArea;
                    final String? postalCode = placeMark.postalCode;
                    final String? country = placeMark.country;
                    final String? thoroughfare = placeMark.thoroughfare;
                    final String? subThoroughfare = placeMark.subThoroughfare;
                    final String? jalan = (thoroughfare?.isNotEmpty ?? false) ? "${thoroughfare}," : "";
                    final String? subJalan = (subThoroughfare?.isNotEmpty ?? false) ? "${subThoroughfare}," : "";
                    address = "${jalan} ${subJalan} ${subLocality}, ${locality}, ${administrativeArea} ${postalCode}, ${country}";

                    debugPrint(address);
                  },
                  zoomControlsEnabled: false,
                  scrollGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(Icons.clear),
                  )),
            ),
            const Align(
              child: Icon(
                Icons.location_on,
                size: 40,
                color: Colors.red,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _saveLocation,
          label: Text('Check In'.toUpperCase()),
          icon: const Icon(Icons.location_pin),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> _saveLocation() async {
    final distanceInMeters = Geolocator.distanceBetween(
      _mapStore.pinnedAreaData.value.latitude,
      _mapStore.pinnedAreaData.value.longitude,
      _initialPosition.latitude,
      _initialPosition.longitude,
    );

    if (distanceInMeters <= 50) {
      _mapStore.listAttendaceData.add(
        PinnedAreaData(
          address: address ?? "",
          latitude: _initialPosition.latitude,
          longitude: _initialPosition.longitude,
        ),
      );

      print(_mapStore.listAttendaceData.length);
      print(json.encode(_mapStore.listAttendaceData));
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: "Jarak lokasi Check In dengan area absen melebihi 50 Meter",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 14.0);
    }
  }
}
