import 'package:attendance_app/models/pinned_area_data.dart';
import 'package:get/get.dart';

class MapStore extends GetxController {
  var pinnedAreaData = PinnedAreaData().obs;

  List<PinnedAreaData> listAttendaceData = <PinnedAreaData>[].obs;
}
