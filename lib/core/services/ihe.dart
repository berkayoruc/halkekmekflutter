import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:halkekmek/components/buffet_marker.dart';
import 'package:halkekmek/core/models/ihe.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../constant.dart';

Future<List<Buffet>> getBuffets() async {
  var headers = {'Access-Control-Allow-Origin': '*'};
  final response = await http.get(Uri.parse(buffetUrl), headers: headers);
  return compute(parseBuffets, [response.body]);
}

List<Buffet> parseBuffets(List<dynamic> arguments) {
  final body = arguments.elementAt(0);
  final parsed = jsonDecode(body)['result']['records'];
  List<Buffet> values = [];
  if (parsed != null) {
    values = parsed
        .map<Buffet>((e) => Buffet(
            int.parse(e['_id'].toString()),
            e['Ilce_Adi'],
            e['Mahalle_Adi'],
            e['Bufe_Adi'],
            e['Enlem'],
            e['Boylam']))
        .toList();
  }
  return values;
}

List<BuffetMarker> getMarkers(List<Buffet>? buffets) {
  return buffets!
      .map<BuffetMarker>((e) => BuffetMarker(
          builder: (ctx) => buildMarker(),
          name: e.name,
          district: e.district,
          neighborhood: e.neighborhood,
          anchorPos: AnchorPos.align(AnchorAlign.center),
          point: LatLng(double.parse(e.latitude.replaceAll(' ', '')),
              double.parse(e.longitude.replaceAll(' ', '')))))
      .toList();
}

FloatingActionButton buildMarker() {
  return FloatingActionButton(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      heroTag: null,
      onPressed: null,
      backgroundColor: Colors.grey[800],
      child: const Icon(
        Icons.bakery_dining,
        color: Colors.white,
      ));
}

FloatingActionButton buildClusterMarker(List<Marker> markers) {
  return FloatingActionButton(
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    heroTag: null,
    onPressed: null,
    backgroundColor: Colors.grey[850],
    child: Text(
      markers.length.toString(),
      style: const TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

RichText buildPopupContent(BuffetMarker buffetMarker) {
  return RichText(
      text: TextSpan(children: [
    TextSpan(
        text:
            '${buffetMarker.district[0].toUpperCase()}${buffetMarker.district.substring(1).toLowerCase()}\n',
        style: const TextStyle(color: Color(0xFF9AA6B5), fontSize: 10)),
    TextSpan(
        text: buffetMarker.name,
        style: const TextStyle(
            color: Color(0xFF323F4B),
            fontSize: 12,
            fontWeight: FontWeight.w700)),
  ]));
}
