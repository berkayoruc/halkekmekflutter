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

  Stack buildFlutterMap(AsyncSnapshot<List<Buffet>> snapshot) {
    return Stack(children: [
      FlutterMap(
        options: MapOptions(
            center: LatLng(41, 29),
            zoom: 10,
            maxZoom: 18,
            minZoom: 8,
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            nePanBoundary: LatLng(41.684782, 29.934943),
            swPanBoundary: LatLng(40.705140, 28.012335),
            plugins: [
              MarkerClusterPlugin(),
            ],
            onTap: (_, x) {
              if (popupController.selectedMarkers.isNotEmpty) {
                popupController.hideAllPopups();
              }
            }),
        children: [
          TileLayerWidget(
              options: TileLayerOptions(
            urlTemplate:
                "https://stamen-tiles.a.ssl.fastly.net/terrain/{z}/{x}/{y}.jpg",
            subdomains: ['a', 'b', 'c'],
          )),
          MarkerClusterLayerWidget(
              options: buildMarkerClusterLayerOptions(snapshot))
        ],
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 16, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.35),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.95),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  onPressed: () {
                    var a = "s";
                  },
                  child: Icon(
                    Icons.menu,
                    color: Colors.grey[850],
                  )),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.fromLTRB(0, 80, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.35),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.95),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)))),
                  onPressed: () {
                    var a = "s";
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.grey[850],
                  )),
            ),
          ],
        ),
      ),
      Positioned(
        width: MediaQuery.of(context).size.width,
        bottom: 0,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.35),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.95),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)))),
                    onPressed: () {
                      var a = "s";
                    },
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.grey[850],
                    )),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.35),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.95),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(16)))),
                    onPressed: () {
                      var a = "s";
                    },
                    child: Icon(
                      Icons.near_me,
                      color: Colors.grey[850],
                    )),
              ),
            ],
          ),
        ),
      )
    ]);
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
          margin: const EdgeInsets.only(bottom: 4),
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
