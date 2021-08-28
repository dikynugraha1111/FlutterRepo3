import 'package:flutter/material.dart';
import 'package:test16/location_service_bloc.dart';
import 'package:test16/user_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: LiveLocation(),
    );
  }
}

class LiveLocation extends StatefulWidget {
  @override
  _LiveLocationState createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  LocationService locationService = LocationService();
  @override
  void dispose() {
    locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Live Location User")),
      body: new StreamBuilder<UserLocation>(
          stream: locationService.locationStream,
          builder: (_, data) => (data.hasData)
              ? new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Text("Latitude"),
                      new Text("${data.data.latitude}"),
                      new Text("Longtitude"),
                      new Text("${data.data.longtitude}"),
                    ],
                  ),
                )
              : new Text("ERROR NO DATA")),
    );
  }
}
