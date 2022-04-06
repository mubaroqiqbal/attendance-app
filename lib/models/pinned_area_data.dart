import 'package:json_annotation/json_annotation.dart';

part 'pinned_area_data.g.dart';

@JsonSerializable()
class PinnedAreaData {
  String address;
  double latitude;
  double longitude;

  PinnedAreaData({this.address = "", this.latitude = 0, this.longitude = 0});

  factory PinnedAreaData.fromJson(Map<String, dynamic> json) => _$PinnedAreaDataFromJson(json);

  Map<dynamic, dynamic> toJson() => _$PinnedAreaDataToJson(this);
}
