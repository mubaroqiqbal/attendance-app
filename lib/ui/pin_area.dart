import 'dart:async';

import 'package:attendance_app/models/pinned_area_data.dart';
import 'package:attendance_app/stores/map_store.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinArea extends StatefulWidget {
  final ValueSetter<PinnedAreaData> callback;

  const PinArea({required this.callback});

  @override
  State<PinArea> createState() => PinAreaState();
}

class PinAreaState extends State<PinArea> {
  final MapStore _mapStore = Get.find();
  final Completer<GoogleMapController> _controller = Completer();

  String? address;

  late LatLng _initialPosition; // = LatLng(-6.97828, 107.63);

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (_mapStore.pinnedAreaData.value.latitude != 0 && _mapStore.pinnedAreaData.value.longitude != 0) {
        _initialPosition = LatLng(_mapStore.pinnedAreaData.value.latitude, _mapStore.pinnedAreaData.value.longitude);
      } else {
        final location = await Geolocator.getCurrentPosition();
        _initialPosition = LatLng(location.latitude, location.longitude);
      }
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
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    tilt: 59,
                    zoom: 18,
                  ),
                  onCameraMove: (CameraPosition position) async {
                    _initialPosition = position.target;
                  },
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
                    child: const Icon(Icons.clear),
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
          label: const Text('Pin Location'),
          icon: const Icon(Icons.location_pin),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> _saveLocation() async {
    widget.callback(PinnedAreaData(
      address: address ?? "",
      latitude: _initialPosition.latitude,
      longitude: _initialPosition.longitude,
    ));
    Navigator.pop(context);
  }
}
