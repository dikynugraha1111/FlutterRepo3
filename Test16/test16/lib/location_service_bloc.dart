import 'package:location/location.dart';
import 'user_location.dart';
import 'dart:async';

class LocationService {
  Location location = Location();
  StreamController<UserLocation> _locationStreamController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationStreamController.stream;

  LocationService() {
    location.requestPermission().then((permissionStatus) => {
          if (permissionStatus == PermissionStatus.granted)
            {
              location.onLocationChanged.listen((locationData) {
                if (locationData != null) {
                  _locationStreamController.add(UserLocation(
                      locationData.latitude, locationData.longitude));
                }
              })
            }
        });
  }
  void dispose() => _locationStreamController.close();
}
