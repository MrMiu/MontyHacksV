import 'package:flutter/material.dart';

class County {
  
  final String name;
  final Color? color;
  final double latitude;
  final double longitude;
  final double? fire;

  County({required this.name,  this.color, required this.latitude, required this.longitude, this.fire});
}
