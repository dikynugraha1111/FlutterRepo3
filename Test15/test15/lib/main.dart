import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/routing.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: DikyMap());
  }
}

class DikyMap extends StatefulWidget {
  @override
  _DikyMapState createState() => _DikyMapState();
}

class _DikyMapState extends State<DikyMap> {
  HereMapController _controller;
  MapPolyline _mapPolyline;

  List<GeoCoordinates> places; // untuk koordinat tempat tempat
  List<MapMarker> markers; // untuk memindahkan marker ke lokasi yang terdekat
  GeoCoordinates initialLocation =
      GeoCoordinates(-7.8332349, 110.3809325); // untuk lokasi awal dari user

  Future<MapMarker> drawMarker(HereMapController hereMapController,
      int drawOrder, GeoCoordinates geoCoordinates,
      {String path = "'assets/circle.png'"}) async {
    ByteData fileData = await rootBundle.load(path); //upload data
    Uint8List pixelData =
        fileData.buffer.asUint8List(); //merubah menjadi integer 8 bit
    MapImage mapImage = MapImage.withPixelDataAndImageFormat(
        pixelData, ImageFormat.png); // format dengan png
    MapMarker mapMarker =
        MapMarker(geoCoordinates, mapImage); //Taruh gambar di tempat - Marker
    mapMarker.drawOrder = drawOrder;
    hereMapController.mapScene.addMapMarker(mapMarker);

    return mapMarker;
  }

  Future<void> drawPin(HereMapController hereMapController, int drawOrder,
      GeoCoordinates geoCoordinates) async {
    ByteData fileData = await rootBundle.load('assets/poi.png'); //upload data
    Uint8List pixelData =
        fileData.buffer.asUint8List(); //merubah menjadi integer 8 bit
    MapImage mapImage = MapImage.withPixelDataAndImageFormat(
        pixelData, ImageFormat.png); // format dengan png
    Anchor2D anchor2d =
        Anchor2D.withHorizontalAndVertical(0.5, 1); // taruh ancor
    MapMarker mapMarker = MapMarker.withAnchor(
        geoCoordinates, mapImage, anchor2d); //Taruh gambar di tempat - Marker
    mapMarker.drawOrder = drawOrder;
    hereMapController.mapScene.addMapMarker(mapMarker);
  }

  Future<void> drawRoute(GeoCoordinates start, GeoCoordinates end,
      HereMapController hereMapController) async {
    //Buat routing engine
    RoutingEngine routingEngine = RoutingEngine();

    // Buat way point
    Waypoint startWayPoint = Waypoint.withDefaults(start);
    Waypoint endWayPoint = Waypoint.withDefaults(end);
    List<Waypoint> wayPoint = [startWayPoint, endWayPoint];

    // Hitung route nya
    routingEngine.calculateCarRoute(wayPoint, CarOptions.withDefaults(),
        (routingError, routes) {
      // cek adakah error di routing
      if (routingError == null) {
        var route = routes.first;
        // Buat polylinenya
        GeoPolyline routeGeoPolyline = GeoPolyline(route.polyline);
        // Buat visual representasi untuk geopolyline
        double depth = 20.0; //ketebalan garis
        _mapPolyline = MapPolyline(routeGeoPolyline, depth, Colors.blue);
        // pasang di controller untuk dipasang dipeta
        hereMapController.mapScene.addMapPolyline(_mapPolyline);
      }
    });
  }

  @override
  void dispose() {
    _controller?.finalize();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    places = [
      GeoCoordinates(
        -7.828743,
        110.3790996,
      ),
      GeoCoordinates(-7.8279915, 110.3797369),
      GeoCoordinates(-7.8269092, 110.3798583),
      GeoCoordinates(-7.830238, 110.384977)
    ];
    markers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Here Map"),
      ),
      body: new Column(children: [
        SizedBox(
            width: double.infinity,
            height: 500.0,
            child: HereMap(onMapCreated: _onMapCreated)),
        RaisedButton(
          onPressed: () {
            // ini untuk clear routing antar locationnnya
            // if (_mapPolyline != null) {
            //   _controller.mapScene.removeMapPolyline(_mapPolyline);
            //   _mapPolyline = null;
            // }

            // ini Untuk sort jarak terdekat serta membandingkan jarak terdekat dengan user
            markers.sort((value1, value2) => initialLocation
                .distanceTo(value1.coordinates)
                .compareTo(initialLocation.distanceTo(value2.coordinates)));

            //ini untuk menghilangkan marker pada coordinate paling dekat dengan user
            _controller.mapScene.removeMapMarker(markers[0]);

            drawMarker(_controller, 0, markers[0].coordinates,
                path: "assets/poi.png");
          },
          child: new Text("Clear Route"),
        )
      ]),
    );
  }

  void _onMapCreated(HereMapController hereMapController) {
    _controller = hereMapController;

    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      drawMarker(hereMapController, 0, initialLocation);
      drawPin(hereMapController, 1, initialLocation);

      // ini untuk rute kejalur yang ditentukan
      // drawRoute(GeoCoordinates(-7.8332349, 110.3809325),
      //     GeoCoordinates(-7.830238, 110.384977), hereMapController);

      //perulangan untuk memberi marker pada tiap lokasi
      places.forEach((element) {
        drawMarker(hereMapController, 0, element)
            .then((value) => markers.add(value));
      });

      const double distanceToEarthInMeters = 20000;
      hereMapController.camera
          .lookAtPointWithDistance(initialLocation, distanceToEarthInMeters);
    });
  }
}
