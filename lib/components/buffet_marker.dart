import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BuffetMarker extends Marker {
  final String name;
  final String district;
  final String neighborhood;

  BuffetMarker(
      {required LatLng point,
      required WidgetBuilder builder,
      double width = 30,
      double height = 30,
      required AnchorPos anchorPos,
      required this.name,
      required this.district,
      required this.neighborhood})
      : super(
            point: point,
            builder: builder,
            width: width,
            height: height,
            anchorPos: anchorPos);
}
