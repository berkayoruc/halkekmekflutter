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

FloatingActionButton buildFab() {
  return const FloatingActionButton(
      heroTag: null,
      onPressed: null,
      backgroundColor: Colors.deepOrangeAccent,
      child: Icon(
        Icons.location_on,
        color: Colors.white,
      ));
}

List<BuffetMarker> getMarkers(List<Buffet>? buffets) {
  return buffets!
      .map<BuffetMarker>((e) => BuffetMarker(
          builder: (ctx) => buildFab(),
          name: e.name,
          district: e.district,
          neighborhood: e.neighborhood,
          anchorPos: AnchorPos.align(AnchorAlign.center),
          point: LatLng(double.parse(e.latitude.replaceAll(' ', '')),
              double.parse(e.longitude.replaceAll(' ', '')))))
      .toList();
}
