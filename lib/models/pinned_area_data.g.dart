// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_area_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PinnedAreaData _$PinnedAreaDataFromJson(Map<String, dynamic> json) {
  return PinnedAreaData(
    address: json['address'] as String,
    latitude: (json['latitude'] as num).toDouble(),
    longitude: (json['longitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _$PinnedAreaDataToJson(PinnedAreaData instance) =>
    <String, dynamic>{
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
