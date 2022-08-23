import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class RecordFields {
  static final String email = 'email';
  static final String time = 'time';
  static final String coordinates = 'coord';

  static List<String> getFields() => [email, time, coordinates];
}

class RecordModel {
  String email;
  TimeOfDay time;
  Position position;

  RecordModel({
    required this.email,
    required this.time,
    required this.position,
  });

  Map<String, dynamic> toJson(BuildContext context) {
    return {
      RecordFields.email: this.email,
      RecordFields.time: this.time.format(context),
      RecordFields.coordinates:
          "${this.position.latitude.ceil()}'${this.position.longitude.ceil()}''"
    };
  }
}
