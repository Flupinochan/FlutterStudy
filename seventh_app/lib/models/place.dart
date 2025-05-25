import 'dart:io';

import 'package:uuid/uuid.dart';

// uuidでidは自動生成
const uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}

class Place {
  // IDなし、ID自動生成
  Place({required this.title, required this.image, required this.location})
    : id = uuid.v4();

  // IDあり、ID指定
  Place.withId({
    required this.id,
    required this.title,
    required this.image,
    required this.location,
  });

  final String id;
  final String title;
  final File image;
  final PlaceLocation location;
}
