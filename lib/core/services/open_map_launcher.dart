import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

void openMapSheet(context, lat, lng, title) async {
  try {
    final availableMaps = await MapLauncher.installedMaps;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
              child: SingleChildScrollView(
            child: Wrap(
              children: availableMaps
                  .map<ListTile>((e) => ListTile(
                        onTap: () => e.showMarker(
                            coords: Coords(lat, lng), title: title),
                        title: Text(e.mapName),
                      ))
                  .toList(),
            ),
          ));
        });
  } catch (e) {
    debugPrint(e.toString());
  }
}
