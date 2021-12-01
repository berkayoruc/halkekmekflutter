import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:halkekmek/components/buffet_marker.dart';
import 'package:halkekmek/core/models/ihe.dart';
import 'package:halkekmek/core/services/ihe.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  PopupController popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Buffet>>(
      future: getBuffets(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                  center: LatLng(41, 29),
                  zoom: 10.0,
                  interactiveFlags:
                      InteractiveFlag.all & ~InteractiveFlag.rotate,
                  onTap: (_, x) {
                    if (popupController.selectedMarkers.isNotEmpty) {
                      popupController.hideAllPopups();
                    }
                  }),
              children: [
                TileLayerWidget(
                    options: TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                )),
                MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                        popupOptions: PopupOptions(
                          popupController: popupController,
                          popupBuilder: (context, marker) {
                            final buffetMarker = marker as BuffetMarker;
                            return Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Colors.white,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    print(buffetMarker.name);
                                  },
                                  child: RichText(
                                      text: TextSpan(children: [
                                    const TextSpan(
                                        text: 'İHE Büfe\n',
                                        style: TextStyle(
                                            color: Color(0xFF9AA6B5),
                                            fontSize: 10,
                                            fontFamily: 'MarkPro')),
                                    TextSpan(
                                        text: buffetMarker.name,
                                        style: const TextStyle(
                                            color: Color(0xFF323F4B),
                                            fontSize: 12,
                                            fontFamily: 'MarkPro')),
                                  ]))),
                            );
                          },
                          markerTapBehavior:
                              MarkerTapBehavior.togglePopupAndHideRest(),
                        ),
                        showPolygon: false,
                        maxClusterRadius: 50,
                        size: const Size(40, 40),
                        fitBoundsOptions: const FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                        ),
                        markers: getMarkers(snapshot.data),
                        builder: (context, markers) {
                          return FloatingActionButton(
                            heroTag: null,
                            onPressed: null,
                            backgroundColor: Colors.orange,
                            child: Text(markers.length.toString()),
                          );
                        }))
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
