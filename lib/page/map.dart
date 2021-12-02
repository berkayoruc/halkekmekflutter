import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:halkekmek/components/buffet_marker.dart';
import 'package:halkekmek/core/models/ihe.dart';
import 'package:halkekmek/core/services/ihe.dart';
import 'package:halkekmek/core/services/open_map_launcher.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  PopupController popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IHE'),
      ),
      body: FutureBuilder<List<Buffet>>(
        future: getBuffets(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return buildFlutterMap(snapshot);
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
      ),
    );
  }

  FlutterMap buildFlutterMap(AsyncSnapshot<List<Buffet>> snapshot) {
    return FlutterMap(
      options: MapOptions(
          plugins: [
            MarkerClusterPlugin(),
          ],
          center: LatLng(41, 29),
          zoom: 10.0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          onTap: (_, x) {
            if (popupController.selectedMarkers.isNotEmpty) {
              popupController.hideAllPopups();
            }
          }),
      children: [
        TileLayerWidget(
            options: TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        )),
        MarkerClusterLayerWidget(
            options: buildMarkerClusterLayerOptions(snapshot))
      ],
    );
  }

  MarkerClusterLayerOptions buildMarkerClusterLayerOptions(
      AsyncSnapshot<List<Buffet>> snapshot) {
    return MarkerClusterLayerOptions(
        showPolygon: false,
        maxClusterRadius: 50,
        size: const Size(40, 40),
        fitBoundsOptions: const FitBoundsOptions(
          padding: EdgeInsets.all(50),
        ),
        markers: getMarkers(snapshot.data),
        popupOptions: buildPopupOptions(),
        builder: (context, markers) => buildClusterMarker(markers));
  }

  PopupOptions buildPopupOptions() {
    return PopupOptions(
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
              onTap: () => openMapSheet(context, marker.point.latitude,
                  marker.point.longitude, marker.name),
              child: buildPopupContent(buffetMarker)),
        );
      },
      markerTapBehavior: MarkerTapBehavior.togglePopupAndHideRest(),
    );
  }
}
